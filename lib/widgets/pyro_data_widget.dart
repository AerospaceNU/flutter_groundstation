// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'base_widget.dart';

class PyroDataWidget extends StatefulWidget {
  const PyroDataWidget({super.key});

  @override
  State<PyroDataWidget> createState() => _PyroWidgetState();
}

class _PyroWidgetState extends BaseWidgetState<PyroDataWidget> {
  var event = ['Approved', 'Rejected', 'Approved', 'Approved', 'Approved', 'Approved'];

  _PyroWidgetState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 600,
      width: 250,
      child: Column(
        
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  width: 250,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('Pyro Output Data'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Container(
                height: 400,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black)),
                child: const Center(
                  child: Text('1'),
                ),
              )
            ),
            ],
          ),
        ],
      ),
    );
  }
}