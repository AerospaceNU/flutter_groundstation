import 'package:flutter/material.dart';

import '../callback_handler.dart';
import '../database.dart';
import '../data_stream.dart';
import '../constants.dart';

abstract class BaseWidgetState<WidgetClass extends StatefulWidget>
    extends State<WidgetClass> {
  late CallbackHandler callbackHandler;
  static late Database database;
  static late DataStream dataStream;
  final _subscribedKeys =
      <String>{}; //I don't understand why you can keep adding to a list declared final, but I'm not going to question it

  BaseWidgetState() {
    callbackHandler = CallbackHandler();
    database = Database();
    dataStream =
        DataStream(); // this isn't the same one is it - shoudl use a getter as opposed to a constructor

    callbackHandler.registerCallback(
        Constants.databaseUpdateKey, onDatabaseUpdate);
  }

  void subscribeToDatabaseKey(String key) {
    _subscribedKeys.add(key);
  }

  Stream<dynamic> getStream() {
    return DataStream.streamcontroller.stream;
  }

  T getDatabaseValue<T>(String key, T defaultValue) {
    subscribeToDatabaseKey(key);
    return database.getValue(key, defaultValue);
  }

  T? getDatabaseValueOrNull<T>(String key) {
    return database.getValueOrNull(key);
  }

  void onDatabaseUpdate<T>(T data) {
    var updatedKeys = database.getUpdatedKeys();
    bool needsToUpdate = false;

    for (var key in updatedKeys) {
      if (_subscribedKeys.contains(key)) {
        needsToUpdate = true;
        break;
      }
    }

    if (mounted && needsToUpdate) {
      setState(() {});
    }
  }
}
