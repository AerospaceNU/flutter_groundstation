import 'package:flutter/material.dart';

import '../pyro_continuity_widget.dart';
import '../pyro_data_widget.dart';
import 'package:flutter_groundstation/widgets/text_data.dart';

import 'package:flutter/material.dart';

class PropControlTab extends StatelessWidget {
  const PropControlTab({super.key});

  @override
  Widget build(BuildContext context) {
    // return const TextData(
    //   dataKey: "random_2",
    //   wrapWords: false,
    //   decimals: 6,
    // );
    return const Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}
