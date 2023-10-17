import 'package:flutter_groundstation/widgets/displays/two_column_display.dart';

import '../text_data.dart';

// everything about this and the two column display is scuff.
/// Widgets that displays data form the [Database] in a two column format.
///
/// Highly recommended to set the [decimals] parameter to a nonnull value.
/// Not doing so will cause the data to 'jitter' uncontrollably.
class DataDisplay extends TwoColumnDisplay<String, TextData> {
  DataDisplay(
    Map<String, String> entries, {
    super.key,
    super.width = double.infinity,
    super.height = double.infinity,
    super.title,
    super.titleStyle,
    super.entryStyle,
    super.minFontSize,
    super.maxFontSize,
    super.stepGranularity,
    super.presetFontSizes,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.wrapWords,
    super.overflow,
    super.overflowReplacement,
    super.textScaleFactor,
    super.maxLines = 3,
    super.semanticsLabel,
    super.autoFit = false,
    super.group = true,
    int? decimals,
  }) : super(entries: {}) {
    for (MapEntry<String, String> entry in entries.entries) {
      super.entries[entry.key] = TextData(
        dataKey: entry.value,
        textBuilder: super.entryBuilder,
        decimals: decimals,
      );
    }
  }
}
