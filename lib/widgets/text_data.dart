import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/database.dart';
import 'package:flutter_groundstation/widgets/displays/two_column_display.dart';

import 'base_widget.dart';

/// Text widget that displays data from the [Database] given a [dataKey].
///
/// Can automatically resize to fit within its bounds.
class TextData extends StatefulWidget {
  final AutoSizeTextBuilder? textBuilder;
  final String dataKey;
  final int? decimals;
  final TextStyle? style;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final AutoSizeGroup? group;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final bool wrapWords;
  final TextOverflow? overflow;
  final Widget? overflowReplacement;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  /// Creates a [TextData] widget.
  ///
  /// If [textBuilder] argument is not null, the will be used to
  /// create the [AutoSizeText] widgets ignoring all other styling
  /// and formatting arguments other than how many [decimals] to
  /// round the data to.
  const TextData({
    super.key,
    required this.dataKey,
    this.decimals,
    this.style,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes = TwoColumnDisplay.stdFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textBuilder,
  });

  @override
  State<StatefulWidget> createState() => _DataDisplayState();
}

class _DataDisplayState extends BaseWidgetState<TextData> {
  bool _subscribed = false;

  _DataDisplayState();

  @override
  Widget build(BuildContext context) {
    if (!_subscribed) {
      super.subscribeToDatabaseKey(widget.dataKey);
      _subscribed = true;
    }
    final data = getData();
    return widget.textBuilder != null ?
    widget.textBuilder!.build(data.toString()) :
        AutoSizeText(
            data.toString(),
            style: widget.style,
            minFontSize: widget.minFontSize,
            maxFontSize: widget.maxFontSize,
            stepGranularity: widget.stepGranularity,
            presetFontSizes: widget.presetFontSizes,
            group: widget.group,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            locale: widget.locale,
            softWrap: widget.softWrap,
            wrapWords: widget.wrapWords,
            overflow: widget.overflow,
            overflowReplacement: widget.overflowReplacement,
            textScaleFactor: widget.textScaleFactor,
            maxLines: widget.maxLines,
            semanticsLabel: widget.semanticsLabel,
        );
  }

  /// Gets data from the [Database] using [widget.dataKey].
  Object getData() {
    var data = super.getDatabaseValueOrNull(widget.dataKey);
    const defaultVal = "N\\A";
    if (data is num && widget.decimals != null) {
      data = data.toStringAsFixed(widget.decimals!);
    }
    return data ?? defaultVal;
  }
}
