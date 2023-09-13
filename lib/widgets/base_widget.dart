import 'package:flutter/material.dart';

import '../callback_handler.dart';
import '../database.dart';
import '../constants.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  late CallbackHandler callbackHandler;
  static late Database database;

  _BaseWidgetState() {
    callbackHandler = CallbackHandler();
    database = Database();

    callbackHandler.registerCallback(Constants.databaseUpdateKey, onDatabaseUpdate);
  }

  void onDatabaseUpdate<T>(T data) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Ayy");

    var textWidget = const Text('Test text');
    var wid_2 = const Text('You have pushed the button this many times:');
    var wid_3 = Text('${database.getValue("counter", 0)}', style: Theme.of(context).textTheme.headlineMedium);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[textWidget, wid_2, wid_3],
    );
  }
}
