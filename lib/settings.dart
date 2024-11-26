import 'package:zipo/src/rust/api/wrapper.dart';


ZipoSettings? _defaultSettings;

ZipoSettings get defaultSettings {
  if (_defaultSettings != null) return _defaultSettings!;
  var settings = ZipoSettings();
  settings.setSeparate();
  settings.pushRule(filename: "\\d-(.*)", excludes: ["\\.ehviewer", "thumb.*"]);
  _defaultSettings = settings;
  return _defaultSettings!;
}

// class Settings {
//   Future<SharedPreferences> _fut = SharedPreferences.getInstance();

//   static Settings? _instance;
//   static Future<Settings> getInstance()async{
//     if (_instance==null){
      
//     }
//     return _instance!;
//   }

//   bool _separate;
//   String _filename;
//   List<String> _excludes;
//   Settings._(this._separate, this._filename, this._excludes);

//   bool get separate => _separate;
//   Future<void> setSeparate(bool value) async {}

//   ZipoSettings into() {
//     var settings = ZipoSettings();
//     if (_separate) {
//       settings.setSeparate();
//     }
//     settings.pushRule(filename: _filename, excludes: _excludes);
//     return settings;
//   }
// }
// Future<void> _saveDefaultSettings(SharedPreferences pref) async {
//   await pref.setString("filename", "\\d-(.*)");
//   await pref.setStringList("excludes", ["\\.ehviewer", "thumb.*"]);
//   await pref.setBool("separate", true);
// }

// Future<Settings> _load(SharedPreferences pref) async {
//   var filename = pref.getString("filename");
//   if (filename == null) {
//     await _saveDefaultSettings(pref);
//   }
//   filename = pref.getString("filename")!;
//   var excludes = pref.getStringList("excludes")!;
//   var separate = pref.getBool("separate")!;

//   return Settings._(separate, filename, excludes);
// }