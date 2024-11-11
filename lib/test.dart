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
    data = List.generate(5, (i)  {
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
    return ListView.builder(
        prototypeItem: const ListTile(title: Text("1"),),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(data[index].str,maxLines: 1,),trailing: CircularProgressIndicator(),);
        }
        );
  }
}
