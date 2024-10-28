import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const TestHomePage(title: "Test"),
    );
  }
}

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key, required this.title});

  final String title;

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  void onPressed() async {}
  // List<int> _list = [];
  late Stream<double> s;
  static const double step = 1/6;
  
  @override
  void initState() {
    super.initState();
    s=Stream.periodic(Duration(milliseconds: 500),(s){
      
    })
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      ElevatedButton(
        onPressed: onPressed,
        child: Text("clickme"),
      ),
      // CircularProgressIndicator(
      //   backgroundColor: Colors.grey[200],
      //   valueColor:AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
      //   value: ,
      // )
    ];

    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Column(mainAxisSize: MainAxisSize.max, children: children)));
  }

  Widget buildStream(Stream<double> s) {
    return StreamBuilder<double>(
        stream: s,
        builder: (context, snap) {
          final error = snap.error;
          if (error != null)
            return Tooltip(
                message: error.toString(),
                child: Text(
                  'Error',
                ));

          final data = snap.data;
          if (data != null) {
            return CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
              value: data,
            );
          }

          return const Text("complate");
        });
  }
}
