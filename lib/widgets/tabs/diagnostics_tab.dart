import 'package:flutter/material.dart';

import '../pyro_continuity_widget.dart';
import '../pyro_data_widget.dart';

class DiagnosticsTab extends StatelessWidget {
  const DiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children: const <Widget>[
        PyroContinuityWidget(),
        PyroDataWidget(),
      ],
    );
  }
}
