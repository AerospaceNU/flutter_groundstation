import 'callback_handler.dart';
import 'constants.dart';

class Database {
  static var database = {};
  static late CallbackHandler callbackHandler;

  Database() {
    callbackHandler = CallbackHandler();
  }

  void updateDatabase<T>(String key, T value) {
    print("database update: {$key}, {$value}");
    database["counter"] = value;
    callbackHandler.runCallback(Constants.databaseUpdateKey);
  }

  T getValue<T>(String key, T defaultValue) {
    if (database.containsKey(key)) {
      return database[key];
    } else {
      return defaultValue;
    }
  }
}
