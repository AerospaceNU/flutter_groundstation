import 'package:flutter/material.dart';

import '../graph_widget.dart';
import '../../constants.dart';
import '../stream_widget.dart';

class StreamTab extends StatelessWidget {
  const StreamTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: StreamWidget());
  }
}
