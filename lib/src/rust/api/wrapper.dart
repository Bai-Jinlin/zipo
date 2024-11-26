// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `bind_until_success`, `decode`, `list`, `new`, `run_server`, `stop`
// These types are ignored because they are not used by any `pub` functions: `DecodeRequest`, `MyState`, `StreamMetrics`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `finish`, `tick`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WebHandle>>
abstract class WebHandle implements RustOpaqueInterface {
  String get url;

  set url(String url);

  void cancelServer();

  Stream<String> run();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Zipo>>
abstract class Zipo implements RustOpaqueInterface {
  String get dstDir;

  set dstDir(String dstDir);

  Future<void> clear();

  List<String> getList();

  WebHandle getWebServer();

  factory Zipo(
          {required String srcDir,
          required String dstDir,
          required ZipoSettings settings}) =>
      RustLib.instance.api.crateApiWrapperZipoNew(
          srcDir: srcDir, dstDir: dstDir, settings: settings);

  Stream<int> run();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ZipoSettings>>
abstract class ZipoSettings implements RustOpaqueInterface {
  factory ZipoSettings() =>
      RustLib.instance.api.crateApiWrapperZipoSettingsNew();

  void pushRule({required String filename, required List<String> excludes});

  void setSeparate();
}
