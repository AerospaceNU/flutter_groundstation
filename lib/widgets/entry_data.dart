import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/database.dart';

import '../constants.dart';
import 'base_widget.dart';

/// Text widget that displays a mapping of some widget to a [TextData].
class EntryData extends StatelessWidget {
  final AutoSizeTextBuilder builder;
  final MapEntry entry;
  final EdgeInsets padding;

  const EntryData({
    super.key,
    required this.entry,
    this.padding = EdgeInsets.zero,
    required this.builder});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
              child: Padding(
                padding: padding,
                child: entry.key is Widget ? entry.key as Widget :
                builder.build(entry.key.toString()),
              )
          ),
          Expanded(
            child: Padding(
                padding: padding,
                child: entry.value is Widget ? entry.value as Widget :
                builder.build(entry.value.toString())
            ),
          ),
        ]
    );
  }
}

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
    this.presetFontSizes = Constants.stdFontSizes,
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
    return widget.textBuilder != null
        ? widget.textBuilder!.build(data.toString())
        : AutoSizeText(
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
      data = data.toStringAsFixed(widget.decimals!).removeTrailingZero();
    }
    return data ?? defaultVal;
  }
}

extension StringRegEx on String {
  String removeTrailingZero() {
    if (!contains('.')) {
      return this;
    }
    String trimmed = replaceAll(RegExp(r'0*$'), '');
    if (!trimmed.endsWith('.')) {
      return trimmed;
    }
    return trimmed.substring(0, trimmed.length - 1);
  }
}

/// An AutoSizeText widget builder to create [AutoSizeText] with specific
/// parameters.
class AutoSizeTextBuilder {
  // purposely made not final as to make properties changeable.
  TextStyle? style;
  double? minFontSize;
  double? maxFontSize;
  double? stepGranularity;
  List<double>? presetFontSizes;
  AutoSizeGroup? group;
  TextAlign? textAlign;
  TextDirection? textDirection;
  Locale? locale;
  bool? softWrap;
  bool? wrapWords;
  TextOverflow? overflow;
  Widget? overflowReplacement;
  double? textScaleFactor;
  int? maxLines;
  String? semanticsLabel;

  /// Creates a [AutoSizeTextBuilder] that will build [AutoSizeText] widgets
  /// with the specified parameters.
  ///
  /// All default values are set properly except for [presetFontSizes], which
  /// is set to [TwoColumnDisplay.stdFontSizes] for optimization.
  AutoSizeTextBuilder({
    this.style,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes = Constants.stdFontSizes,
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
  });

  // values that require not null are handled by saying
  //
  // _variable ?? default_value,
  //
  // since the way these builders are constructed force
  // any unspecified parameters to be null, causing some
  // type error. basically bad code.
  /// Creates a [AutoSizeText] widget with the pre-determined parameters.
  AutoSizeText build(String data) {
    return AutoSizeText(
      data,
      style: style,
      minFontSize: minFontSize ?? 12,
      maxFontSize: maxFontSize ?? double.infinity,
      stepGranularity: stepGranularity ?? 1,
      presetFontSizes: presetFontSizes,
      group: group,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      wrapWords: wrapWords ?? true,
      overflow: overflow,
      overflowReplacement: overflowReplacement,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
