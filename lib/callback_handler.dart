class CallbackHandler {
  static var callbacks = <String, List>{};

  void registerCallback(String callbackName, Function callback) {
    if (!callbacks.containsKey(callbackName)) {
      callbacks[callbackName] = [];
    }

    //Dart syntax goes ?hard
    callbacks[callbackName]?.add(callback);
  }

  void runCallback<T>(String callbackName, [T? data]) {
    if (callbacks.containsKey(callbackName)) {
      var callbackList = callbacks[callbackName];
      for (var callback in callbackList!) {
        //Do we need to check type or something?
        callback(data);
      }
    }
  }
}
