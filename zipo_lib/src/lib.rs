mod metrics;
mod settings;
use anyhow::ensure;

use std::io::prelude::*;
use std::io::Write;
use std::iter::Iterator;

use std::sync::Arc;
use std::sync::Mutex;
use std::thread;

use zip::result::ZipError;
use zip::CompressionMethod;

use std::fs::{self, File};
use std::path::{self, Path, PathBuf};
use walkdir::WalkDir;

pub use metrics::{Metrics, NoMetrics};
pub use settings::{Rule, RuleSet,Settings};

pub struct ZipDir {
    src_dir: PathBuf,
    dirs: Arc<Mutex<Vec<(usize, PathBuf)>>>,
    dst_dir: PathBuf,
    settings:Settings
}

impl ZipDir {
    pub fn new(
        src_dir: impl AsRef<Path>,
        dst_dir: impl AsRef<Path>,
        settings: Settings,
        //todo: Metrics kind
    ) -> anyhow::Result<Self> {
        let src_dir = src_dir.as_ref();
        ensure!(
            src_dir.exists() && src_dir.is_dir(),
            "src dir isn't dir or isn't exist"
        );

        //canonicalize need path exist
        let src_dir = src_dir.canonicalize()?;

        ensure!(!is_root(&src_dir), "src can't be root dir");

        let dirs = src_dir
            .read_dir()?
            .filter_map(|e| e.ok())
            .map(|e| e.path())
            .filter(|p| p.is_dir())
            .enumerate()
            .collect();
        let dirs = Arc::new(Mutex::new(dirs));

        let dst_dir = dst_dir.as_ref();
        if !dst_dir.exists() {
            fs::create_dir_all(dst_dir)?;
        }
        let dst_dir = dst_dir.canonicalize()?;

        ensure!(dst_dir.is_dir(), "dst dir isn't dir");
        // for rule in settings.rules {
        //     // let r = Rule::new(&rule.filename, rule.excludes.iter().map(|s| s.deref()));
        //     rule_set.push_rule(rule);
        // }

        Ok(Self {
            src_dir,
            dirs,
            dst_dir,
            settings
        })
    }

    pub fn get_src_dir(&self) -> Vec<String> {
        let mut v: Vec<(usize, String)> = self
            .dirs
            .lock()
            .unwrap()
            .iter()
            .map(|(i, p)| (*i, p.file_name().unwrap().to_string_lossy().into()))
            .collect::<Vec<_>>();
        v.sort_by_key(|(i, _)| *i);
        v.into_iter().map(|(_, p)| p).collect()
    }

    pub fn run(&mut self, m: impl Metrics) {
        thread::scope(|s| {
            for _ in 0..num_cpus::get() {
                s.spawn({
                    let n = m.clone();
                    || loop {
                        let dir = match self.dirs.lock().unwrap().pop() {
                            Some(dir) => dir,
                            None => {
                                //captrue n
                                drop(n);
                                return;
                            }
                        };
                        if let Err(err) = self.zip_dir(dir, &n) {
                            log::debug!("{:?}", err);
                        }
                    }
                });
            }
        });
        m.finish();
    }

    fn zip_dir(&self, (index, src_dir): (usize, PathBuf), m: &impl Metrics) -> anyhow::Result<()> {
        ensure!(src_dir.is_dir(), ZipError::FileNotFound);

        let (dst_file_path, rule) = self.settings.rules.get_match_rule(&src_dir, &self.dst_dir);

        let msg = format!(
            r#""{}" -> "{}""#,
            dunce::simplified(&src_dir).display(),
            dunce::simplified(&dst_file_path).display()
        );

        {
            let walkdir = WalkDir::new(&src_dir);
            let file = File::create(&dst_file_path)?;
            let mut zip = zip::ZipWriter::new(file);
            let options =
                zip::write::FileOptions::default().compression_method(CompressionMethod::Stored);

            let mut buffer = Vec::new();
            for entry in walkdir.into_iter().filter_map(|e| e.ok()) {
                let path = entry.path();
                if rule.match_excludes(path) {
                    continue;
                }

                let name = rule.transform_path(path, &src_dir, self.settings.is_separate);

                if path.is_file() {
                    zip.start_file(path_to_string(&name), options)?;
                    let mut f = File::open(path)?;

                    f.read_to_end(&mut buffer)?;
                    zip.write_all(&buffer)?;
                    buffer.clear();
                } else if !name.as_os_str().is_empty() {
                    zip.add_directory(path_to_string(&name), options)?;
                }
            }
            zip.finish()?;
        }

        m.tick(&msg, index);

        Ok(())
    }
}

fn path_to_string(path: &Path) -> String {
    let mut path_str = String::new();
    for component in path.components() {
        if let path::Component::Normal(os_str) = component {
            if !path_str.is_empty() {
                path_str.push('/');
            }
            path_str.push_str(&os_str.to_string_lossy());
        }
    }
    path_str
}

fn is_root(path: &Path) -> bool {
    let mut is_root = false;

    for c in path.components() {
        match c {
            path::Component::RootDir => is_root = true,
            _ => is_root = false,
        }
    }
    is_root
}

mod test {

    #[test]
    fn test_is_root() {
        use std::path::Path;

        use crate::is_root;
        let p1 = Path::new(r"C:\");
        let p2 = Path::new(r"C:\Users");
        let p3 = Path::new(r"C:\").canonicalize().unwrap();

        assert!(is_root(p1));
        assert!(!is_root(p2));
        assert!(is_root(&p3));
    }
}
