import 'dart:collection';

import 'package:flutter/material.dart';

// TODO -- have database keep these around and mutate them, and have widgets hold them as part of their state
class ListView<T> with ListMixin<T>, ChangeNotifier {
  final List<T> _buf;
  final int start, endPlusOne;

  ListView(this.start, this.endPlusOne, this._buf);

  @override
  void add(T element) {
    _buf.add(element);
    notifyListeners();
  }

  @override
  int get length => endPlusOne - start;

  @override
  set length(int newLength) {
    // TODO: implement length
  }

  @override
  T operator [](int index) {
    return _buf[index + start];
  }

  @override
  void operator []=(int index, T value) {
    _buf[index] = value;
    notifyListeners();
  }
}
