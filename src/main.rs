use clap::{App, Arg};

use rayon::prelude::*;
use std::error::Error;
use std::fs::{self, File};
use std::io::{Read, Write};
use std::path::{Path, PathBuf};
use std::str::FromStr;
use walkdir::WalkDir;

use zip::write::FileOptions;

struct Args {
    src: PathBuf,
    dst: PathBuf,
}

fn zip_dir<P1, P2, P3>(src_dir: P1, dst_dir: P2, filename: P3) -> zip::result::ZipResult<()>
where
    P1: AsRef<Path>,
    P2: AsRef<Path>,
    P3: AsRef<Path>,
{
    let mut buffer = Vec::new();
    let fullname = dst_dir.as_ref().join(filename);
    let fullname = File::create(fullname)?;

    let mut zip = zip::ZipWriter::new(fullname);
    let options = FileOptions::default().compression_method(zip::CompressionMethod::Stored);

    let it = WalkDir::new(&src_dir).into_iter();

    for entry in it.filter_map(|e| e.ok()) {
        let path = entry.path();
        let name = path.strip_prefix(&src_dir).unwrap();
        let name = name.display().to_string();
        if path.is_file() {
            zip.start_file(name, options)?;
            let mut f = File::open(path)?;
            f.read_to_end(&mut buffer)?;
            zip.write_all(&buffer)?;
            buffer.clear();
        } else if !name.is_empty(){
            zip.add_directory(name, options)?;
        }
    }
    zip.finish()?;
    Ok(())
}

fn doti(Args { src, dst }: Args) -> Result<(), Box<dyn Error>> {
    if !src.exists() {
        return Err(From::from("Directory Not Exist"));
    }
    if !dst.exists() {
        fs::create_dir(&dst)?;
    }

    // let paths = std::fs::read_dir(src)?
    //     .filter_map(|e| e.ok())
    //     .map(|e| e.path())
    //     .collect::<Vec<_>>();
    // let pb = ProgressBar::new(paths.len() as u64);
    fs::read_dir(src)?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|e|e.is_dir())
        .par_bridge()
        .for_each(|path| {
            let name = path.file_name().unwrap();
            zip_dir(&path, &dst, format!("{}.zip", name.to_str().unwrap())).unwrap();
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
        .get_matches();
    let src_dir = matchs.value_of("SOURCE").unwrap();
    let dst_dir = matchs.value_of("DEST").unwrap_or(src_dir);

    Args {
        src: PathBuf::from_str(src_dir).unwrap(),
        dst: PathBuf::from_str(dst_dir).unwrap(),
    }
}

fn main() {
    let args = get_args();
    doti(args).unwrap();
}
