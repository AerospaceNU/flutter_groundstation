import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/constants.dart';
import 'package:flutter_groundstation/widgets/base_widget.dart';
import 'package:flutter_groundstation/widgets/text_data.dart';
import '../database.dart';

// doesn't work on hot reload for some reason.
class BatteryIndicator extends StatefulWidget {
  late final Widget? title;
  late final Widget? data;
  late final Size size;
  final String dataKey;
  final double max;
  final double min;

  BatteryIndicator({super.key,
    String? label,
    required this.dataKey,
    this.max = 100,
    this.min = 0,
    double width = double.infinity,
    double height = double.infinity,
    bool displayData = false,
  }) {
    assert(max > min);
    title = label != null ? AutoSizeText(label, presetFontSizes: Constants.stdFontSizes,) : null;
    data = displayData ? ((Database.database.containsKey(dataKey))
        ? TextData(dataKey: dataKey)
        : Text(dataKey, style: const TextStyle(fontSize: 8),)) : null;
    size = Size(width, height);
  }

  @override
  State<StatefulWidget> createState() => _BatteryState();
}

class _BatteryState extends BaseWidgetState<BatteryIndicator> {
  bool _subscribed = false;
  @override
  Widget build(BuildContext context) {
    // fix to move crap to constructor.
    if (!_subscribed && Database.database.containsKey(widget.dataKey)) {
      subscribeToDatabaseKey(widget.dataKey);
      _subscribed = true;
    }
    return Column(children: [
      Flexible(
        child: widget.title != null ? widget.title! : const Padding(padding: EdgeInsets.all(1)),
      ),
      Expanded(
          flex: 4,
          child: CustomPaint(
            painter: _BatteryLevelPainter(
                getDatabaseValue(widget.dataKey, widget.min),
                this, widget.min, widget.max),
            size: widget.size,
            willChange: true,
          )
      ),
      Flexible(
          child : widget.data != null ? widget.data! : const Padding(padding: EdgeInsets.all(1))
      ),
    ]
    );
  }
}

class _BatteryLevelPainter extends CustomPainter {
  final double _batteryLevel;
  final _BatteryState _batteryState;
  final double max;
  final double min;

  _BatteryLevelPainter(this._batteryLevel, this._batteryState, this.min, this.max);

  @override
  void paint(Canvas canvas, Size size) {
    Paint getPaint({Color color = Colors.black, PaintingStyle style = PaintingStyle.stroke}) {
      return Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = style;
    }

    final RRect batteryOutline = RRect.fromLTRBR(0.0, 0.0, size.width, size.height, const Radius.circular(2.0));

    print(size);

    // Battery body
    canvas.drawRRect(
      batteryOutline,
      getPaint(),
    );

    double range = (max-min).abs();
    double percentFull = ((_batteryLevel - min) / range);

    // print("height ${size.height}");
    // print(_batteryLevel);
    // print("$max   $min");
    // print(percentFull);

    canvas.translate(0.0, (size.height - size.height * percentFull)); // add this line
    // Fill rect
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height * percentFull));

    Color indicatorColor;

    if (percentFull < 0.25) {
      indicatorColor = Colors.red;
    } else if (percentFull < .5) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.green;
    }

    canvas.drawRRect(
      RRect.fromLTRBR(0.5, 0.5, size.width - 0.5, size.height - 0.5, const Radius.circular(2.0)),
      getPaint(style: PaintingStyle.fill, color: indicatorColor),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _BatteryLevelPainter old = oldDelegate as _BatteryLevelPainter;

    return old._batteryLevel != _batteryLevel || old._batteryState != _batteryState;
  }
}