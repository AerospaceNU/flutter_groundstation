import 'package:flutter/foundation.dart';

abstract class Placeholders {
  static void pushLog(double time) {}
  static void pushUpdate() {}

  static void logValue<T>(String key, T value) {}

  static void updateSeries<T>(String key, T value, double time) {}

  static double getTime() {
    return 0;
  }
}

abstract class BaseInput {
  double currentTime = 0;

  BaseInput();

  @nonVirtual
  void loop() {
    currentTime = Placeholders.getTime();

    runLoopOnce();

    Placeholders.pushUpdate();
    Placeholders.pushLog(currentTime);
  }

  void updateValue<T>(String key, T value) {
    Placeholders.updateSeries(key, value, currentTime);
    Placeholders.logValue<T>(key, value);
  }

  void runLoopOnce();

}
