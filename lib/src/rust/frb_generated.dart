// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/wrapper.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart'
    if (dart.library.js_interop) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Initialize flutter_rust_bridge in mock mode.
  /// No libraries for FFI are loaded.
  static void initMock({
    required RustLibApi api,
  }) {
    instance.initMockImpl(
      api: api,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.crateApiWrapperInitApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.5.1';

  @override
  int get rustContentHash => -6718946;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_flutter_application_test',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  String crateApiWrapperWebHandleAutoAccessorGetUrl({required WebHandle that});

  void crateApiWrapperWebHandleAutoAccessorSetUrl(
      {required WebHandle that, required String url});

  void crateApiWrapperWebHandleCancelServer({required WebHandle that});

  Stream<String> crateApiWrapperWebHandleRun({required WebHandle that});

  String crateApiWrapperZipoAutoAccessorGetDstDir({required Zipo that});

  void crateApiWrapperZipoAutoAccessorSetDstDir(
      {required Zipo that, required String dstDir});

  List<String> crateApiWrapperZipoGetList({required Zipo that});

  WebHandle crateApiWrapperZipoGetWebServer({required Zipo that});

  Zipo crateApiWrapperZipoNew({required String srcDir, required String dstDir});

  Stream<int> crateApiWrapperZipoRun({required Zipo that});

  Future<void> crateApiWrapperInitApp();

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_WebHandle;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_WebHandle;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_WebHandlePtr;

  RustArcIncrementStrongCountFnType get rust_arc_increment_strong_count_Zipo;

  RustArcDecrementStrongCountFnType get rust_arc_decrement_strong_count_Zipo;

  CrossPlatformFinalizerArg get rust_arc_decrement_strong_count_ZipoPtr;
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  String crateApiWrapperWebHandleAutoAccessorGetUrl({required WebHandle that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 1)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperWebHandleAutoAccessorGetUrlConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperWebHandleAutoAccessorGetUrlConstMeta =>
      const TaskConstMeta(
        debugName: "WebHandle_auto_accessor_get_url",
        argNames: ["that"],
      );

  @override
  void crateApiWrapperWebHandleAutoAccessorSetUrl(
      {required WebHandle that, required String url}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
            that, serializer);
        sse_encode_String(url, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 2)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperWebHandleAutoAccessorSetUrlConstMeta,
      argValues: [that, url],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperWebHandleAutoAccessorSetUrlConstMeta =>
      const TaskConstMeta(
        debugName: "WebHandle_auto_accessor_set_url",
        argNames: ["that", "url"],
      );

  @override
  void crateApiWrapperWebHandleCancelServer({required WebHandle that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 3)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperWebHandleCancelServerConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperWebHandleCancelServerConstMeta =>
      const TaskConstMeta(
        debugName: "WebHandle_cancel_server",
        argNames: ["that"],
      );

  @override
  Stream<String> crateApiWrapperWebHandleRun({required WebHandle that}) {
    final stream = RustStreamSink<String>();
    unawaited(handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
            that, serializer);
        sse_encode_StreamSink_String_Sse(stream, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperWebHandleRunConstMeta,
      argValues: [that, stream],
      apiImpl: this,
    )));
    return stream.stream;
  }

  TaskConstMeta get kCrateApiWrapperWebHandleRunConstMeta =>
      const TaskConstMeta(
        debugName: "WebHandle_run",
        argNames: ["that", "stream"],
      );

  @override
  String crateApiWrapperZipoAutoAccessorGetDstDir({required Zipo that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 5)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoAutoAccessorGetDstDirConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperZipoAutoAccessorGetDstDirConstMeta =>
      const TaskConstMeta(
        debugName: "Zipo_auto_accessor_get_dst_dir",
        argNames: ["that"],
      );

  @override
  void crateApiWrapperZipoAutoAccessorSetDstDir(
      {required Zipo that, required String dstDir}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
            that, serializer);
        sse_encode_String(dstDir, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 6)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoAutoAccessorSetDstDirConstMeta,
      argValues: [that, dstDir],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperZipoAutoAccessorSetDstDirConstMeta =>
      const TaskConstMeta(
        debugName: "Zipo_auto_accessor_set_dst_dir",
        argNames: ["that", "dstDir"],
      );

  @override
  List<String> crateApiWrapperZipoGetList({required Zipo that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 7)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_String,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoGetListConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperZipoGetListConstMeta => const TaskConstMeta(
        debugName: "Zipo_get_list",
        argNames: ["that"],
      );

  @override
  WebHandle crateApiWrapperZipoGetWebServer({required Zipo that}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
            that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 8)!;
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoGetWebServerConstMeta,
      argValues: [that],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperZipoGetWebServerConstMeta =>
      const TaskConstMeta(
        debugName: "Zipo_get_web_server",
        argNames: ["that"],
      );

  @override
  Zipo crateApiWrapperZipoNew(
      {required String srcDir, required String dstDir}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(srcDir, serializer);
        sse_encode_String(dstDir, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 9)!;
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoNewConstMeta,
      argValues: [srcDir, dstDir],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperZipoNewConstMeta => const TaskConstMeta(
        debugName: "Zipo_new",
        argNames: ["srcDir", "dstDir"],
      );

  @override
  Stream<int> crateApiWrapperZipoRun({required Zipo that}) {
    final stream = RustStreamSink<int>();
    unawaited(handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
            that, serializer);
        sse_encode_StreamSink_i_32_Sse(stream, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 10, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperZipoRunConstMeta,
      argValues: [that, stream],
      apiImpl: this,
    )));
    return stream.stream;
  }

  TaskConstMeta get kCrateApiWrapperZipoRunConstMeta => const TaskConstMeta(
        debugName: "Zipo_run",
        argNames: ["that", "stream"],
      );

  @override
  Future<void> crateApiWrapperInitApp() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 11, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWrapperInitAppConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWrapperInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_WebHandle => wire
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_WebHandle => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle;

  RustArcIncrementStrongCountFnType get rust_arc_increment_strong_count_Zipo =>
      wire.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo;

  RustArcDecrementStrongCountFnType get rust_arc_decrement_strong_count_Zipo =>
      wire.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  WebHandle
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return WebHandleImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Zipo
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ZipoImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  WebHandle
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return WebHandleImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Zipo
      dco_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ZipoImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  WebHandle
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return WebHandleImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Zipo
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ZipoImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  WebHandle
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return WebHandleImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  Zipo
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return ZipoImpl.frbInternalDcoDecode(raw as List<dynamic>);
  }

  @protected
  RustStreamSink<String> dco_decode_StreamSink_String_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  RustStreamSink<int> dco_decode_StreamSink_i_32_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  BigInt dco_decode_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  WebHandle
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return WebHandleImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Zipo
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ZipoImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  WebHandle
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return WebHandleImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Zipo
      sse_decode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ZipoImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  WebHandle
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return WebHandleImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Zipo
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ZipoImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  WebHandle
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return WebHandleImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  Zipo
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return ZipoImpl.frbInternalSseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  RustStreamSink<String> sse_decode_StreamSink_String_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  RustStreamSink<int> sse_decode_StreamSink_i_32_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  BigInt sse_decode_usize(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.message, serializer);
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          WebHandle self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as WebHandleImpl).frbInternalSseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          Zipo self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ZipoImpl).frbInternalSseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          WebHandle self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as WebHandleImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_Auto_RefMut_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          Zipo self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ZipoImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          WebHandle self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as WebHandleImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          Zipo self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ZipoImpl).frbInternalSseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWebHandle(
          WebHandle self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as WebHandleImpl).frbInternalSseEncode(move: null), serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerZipo(
          Zipo self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(
        (self as ZipoImpl).frbInternalSseEncode(move: null), serializer);
  }

  @protected
  void sse_encode_StreamSink_String_Sse(
      RustStreamSink<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(
        self.setupAndSerialize(
            codec: SseCodec(
          decodeSuccessData: sse_decode_String,
          decodeErrorData: sse_decode_AnyhowException,
        )),
        serializer);
  }

  @protected
  void sse_encode_StreamSink_i_32_Sse(
      RustStreamSink<int> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(
        self.setupAndSerialize(
            codec: SseCodec(
          decodeSuccessData: sse_decode_i_32,
          decodeErrorData: sse_decode_AnyhowException,
        )),
        serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_usize(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }
}

@sealed
class WebHandleImpl extends RustOpaque implements WebHandle {
  // Not to be used by end users
  WebHandleImpl.frbInternalDcoDecode(List<dynamic> wire)
      : super.frbInternalDcoDecode(wire, _kStaticData);

  // Not to be used by end users
  WebHandleImpl.frbInternalSseDecode(BigInt ptr, int externalSizeOnNative)
      : super.frbInternalSseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_WebHandle,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_WebHandle,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_WebHandlePtr,
  );

  String get url =>
      RustLib.instance.api.crateApiWrapperWebHandleAutoAccessorGetUrl(
        that: this,
      );

  set url(String url) => RustLib.instance.api
      .crateApiWrapperWebHandleAutoAccessorSetUrl(that: this, url: url);

  void cancelServer() =>
      RustLib.instance.api.crateApiWrapperWebHandleCancelServer(
        that: this,
      );

  Stream<String> run() => RustLib.instance.api.crateApiWrapperWebHandleRun(
        that: this,
      );
}

@sealed
class ZipoImpl extends RustOpaque implements Zipo {
  // Not to be used by end users
  ZipoImpl.frbInternalDcoDecode(List<dynamic> wire)
      : super.frbInternalDcoDecode(wire, _kStaticData);

  // Not to be used by end users
  ZipoImpl.frbInternalSseDecode(BigInt ptr, int externalSizeOnNative)
      : super.frbInternalSseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_Zipo,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_Zipo,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_ZipoPtr,
  );

  String get dstDir =>
      RustLib.instance.api.crateApiWrapperZipoAutoAccessorGetDstDir(
        that: this,
      );

  set dstDir(String dstDir) => RustLib.instance.api
      .crateApiWrapperZipoAutoAccessorSetDstDir(that: this, dstDir: dstDir);

  List<String> getList() => RustLib.instance.api.crateApiWrapperZipoGetList(
        that: this,
      );

  WebHandle getWebServer() =>
      RustLib.instance.api.crateApiWrapperZipoGetWebServer(
        that: this,
      );

  Stream<int> run() => RustLib.instance.api.crateApiWrapperZipoRun(
        that: this,
      );
}
