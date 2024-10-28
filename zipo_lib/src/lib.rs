mod metrics;
mod rule;
mod setting;
use anyhow::ensure;

use crossbeam_queue::SegQueue;

use std::io::prelude::*;
use std::io::Write;
use std::iter::Iterator;
use std::ops::Deref;

use std::thread;

use zip::result::ZipError;
use zip::CompressionMethod;

use std::fs::{self, File};
use std::path::{self, Path, PathBuf};
use walkdir::WalkDir;

pub use metrics::{Metrics,NoMetrics};
pub use rule::{Rule, RuleSet};
pub use setting::Settings;

pub struct ZipDir {
    src_dir: PathBuf,
    dirs: SegQueue<PathBuf>,
    dst_dir: PathBuf,
    settings: Settings,
    rules: RuleSet,
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

        let dirs = SegQueue::new();

        src_dir
            .read_dir()?
            .filter_map(|e| e.ok())
            .map(|e| e.path())
            .filter(|p| p.is_dir())
            .for_each(|s| dirs.push(s));

        let dst_dir = dst_dir.as_ref();
        if !dst_dir.exists() {
            fs::create_dir_all(dst_dir)?;
        }
        let dst_dir = dst_dir.canonicalize()?;

        ensure!(dst_dir.is_dir(), "dst dir isn't dir");
        let mut rule_set = RuleSet::new();
        if let Some(rules) = &settings.rules {
            for rule in rules {
                let r = Rule::new(&rule.filename, rule.excludes.iter().map(|s| s.deref()));
                rule_set.push_rule(r);
            }
        }

        Ok(Self {
            src_dir,
            dirs,
            dst_dir,
            settings,
            rules: rule_set,
        })
    }

    pub fn run(&mut self, m: impl Metrics) {
        thread::scope(|s| {
            for _ in 0..num_cpus::get() {
                s.spawn({
                    let n = m.clone();
                    || loop {
                        let dir = match self.dirs.pop() {
                            Some(dir) => dir,
                            None => {
                                //captrue n
                                drop(n);
                                return;
                            }
                        };
                        if let Err(err) = self.zip_dir(&dir, &n) {
                            log::debug!("{:?}",err);
                        }
                    }
                });
            }
        });
        m.finish();
    }

    pub fn len(&self) -> usize {
        self.dirs.len()
    }
    fn zip_dir(&self, src_dir: &Path, m: &impl Metrics) -> anyhow::Result<()> {
        ensure!(src_dir.is_dir(), ZipError::FileNotFound);

        let (dst_file_path, rule) = self.rules.get_match_rule(src_dir, &self.dst_dir);

        let msg = format!(
            r#""{}" -> "{}""#,
            dunce::simplified(src_dir).display(),
            dunce::simplified(&dst_file_path).display()
        );

        {
            let walkdir = WalkDir::new(src_dir);
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

                let name = rule.transform_path(path, src_dir, self.settings.is_separate);

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

        m.tick(&msg);

        Ok(())
    }

    pub fn remove_dir(&mut self) -> anyhow::Result<Vec<PathBuf>> {
        let dirs = self
            .src_dir
            .read_dir()?
            .filter_map(|e| e.ok())
            .map(|e| e.path())
            .filter(|p| p.is_dir())
            .collect::<Vec<_>>();
        for dir in &dirs {
            fs::remove_dir_all(dir)?;
        }
        Ok(dirs)
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
