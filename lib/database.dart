import 'callback_handler.dart';
import 'constants.dart';

class Database {
  static var database = {};
  static late CallbackHandler callbackHandler;
  static var updatedKeys = <String>{};

  Database() {
    callbackHandler = CallbackHandler();
  }

  void bulkUpdateDatabase(Map<String, dynamic> data) {
    for (var key in data.keys) {
      database[key] = data[key];
      updatedKeys.add(key);
    }

    updateWidgets();
  }

  void updateDatabase<T>(String key, T value) {
//    print("database update: {$key}, {$value}");
    database[key] = value;
    updatedKeys.add(key);
    updateWidgets();
  }

  void updateWidgets() {
    callbackHandler.runCallback(Constants.databaseUpdateKey);
    updatedKeys.clear();
  }

  Set<String> getUpdatedKeys() {
    return updatedKeys;
  }

  T getValue<T>(String key, T defaultValue) {
    if (database.containsKey(key)) {
      return database[key];
    } else {
      return defaultValue;
    }
  }
}
