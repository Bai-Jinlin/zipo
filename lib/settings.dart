import 'package:zipo/src/rust/api/wrapper.dart';

ZipoSettings? _defaultSettings;

ZipoSettings get defaultSettings {
  if (_defaultSettings != null) return _defaultSettings!;
  var rule = Rule(
      filename: "\\d-(.*)", excludes: ["\\.ehviewer", "thumb.*"]);

  var settings = ZipoSettings(isSeparate: true);
  settings.pushRule(rule: rule);
  _defaultSettings = settings;
  return _defaultSettings!;
}
