import 'dart:async';

class DataStream {
  static StreamController streamcontroller = StreamController.broadcast(
    // onPause: () => print('Paused'),
    // onResume: () => print('Resumed'),
    onCancel: () => print('Cancelled'),
    onListen: () => print('Listens'),
  );
}
