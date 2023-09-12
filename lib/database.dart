import 'package:flutter/material.dart';

class Database extends ChangeNotifier {
  var database = {};

  Database() {
    print("create database");
  }

  void updateDatabase<T>(String key, T value) {
    print("database update: {$key}, {$value}");
    database["counter"] = value;
    notifyListeners();
  }

  T getValue<T>(String key, T defaultValue) {
    if (database.containsKey(key)) {
      return database[key];
    } else {
      return defaultValue;
    }
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    print("HI");
    print(listener);
    super.addListener(listener);
  }
}
