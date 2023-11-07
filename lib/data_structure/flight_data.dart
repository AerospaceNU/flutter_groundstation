import 'package:flutter_groundstation/data_structure/time_series.dart';


class FlightData {
  Map<String, TimeSeries> data = <String, TimeSeries>{};

  void setTime(double time) {
    TimeSeries.setTime(time);
    for(TimeSeries series in data.values) {
      series.pushUpdate();
    }
  }

  T getValueSafe<T>(String key, T defaultValue) {
    var value = data[key]?.getCurrent();
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
  }

  void newKey<T>(String key, T initialValue) {
    data[key] = TimeSeries<T>(initialValue);
  }

  bool keyExists(String key) {
    return data.containsKey(key);
  }

  TimeSeries? getKey(String key) {
    return data[key];
  }

  T get<T>(String key) {
    return data[key]?.getCurrent();
  }
}


void main() {

}