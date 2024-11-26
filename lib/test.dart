import 'dart:math';

import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test page",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class JustData {
  JustData(this.str);
  String str;
}

class _MyHomePageState extends State<MyHomePage> {
  late List<JustData> data;

  String generateRandomString(int length) {
    final random = Random();

    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  @override
  void initState() {
    super.initState();
    data = List.generate(5, (i) {
      return JustData(generateRandomString(60));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var c = Container(
      margin: EdgeInsets.symmetric(vertical: 70, horizontal: 50),
      // constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),//卡片大小
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.red, Colors.orange],
          center: Alignment.topLeft,
          radius: .98,
        ),
      ),
      alignment: Alignment.center, //卡片内文字居中
      child: _foo(),
    );

    return Center(child: c);
  }

  Widget _foo() {
    return Text("asd");
  }
}
