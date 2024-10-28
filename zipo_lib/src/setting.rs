// use config::{Config, ConfigError, File};
use serde::{Deserialize, Serialize};

const DAFAULT_SETTINGS :&'static str = r#"
is_separate = true

[[rules]]
filename = '\d-(.*)'
excludes = ['^\.ehviewer$', '^\.thumb$']
"#;
#[derive(Debug, Serialize, Deserialize)]
pub struct Rule {
    pub filename: String,
    pub excludes: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Settings {
    pub is_separate: bool,
    pub rules: Option<Vec<Rule>>,
}

impl Default for Settings {
    fn default() -> Self {
        Self { is_separate: true, rules: None }
    }
}

impl Settings {
    pub fn new() -> Result<Self, toml::de::Error> {
        // let s = Config::builder()
        //     .add_source(File::with_name("config"))
        //     .build()?;
        // s.try_deserialize()
        toml::from_str(DAFAULT_SETTINGS)
    }
}

mod test {
    #[test]
    fn test() {
        use super::Settings;
        let s= Settings::new().unwrap();
        assert_eq!(s.rules.unwrap()[0].filename,r"\d-(.*)");
    }
}
