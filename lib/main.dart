import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:zipo/src/rust/api/wrapper.dart';
import 'package:zipo/src/rust/frb_generated.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zipo/test.dart';

void main() async {
  await RustLib.init();
  // runApp(const MyApp());
  runApp(const TestApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Zipo"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _dstDir;
  WebHandle? _handle;

  Future<void> _zipPressed() async {
    if (await Permission.manageExternalStorage.request().isDenied) {
      return;
    }
    var path = await getDirectoryPath();
    //todo check path
    var dst = p.join(path!, "temp");
    await zipDir(srcDir: path, dstDir: dst);
    _dstDir = dst;
  }

  Future<void> _closeAndClear() async {
    _handle!.cancelServer();
    _handle = null;
    await Directory(_dstDir!).delete(recursive: true);
    _dstDir = null;
  }

  void onPressed() async {
    if (_handle == null) {
      await _zipPressed();
      _handle = runWebServer(port: 8080, path: _dstDir!);
    } else {
      await _closeAndClear();
    }
    setState(() {});
  }

  @override
  void dispose() async {
    super.dispose();
    if (_handle != null) {
      await _closeAndClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      ElevatedButton(
        onPressed: onPressed,
        child: Text(_handle == null ? "run" : "stop"),
      )
    ];

    if (_handle != null) {
      children.add(QrImageView(data: _handle!.url));
    }
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Column(mainAxisSize: MainAxisSize.max, children: children)));
  }
}
