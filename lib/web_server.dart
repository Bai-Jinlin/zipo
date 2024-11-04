import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zipo/src/rust/api/wrapper.dart';

class WebServerPage extends StatefulWidget {
  const WebServerPage(this._handle,this._path, {super.key});

  final String _path;
  final WebHandle _handle;

  @override
  State<WebServerPage> createState() => _WebServerPageState();
}

class _WebServerPageState extends State<WebServerPage> {
  late String url;
  @override
  void initState() {
    url = widget._handle.url;
    super.initState();
    widget._handle.run().listen((e) {
      // setState(() {
      //   _status = e;
      // });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    //after use cancelServer ,_handle is dropped.
    widget._handle.cancelServer();
    await Directory(widget._path).delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Server"),
      ),
      body: Center(child: QrImageView(data: url)),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
