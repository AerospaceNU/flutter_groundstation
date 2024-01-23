
import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/hardware_interface/fcb_client_interface.dart';

class SerialTab extends StatelessWidget {
  final List<Widget> cache = CircularBuffer.empty(100);
  SerialTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FcbConsole(cache);
  }
}

class FcbConsole extends StatefulWidget {
  FcbConsole(this.buffer, {super.key});

  final TextEditingController controller = TextEditingController();
  final FcbClientInterface serial = FcbClientInterface();
  final List<Widget> buffer;
  final AutoSizeGroup group = AutoSizeGroup();

  @override
  State<StatefulWidget> createState() => _FcbConsoleState();
}

class _FcbConsoleState extends State<FcbConsole> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            onSubmitted: (str) async {
              setState(() {
                // update widget
              });
              widget.buffer.add(AutoSizeText(str, group: widget.group));
              try {
                widget.buffer.add(AutoSizeText(await widget.serial.runCommand(str), group: widget.group));
              } catch(e) {
                // ignore errors
              }
              widget.controller.clear();
            },
          ),
        ), Expanded(
          flex: 9,
          child: ListView(
            children: List.of(widget.buffer),
          ),
        ),
      ]
    );
  }

}

class CircularBuffer<T> with ListMixin<T> {
  CircularBuffer.empty(this.bufSize) {
    buffer = List.filled(bufSize, null, growable: true);
  }

  late final List<T?> buffer;
  final int bufSize;
  int _len = 0;
  int _start = 0;
  int _end = 0;

  @override
  int get length => _len;

  @override
  set length(int newLength) {
    throw StateError("Buffer is not growable.");
  }

  @override
  void add(T element) {
    buffer[_end] = element;
    _end = (_end + 1) % bufSize;
    if (_start == _end) {
      _start = (_start + 1) % bufSize;
    } else {
      ++_len;
    }
  }

  @override
  T operator [](int index) {
    if (_len <= index) {
      throw IndexError.withLength(index, _len);
    }
    return buffer[(index + _start) % bufSize]!;
  }

  @override
  void operator []=(int index, T value) {
    if (_len <= index) {
      throw IndexError.withLength(index, _len);
    }
    buffer[(index + _start) % bufSize] = value;
  }
}