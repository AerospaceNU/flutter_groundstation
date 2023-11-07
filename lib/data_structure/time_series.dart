import 'dart:collection';

void streamMagicPlaceholder<T>(T a) {}

final class TimeStampedData<T> extends LinkedListEntry<TimeStampedData<T>> {
  late final T data;
  late final double time;

  TimeStampedData(T data_, double time_) {
    data = data_;
    time = time_;
  }

  @override
  String toString() {
    return '($time, $data)';
  }
}

final class TimeSeriesLiteral<T> {
  List<double> times;
  List<T> data;

  TimeSeriesLiteral()
      : times = <double>[],
        data = <T>[];

  @override
  String toString() {
    return '$times\n$data';
  }
}

class TimeSeries<T> {
  static const double LIVE_TIME = -1;

  final LinkedList<TimeStampedData<T>> _mData = LinkedList<TimeStampedData<T>>();
  static double _maxTime = LIVE_TIME;
  TimeStampedData<T> _activeElement;
  TimeStampedData<T> _lastPushedElement;

  /// Public
  TimeSeries(T startVal)
      : _activeElement = TimeStampedData(startVal, 0),
        _lastPushedElement = TimeStampedData(startVal, 0) {
    makeLive();
    addData(startVal, 0);
    _activeElement = _mData.first;
  }

  void pushUpdate() {
    _findAcviceElement();
    if (_lastPushedElement == _activeElement) {
      _lastPushedElement = _activeElement;
      streamMagicPlaceholder(_activeElement);
    }
  }

  static void makeLive() {
    _maxTime = LIVE_TIME;
  }

  static bool live() {
    return _maxTime != LIVE_TIME;
  }

  static void setTime(double time) {
    _maxTime = time;
  }

  void addData(T t, double time) {
    _mData.add(TimeStampedData<T>(t, time));
    pushUpdate();
  }

  T getCurrent() {
    _findAcviceElement();
    return _activeElement.data;
  }

  TimeSeriesLiteral<T> getTimeRange({double startTime = 0, double endTime = -1}) {
    /// Get a valid end time
    if (endTime <= startTime) {
      endTime = live() ? _activeElement.time : _maxTime;
    }

    TimeSeriesLiteral<T> output = TimeSeriesLiteral();
    TimeStampedData<T> el = _getByTime(startTime);

    while (el.time <= endTime) {
      output.data.add(el.data);
      output.times.add(el.time);
      if (el.next == null) {
        return output;
      }
      el = el.next!;
    }
    return output;
  }

  T getByTime(double time) {
    return _getByTime(time).data;
  }

  /// Private
  TimeStampedData<T> _getByTime(double time) {
    TimeStampedData<T> el = _mData.first;
    while (el.time < time) {
      if (el.next == null) {
        return el;
      }
      el = el.next!;
    }
    return el;
  }

  void _findAcviceElement() {
    /// If we are live the active element is always the most recent one
    if (live()) {
      _activeElement = _mData.last;
      return;
    }

    /// Move the active element back to the current time if it's past the current time
    if (_activeElement.time > _maxTime) {
      while (_activeElement != _mData.first && _activeElement.time > _maxTime) {
        _activeElement = _activeElement.previous!;
      }
    }

    /// Move the element forward until it's live
    else if (_activeElement.time < _maxTime) {
      while (_activeElement != _mData.last && _activeElement.time < _maxTime) {
        _activeElement = _activeElement.next!;
      }
    }
  }
}

void main() {
  TimeSeries<double> timeSeries = TimeSeries<double>(0);

// TimeSeries.makeLive();
// bool isLive = TimeSeries.live();
// TimeSeries.setTime(1);

  print(timeSeries.getCurrent());
  timeSeries.addData(599, 0.01);
  print(timeSeries.getCurrent());
  timeSeries.addData(595, 0.1);
  print(timeSeries.getCurrent());
  timeSeries.addData(597, 0.2);
  print(timeSeries.getCurrent());

  print(timeSeries.getByTime(0.5));
  print(timeSeries.getByTime(0));
// TimeSeries.setTime(0.15);
  print(timeSeries.getTimeRange());
// double dataPoint = timeSeries.getByTime(0.5);
}
