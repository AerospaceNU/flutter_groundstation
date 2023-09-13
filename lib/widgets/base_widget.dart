import 'package:flutter/material.dart';

import '../callback_handler.dart';
import '../database.dart';
import '../constants.dart';

abstract class BaseWidgetState<WidgetClass extends StatefulWidget> extends State<WidgetClass> {
  late CallbackHandler callbackHandler;
  static late Database database;

  BaseWidgetState() {
    callbackHandler = CallbackHandler();
    database = Database();

    callbackHandler.registerCallback(Constants.databaseUpdateKey, onDatabaseUpdate);
  }

  T getDatabaseValue<T>(String key, T defaultValue) {
    return database.getValue(key, defaultValue);
  }

  void onDatabaseUpdate<T>(T data) {
    setState(() {});
  }
}
