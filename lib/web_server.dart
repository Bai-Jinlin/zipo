import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zipo/src/rust/api/wrapper.dart';

class WebServerPage extends StatefulWidget {
  const WebServerPage(this._handle, this._aotoGoto, {super.key});

  final bool _aotoGoto;
  final WebHandle _handle;

  @override
  State<WebServerPage> createState() => _WebServerPageState();
}

class _WebServerPageState extends State<WebServerPage> {
  late String _url;
  // status: wait,start,stop
  String _status = "wait";
  @override
  void initState() {
    super.initState();
    _url = widget._handle.url;
    widget._handle.run().listen((status) {
      if (widget._aotoGoto && status == "stop") {
        Navigator.pop(context);
        return;
      }
      setState(() {
        _status = status;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget._handle.cancelServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Server"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  Widget _buildStatus() {
    Color color = Colors.black;
    switch (_status) {
      case "wait":
        color = Colors.grey;
        break;
      case "start":
        color = Colors.green;
        break;
      case "stop":
        color = Colors.yellow;
        break;
      default:
        throw UnsupportedError("unrachable");
    }

    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints.tightFor(width: 100, height: 50),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      // margin: EdgeInsets.all(30),
      // padding: EdgeInsets.all(20),
      child: Text(
        _status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(flex: 5, child: QrImageView(data: _url)),
        _buildStatus(),
        const Spacer()
      ],
    );
  }
}
