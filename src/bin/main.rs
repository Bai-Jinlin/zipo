use clap::{App, Arg};

use rayon::prelude::*;
use std::error::Error;
use std::fs;
use std::path::{Path, PathBuf};
use std::str::FromStr;
use zipo::zip_dir;

use indicatif::ProgressBar;
use regex::Regex;
use std::sync::Mutex;

struct Args {
    src: PathBuf,
    dst: PathBuf,
    pattern: Regex,
}


fn src_dir_name_process<P: AsRef<Path>>(path: P, re: &Regex) -> PathBuf {
    let path = path.as_ref();
    let dirname = path.parent().unwrap();
    let filename = path.file_name().unwrap();
    match re.captures(filename.to_str().unwrap()) {
        Some(cap) => {
            dirname.join(cap.get(1).unwrap().as_str())
        }
        None => { PathBuf::from(path) }
    }
}

fn doti(Args { src, dst, pattern }: Args) -> Result<(), Box<dyn Error>> {
    if !src.exists() {
        return Err(From::from("Directory Not Exist"));
    }
    if !dst.exists() {
        fs::create_dir(&dst)?;
    }

    // fs::read_dir(src)?
    //     .filter_map(|e| e.ok())
    //     .map(|e| e.path())
    //     .filter(|e|e.is_dir())
    //     .par_bridge()
    //     .for_each(|path| {
    //         let name = path.file_name().unwrap();
    //         zip_dir(&path, &dst, format!("{}.zip", name.to_str().unwrap())).unwrap();
    //     });
    let paths = fs::read_dir(src)?
        .filter_map(|e| e.ok())
        .map(|d| d.path())
        .filter(|p| p.is_dir())
        .collect::<Vec<_>>();
    let pb = Mutex::new(ProgressBar::new(paths.len() as u64));
    paths.par_iter().for_each(|path| {
        let path = src_dir_name_process(&path, &pattern);
        let name = path.file_name().unwrap();
        let dst_name=dst.join(format!("{}.zip", name.to_str().unwrap()));
        zip_dir(path, dst_name).unwrap();
        pb.lock().unwrap().inc(1);
    });
    Ok(())
}


fn get_args() -> Args {
    let matchs = App::new("zipo-rs")
        .version("0.1")
        .author("Bai-Jinlin <windowsbai@hotmail.com>")
        .arg(Arg::with_name("SOURCE").required(true))
        .arg(
            Arg::with_name("DEST")
                .short("o")
                .long("output")
                .takes_value(true),
        )
        .arg(Arg::with_name("PATTERN")
            .short("p")
            .long("pattern")
            .takes_value(true))
        .get_matches();
    let src_dir = matchs.value_of("SOURCE").unwrap();
    let dst_dir = matchs.value_of("DEST").unwrap_or(src_dir);
    // let pattern = matchs.value_of("PATTERN").unwrap_or(r"\d-(.*)");
    let pattern = matchs.value_of("PATTERN").unwrap_or(r"\.(.*)");

    Args {
        src: PathBuf::from_str(src_dir).unwrap(),
        dst: PathBuf::from_str(dst_dir).unwrap(),
        pattern: Regex::new(pattern).unwrap(),
    }
}

fn main() {
    let args = get_args();
    doti(args).unwrap();
}
