import 'package:flutter/material.dart';

import '../pyro_continuity_widget.dart';
import '../pyro_data_widget.dart';
import 'package:flutter_groundstation/widgets/text_data.dart';

import 'package:flutter/material.dart';

class PropControlTab extends StatelessWidget {
  const PropControlTab({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: CustomBox(title: 'SETTINGS')),
                    SizedBox(width: 8),
                    Expanded(child: CustomBox(title: 'PRIMARY')),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: CustomBox(title: 'DIAGNOSTIC')),
                    SizedBox(width: 8),
                    Expanded(child: CustomBox(title: 'GRAPHS')),
                    SizedBox(width: 8),
                    Expanded(child: CustomBox(title: 'OFFLOAD')),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: CustomBox(title: 'PROP CONTROL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBox extends StatelessWidget {
  final String title;

  const CustomBox({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

