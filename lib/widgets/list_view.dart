import 'dart:collection';

// TODO -- have database keep these around and mutate them, and have widgets hold them as part of their state
class ListView<T> with ListMixin<T> {
  final List<T> _buf;
  final int start, endPlusOne;

  ListView(this.start, this.endPlusOne, this._buf);

  @override
  void add(T element) {
    throw UnsupportedError('Cannot add to list view');
  }

  @override
  int get length => endPlusOne - start;

  @override
  T operator [](int index) {
    return _buf[index + start];
  }

  @override
  void operator []=(int index, T value) {
    throw UnsupportedError('Cannot add to list view');
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot resize a list view.');
  }
}
