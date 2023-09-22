import 'package:flutter/material.dart';

import '../test_widget.dart';
import '../graph_widget.dart';

class GraphTab extends StatelessWidget {
  const GraphTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children: const <Widget>[
        GraphWidget(),
        GraphWidget(),
        GraphWidget(),
        GraphWidget(),
        GraphWidget(),
        GraphWidget(),
      ],
    );
  }
}
