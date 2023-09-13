import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'serial_none.dart' if (dart.library.io) 'serial_desktop.dart' if (dart.library.html) 'serial_web.dart';

import 'database.dart';
import 'callback_handler.dart';
import 'widgets/base_widget.dart';

var serialthing = getAbstractSerial();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //The theme
        //TODO: Lets get this looking as good as we can at some point
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 12, 192)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'AeroNU Ground Station'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  //Top level widget of the application
  //Contains something (IDK what right now)

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer guiUpdateLoopTimer;
  late Database database;
  late CallbackHandler callbackHandler;

  _MyHomePageState() {
    database = Database();
    callbackHandler = CallbackHandler();

    guiUpdateLoopTimer = Timer.periodic(const Duration(milliseconds: 50), runLoopOnce);
  }

  void runLoopOnce(Timer t) {}

  void onButtonPress() {
    var counterVal = database.getValue("counter", 0);
    database.updateDatabase("counter", counterVal + 1);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[BaseWidget(), BaseWidget(), BaseWidget()],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: onButtonPress, tooltip: 'Increment', child: const Icon(Icons.add)),
    );
  }
}
