import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/graph_widget.dart';
import 'package:show_fps/show_fps.dart';

import 'serial/serial_none.dart'
    if (dart.library.io) 'serial/serial_desktop.dart'
    if (dart.library.html) 'serial/serial_web.dart';

import 'database.dart';
import 'callback_handler.dart';
import 'widgets/test_widget.dart';

var serialThing = getAbstractSerial();

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 12, 192)),
        useMaterial3: true,
      ),
      home: const ShowFPS(child: MyHomePage(title: 'AeroNU Ground Station')),
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

    guiUpdateLoopTimer =
        Timer.periodic(const Duration(milliseconds: 20), runLoopOnce);
  }

  int i = 0;
  void runLoopOnce(Timer t) {
    database.updateDatabase("test", i++);
  }

  void onButtonPress() {
    var counterVal = database.getValue("counter", 0);
    database.updateDatabase("counter", counterVal + 1);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TestWidget(),
            TestWidget(),
            GraphWidget(),
            GraphWidget(),
            // GraphWidget(),
            // GraphWidget(),
            // GraphWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: onButtonPress,
          tooltip: 'Increment',
          child: const Icon(Icons.add)),
    );
  }
}
