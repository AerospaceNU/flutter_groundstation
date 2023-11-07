import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class StreamProvider extends ChangeNotifier {
  /// Internal, private state of the provider.
  final List<dynamic> _items = [];

  dynamic lastSentMessage;

  dynamic newestInformationReceived;

  /// An unmodifiable view of the items in the provider.
  UnmodifiableListView<dynamic> get items => UnmodifiableListView(_items);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// provider.
  void add(dynamic item) {
    if (!lastSentMessage) {
      // if a message hasn't been sent yet, immediately save this and send it over
    }
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}