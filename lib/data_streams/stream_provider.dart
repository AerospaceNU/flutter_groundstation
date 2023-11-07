import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class StreamProvider extends ChangeNotifier {
  /// Internal, private state of the provider.
  final List<dynamic> _items = [];

  // this represents the last piece of information we added to items and notified our listeners about
  dynamic lastSentMessage;

  // this represents the next piece of information we're looking to send out, if any of the fields we care about have changed
  dynamic newestInformationReceived;

  // This is the number of packets we've received so far since sending the last message
  int numberOfPackets = 0;

  // An unmodifiable view of the items in the provider.
  UnmodifiableListView<dynamic> get items => UnmodifiableListView(_items);

  List<String> importantFields = [];

  StreamProvider(this.importantFields);

  /// Adds the dictionary entry of only the fields we care about to the listeners. This and [removeAll] are the only ways to modify the
  /// provider.
  void add(dynamic item) {
    updateInformationToSend(item);
    _items.add(newestInformationReceived);
    lastSentMessage = newestInformationReceived;
    notifyListeners();
  }

  // update what we know as the newest information using the dictionary entry handed to us
  void updateInformationToSend(dynamic dictionary) {
    for (var field in importantFields) {
        newestInformationReceived[field] = dictionary[field];
      }
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}