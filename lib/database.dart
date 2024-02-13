import 'callback_handler.dart';
import 'constants.dart';

class Database {
  static var database = {};
  static late CallbackHandler callbackHandler;

  // stores keys that have been updated, meaning we have to run callbacks
  static final _updatedKeys = <String>{};

  Database() {
    callbackHandler = CallbackHandler();
  }

  void bulkUpdateDatabase(Map<String, dynamic> data) {
    for (var key in data.keys) {
      database[key] = data[key];
      _updatedKeys.add(key);
    }

    updateWidgets();
  }

  void updateDatabase<T>(String key, T value) {
//    print("database update: {$key}, {$value}");
    database[key] = value;
    _updatedKeys.add(key);
    updateWidgets();
  }

  void updateWidgets() {
    callbackHandler.runCallback(Constants.databaseUpdateKey);
    _updatedKeys.clear();
  }

  Set<String> getUpdatedKeys() {
    return _updatedKeys;
  }

  T getValue<T>(String key, T defaultValue) {
    if (database.containsKey(key)) {
      var value = database[key];

      //We do a little type checking
      if (value is T) {
        return value;
      } else if (T == String) {
        return value.toString() as T;
      } else if (T == double && value is num) {
        return value.toDouble() as T;
      } else if (T == int && value is num) {
        return value.toInt() as T;
      } else {
        try {
          return value as T;
        } catch (e) {
          print("Can't cast key $key ${e}");
          return defaultValue;
        }
      }
    } else {
      return defaultValue;
    }
  }

  T? getValueOrNull<T>(String key) {
    return database[key];
  }
}
