import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_widget.dart';

/// Data text display for testing the two column display.
/// This is super scuff...
class DataDisplay extends StatefulWidget {
  final String dataKey;

  DataDisplay({super.key, required this.dataKey}) {}

  @override
  State<StatefulWidget> createState() => _DataDisplayState();
}

class _DataDisplayState extends BaseWidgetState<DataDisplay> {
  bool _subscribed = false;

  _DataDisplayState();

  @override
  Widget build(BuildContext context) {
    if (!_subscribed) {
      super.subscribeToDatabaseKey(widget.dataKey);
      _subscribed = true;
    }
    final data = super.getDatabaseValueOrNull(widget.dataKey);
    final defaultVal = data is num ? 0 : "N\\A";

    return Text(
      (data ?? defaultVal).toString(),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
