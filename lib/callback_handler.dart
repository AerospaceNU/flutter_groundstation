class QueuedCallback<T> {
  var name = "";
  late T data;

  QueuedCallback(this.name, this.data);
}
// everything in CallbackHandler is static, so all
// CallbackHandler objects share fields
// in essence, CallbackHandler is just a global object
// stores multiple callback functions to run at a later time
class CallbackHandler {
  static var callbacks = <String, List>{};
  static var queuedCallbacks = <QueuedCallback>[];

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

  void requestCallback<T>(String name, [T? data]) {
    queuedCallbacks.add(QueuedCallback(name, data));
  }

  void runQueuedCallbacks() {
    for (var callback in queuedCallbacks) {
      runCallback(callback.name, callback.data);
    }

    queuedCallbacks = <QueuedCallback>[];
  }
}
