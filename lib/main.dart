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
  final List<(String, bool)> _filesState;

  int _count = 0;

  ItemList(List<String> filenames)
      : _filesState = filenames.map((n) => (n, false)).toList();

  setItem(int index) {
    var s = _filesState[index].$1;
    _filesState[index] = (s, true);
    _count++;
  }

  bool get isDone => _count == _filesState.length;
  double get processedValue =>
      _count.toDouble() / _filesState.length.toDouble();
  String get processedText => "$_count/${_filesState.length}";
}

class _MyHomePageState extends State<MyHomePage> {
  Zipo? _zipo;
  ItemList? _list;
  bool _isProcess = false;

  bool _autoGoto = false;

  Future<void> _zipPressed() async {
    var msg = ScaffoldMessenger.of(context);
    if (await Permission.manageExternalStorage.request().isDenied) {
      msg.showSnackBar(const SnackBar(content: Text("permisson is denied!")));
      return;
    }
    var path = await getDirectoryPath();
    if (path == null) {
      msg.showSnackBar(const SnackBar(content: Text("please select folder!")));
      return;
    }
    var dst = p.join(path, "temp");
    _zipo = Zipo(srcDir: path, dstDir: dst, settings: s.defaultSettings);

    setState(() {
      _list = ItemList(_zipo!.getList());
      if (_list!._filesState.isNotEmpty) {
        _isProcess = true;
      }
    });

    _zipo!.run().listen((index) {
      setState(() {
        _list!.setItem(index);
        _isProcess = !(_list!.isDone);
      });
      if (_autoGoto && !_isProcess) {
        _gotoNext();
      }
    });
  }

  void _gotoNext() async {
    var handle = await _zipo!.getWebServer();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebServerPage(handle, _autoGoto);
    }));
    await _zipo!.clear();
    setState(() {
      _zipo = null;
      _isProcess = false;
      _list = null;
    });
  }

  @override
  void dispose() {
    _zipo?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        floatingActionButton: _buildButton(),
        body: _buildBody());
  }

  Widget _buildButton() {
    void Function()? onPressed;
    Color? color;
    Widget? child;
    if (_zipo != null && _isProcess) {
      //in process
      onPressed = null;
      child = const Icon(Icons.do_not_disturb);
      color = Colors.grey;
    } else if (_zipo != null && !_isProcess) {
      //process done
      onPressed = _gotoNext;
      child = const Icon(Icons.navigate_next);
    } else {
      //wait process
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
      return _buildSettings();
    }
    return _buildProcess();
  }

  Widget _buildSettings() {
    return const Center(
      child: Text("press button"),
    );
  }

  Widget _buildProcess() {
    var row = Row(
      children: [
        Expanded(
            flex: 10,
            child: LinearProgressIndicator(value: _list!.processedValue)),
        const Spacer(),
        Expanded(
            child: Text(
          _list!.processedText,
          textAlign: TextAlign.right,
        ))
      ],
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: row,
        ),
        Expanded(child: _buildList())
      ],
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: _list!._filesState.length,
        itemBuilder: (context, index) {
          var (filename, isDone) = _list!._filesState[index];
          return ListTile(
              title:
                  Text(filename, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: isDone
                  ? const Icon(Icons.done)
                  : const CircularProgressIndicator());
        });
  }
}
