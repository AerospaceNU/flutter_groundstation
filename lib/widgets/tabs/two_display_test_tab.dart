import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/displays/two_column_display.dart';

import '../displays/data_display.dart';

/// Tab for testing the two column display widget.
class TwoDisplayTestTab extends StatelessWidget {
  const TwoDisplayTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return TwoColumnDisplay(
        title: "Core Info",
        entries: {
          "arbitrary number" : 123912730129312,
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis et"
              + "laoreet nisi. Quisque mollis, est in fringilla facilisis, turpis"
              + "est semper mi, consequat varius diam enim eu ipsum. Vivamus a"
              + "aliquet nisl, eget rutrum eros. Ut ut ex porta, mollis massa eu,"
              + "sagittis tortor. Pellentesque massa nisi, porta eget est at,"
              + "efficitur hendrerit magna. Curabitur tincidunt faucibus bibendum."
              + "Sed quis lorem vitae nisi lacinia scelerisque. Praesent vestibulum"
              + "tincidunt elit, ac sagittis eros condimentum sit amet. Nulla "
              + "facilisi. Quisque varius, diam et accumsan iaculis, mi lacus "
              + "aliquam massa, vitae facilisis diam nisi eget dolor. Nullam sapien"
              + "ante, fermentum id odio vel." : 0,
           'test' : DataDisplay(dataKey: 'test'),
          DataDisplay(dataKey: 'test_2') : 'test2',
           'random': DataDisplay(dataKey: 'random_1'),
          'not in the database' : DataDisplay(dataKey: 'not a key'),
        });
  }
}
