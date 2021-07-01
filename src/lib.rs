use std::path::Path;
use std::fs::File;
use zip::write::FileOptions;
use walkdir::WalkDir;
use std::io::{Read, Write};

pub fn zip_dir<P1, P2>(src_dir: P1, dst_name: P2) -> zip::result::ZipResult<()>
    where
        P1: AsRef<Path>,
        P2: AsRef<Path>,
{
    let mut buffer = Vec::new();
    // let fullname = dst_dir.as_ref().join(filename);
    // let fullname = File::create(fullname)?;
    let fullname = File::create(dst_name)?;

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
        } else if !name.is_empty() {
            zip.add_directory(name, options)?;
        }
    }
    zip.finish()?;
    Ok(())
}
