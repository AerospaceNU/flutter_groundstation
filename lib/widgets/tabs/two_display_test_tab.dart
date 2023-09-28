import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/displays/data_display.dart';


/// Tab for testing the two column display widget.
class TwoDisplayTestTab extends StatelessWidget {
  const TwoDisplayTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DataDisplay(
        autoFit: true, group: false,
        title: "Test Information",
        const {
          "test": "test",
          "test_2": "test_2",
          "random_1": "random_1",
        }
    );
  }
}

