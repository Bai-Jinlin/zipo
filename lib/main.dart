import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:zipo/src/rust/api/wrapper.dart';
import 'package:zipo/src/rust/frb_generated.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:zipo/web_server.dart';
import 'package:zipo/settings.dart' as s;

void main() async {
  await RustLib.init();
  runApp(const MyApp());
  // runApp(const TestApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Zipo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "File Processer"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ItemList {
  final List<(String, bool)> filesState;

  set(int index) {
    var s = filesState[index].$1;
    filesState[index] = (s, true);
  }

  ItemList(List<String> filenames)
      : filesState = filenames.map((n) {
          return (n, false);
        }).toList();
  bool get isDone => filesState.every((e) => e.$2);
}

class _MyHomePageState extends State<MyHomePage> {
  Zipo? _zipo;
  ItemList? _list;
  bool _isProcess = false;

  Future<void> _zipPressed() async {
    var msg = ScaffoldMessenger.of(context);
    if (await Permission.manageExternalStorage.request().isDenied) {
      return;
    }
    var path = await getDirectoryPath();
    if (path == null) {
      msg.showSnackBar(const SnackBar(content: Text("please select folder")));
    }
    var dst = p.join(path!, "temp");
    _zipo = Zipo(srcDir: path, dstDir: dst, settings: s.defaultSettings);

    setState(() {
      _list = ItemList(_zipo!.getList());
      if (_list!.filesState.isNotEmpty) {
        _isProcess = true;
      }
    });

    _zipo!.run().listen((e) {
      setState(() {
        _list!.set(e);
        _isProcess = !(_list!.isDone);
      });
      // if (!_isProcess) {}
    });
  }

  void _gotoNext() async {
    assert(_zipo != null);
    var path = _zipo!.dstDir;
    //after getWebServer,_zipo is dropped,must set null;
    var handle = _zipo!.getWebServer();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebServerPage(handle, path);
    }));
    setState(() {
      _zipo = null;
      _isProcess = false;
      _list = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        floatingActionButton: buildButton(),
        body: _buildBody());
  }

  Widget buildButton() {
    void Function()? onPressed;
    Color? color;
    Widget? child;
    if (_zipo != null && _isProcess) {
      onPressed = null;
      child = const Icon(Icons.do_not_disturb);
      color = Colors.grey;
    } else if (_zipo != null && !_isProcess) {
      onPressed = _gotoNext;
      child = const Icon(Icons.navigate_next);
    } else {
      onPressed = _zipPressed;
      child = const Icon(Icons.folder_open);
    }
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: onPressed,
      child: child,
    );
  }

  Widget _buildBody() {
    if (_list == null) {
      return const Center(
        child: Text("press button"),
      );
    }
    return _buildList();
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _list!.filesState.length,
        itemBuilder: (context, index) {
          var (filename, isDone) = _list!.filesState[index];
          return ListTile(
              title:
                  Text(filename, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: isDone
                  ? const Icon(Icons.done)
                  : const CircularProgressIndicator());
        });
  }
}
