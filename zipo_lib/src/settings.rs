use std::path::{self, Path, PathBuf};

use regex::Regex;
/// is_separte:true               
/// filename:\d-(.*)              
/// excludes:[f2]                 
/// /path/123-file ────► file.zip
///       ├───f1        file      
///       ├───f2        ├───f1    
///       └───f3        └───f3    
///                               
/// is_separate:false             
/// /path/file ────► file.zip    
///       ├───f1      ├───f1      
///       ├───f2      ├───f2      
///       └───f3      └───f3      
#[derive(Clone)]
pub struct Settings {
    pub is_separate: bool,
    pub rules:RuleSet,
}
impl Settings{
    pub fn new()->Self{
        Self{
            is_separate:false,
            rules:RuleSet::new()
        }
    }
    pub fn set_separate(&mut self){
        self.is_separate=true;
    }
    pub fn push_rule(&mut self,r:Rule){
        self.rules.push_rule(r);
    }
}

#[derive(Clone)]
pub struct Rule {
    filename: Regex,
    excludes: Vec<Regex>,
}

impl Rule {
    pub fn new<'a>(filename: &str, excludes: &[String]) -> Self {
        let filename = Regex::new(filename).unwrap();
        let excludes = excludes.into_iter().map(|r| Regex::new(r).unwrap()).collect();
        Self { filename, excludes }
    }

    pub fn match_rule(&self, src_dir: &Path, dst_dir: &Path) -> Option<PathBuf> {
        if !src_dir.is_absolute() {
            return None;
        }

        //unwrap safe src_dir can't is root
        let filename = src_dir.file_name().unwrap().to_string_lossy();
        self.get_cap(&filename)
            .map(|name| dst_dir.join(format!("{name}.zip")))
    }

    pub fn match_excludes(&self, file_path: &Path) -> bool {
        //unwrap safe src_dir can't is root
        let filename = file_path.file_name().unwrap().to_string_lossy();
        for r in &self.excludes {
            if r.is_match(&filename) {
                return true;
            }
        }
        false
    }

    pub fn transform_path(&self, file_path: &Path, prefix: &Path, is_separate: bool) -> PathBuf {
        if !is_separate {
            return file_path.strip_prefix(prefix).unwrap().to_path_buf();
        }
        let prefix = prefix.parent().unwrap();

        //unwrap safe. filepath is entry of prefix dir
        let name = file_path.strip_prefix(prefix).unwrap();

        let mut ret_path = PathBuf::new();

        let mut c = name.components();
        if let path::Component::Normal(p) = c.next().unwrap() {
            // safe
            ret_path.push(self.get_cap(&p.to_string_lossy()).unwrap());
        }

        for r in c {
            if let path::Component::Normal(p) = r {
                ret_path.push(p)
            }
        }
        ret_path
    }

    fn get_cap<'s>(&self, haystack: &'s str) -> Option<&'s str> {
        if let Some(caps) = self.filename.captures(haystack) {
            // regex all have capsgroup
            let m = caps.get(1).unwrap();
            return Some(m.as_str());
        }
        None
    }
}

#[derive(Clone)]
pub struct RuleSet(Vec<Rule>);

impl RuleSet {
    pub fn new() -> Self {
        let default_rule = Rule::new("(.*)", &[]);
        let mut v = Vec::new();
        v.push(default_rule);
        Self(v)
    }

    pub fn get_match_rule(&self, src_dir: &Path, dst_dir: &Path) -> (PathBuf, &Rule) {
        for r in self.0.iter().rev() {
            if let Some(p) = r.match_rule(src_dir, dst_dir) {
                return (p, r);
            }
        }
        //because have (.*)
        unreachable!()
    }
    pub fn push_rule(&mut self, r: Rule) {
        self.0.push(r);
    }
}

mod test {

    #[test]
    fn test_rule_set() {
        use crate::{Rule, RuleSet};
        use std::path::Path;
        let mut s = RuleSet::new();
        let eh_rule = Rule::new(r#"\d-(.*)"#, &[r#"^\.asd$"#.to_string(), r#"^\.zxc$"#.to_string()]);
        s.push_rule(eh_rule);

        {
            let l = r#"C:\path\123-test"#.as_ref();
            let r = r#"C:\dst"#.as_ref();
            let ret = s.get_match_rule(l, r);
            assert_eq!(ret.0, Path::new(r#"C:\dst\test.zip"#));
            assert!(ret.1.match_excludes(".asd".as_ref()));
            assert!(ret.1.match_excludes("/path/.zxc".as_ref()));
        }

        {
            let l = r#"C:\path\test"#.as_ref();
            let r = r#"C:\dst"#.as_ref();
            let ret = s.get_match_rule(l, r);
            assert_eq!(ret.0, Path::new(r#"C:\dst\test.zip"#));
            assert!(!ret.1.match_excludes(".ehviewer".as_ref()));
        }
    }
    #[test]
    fn test_transform_path() {
        use crate::Rule;
        use std::path::Path;
        let rule = Rule::new(
            r#"\d-(.*)"#,
            &[r#"^\.ehviewer$"#.to_string(), r#"^\.thumb$"#.to_string()],
        );
        {
            let ret = rule.transform_path(
                r#"C:\path\123-qwe\1.jpg"#.as_ref(),
                r#"C:\path\123-qwe\"#.as_ref(),
                true,
            );
            assert_eq!(ret, Path::new(r#"qwe\1.jpg"#));
        }
        {
            let ret = rule.transform_path(
                r#"C:\path\123-qwe\1.jpg"#.as_ref(),
                r#"C:\path\123-qwe\"#.as_ref(),
                false,
            );
            assert_eq!(ret, Path::new(r#"1.jpg"#));
        }
    }
}
