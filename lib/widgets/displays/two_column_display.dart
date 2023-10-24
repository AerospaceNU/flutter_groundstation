import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../text_data.dart';

/// Widget that displays the given values in a two column format.
///
/// Can automatically resizes text to fit perfectly within its bounds.
class TwoColumnDisplay<T, R> extends StatelessWidget {
  // Container Widget Properties
  /// Container width.
  final double width;

  /// Container height.
  final double height;
  // Display Values
  /// The displayed entries.
  final Map<T, R> entries;

  /// The displayed title.
  final String? title;
  // Child Text Widget Properties
  /// [AutoSizeTextBuilder] for the title.
  late final AutoSizeTextBuilder entryBuilder;

  /// [AutoSizeTextBuilder] for entries.
  late final AutoSizeTextBuilder titleBuilder;
  // Format Options
  /// Whether the display should automatically scale the text to fill
  /// all the available space or not.
  ///
  /// If false, the container will turn into a list view so that all
  /// the data can still be viewed.
  final bool autoFit;

  /// Whether to synchronize the font size of all the entries.
  late final AutoSizeGroup? group;

  /// Creates a [TwoColumnDisplay] widget.
  TwoColumnDisplay({
    required this.entries,
    super.key,
    // Container Properties
    this.width = double.infinity,
    this.height = double.infinity,
    // Text Properties
    this.title,
    TextStyle? titleStyle,
    TextStyle? entryStyle,
    double minFontSize = 12,
    double maxFontSize = double.infinity,
    double stepGranularity = 1,
    List<double>? presetFontSizes = Constants.stdFontSizes,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    bool wrapWords = true,
    TextOverflow? overflow,
    Widget? overflowReplacement,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    // Format Options
    this.autoFit = false,
    bool group = false,
  }) {
    this.group = group ? AutoSizeGroup() : null;
    this.entryBuilder = AutoSizeTextBuilder(
      style: entryStyle,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      stepGranularity: stepGranularity,
      presetFontSizes: presetFontSizes,
      group: this.group,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      wrapWords: wrapWords,
      locale: locale,
      overflow: overflow,
      overflowReplacement: overflowReplacement,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
    this.titleBuilder = AutoSizeTextBuilder(
      style: titleStyle,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      stepGranularity: stepGranularity,
      presetFontSizes: presetFontSizes,
      group: null,
      textAlign: TextAlign.center,
      textDirection: textDirection,
      softWrap: softWrap,
      wrapWords: wrapWords,
      locale: locale,
      overflow: overflow,
      overflowReplacement: overflowReplacement,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50.0, vertical: autoFit ? MediaQuery.of(context).size.height / 100.0 : 0);
    List<Widget> children = [];
    for (final entry in entries.entries) {
      children.add(_createEntryValueRowWidget(entry, padding, context));
    }
    if (title != null) {
      children.insert(0, _createTitleWidget(title!, context));
    }
    return _createContainer(children, context);
  }

  /// creates the container widget that encapsulates the title widget
  /// and row widgets created from [_createTitleWidget] and
  /// [_createEntryValueRowWidget] respectively.
  Widget _createContainer(List<Widget> children, BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      color: Theme.of(context).focusColor,
      alignment: Alignment.center,
      child: autoFit ? Column(children: children) : ListView(children: children),
    );
  }

  /// Creates a row widget that displays [entry.key] to the left
  /// and [entry.value] to the right using [entryBuilder].
  ///
  /// If either [entry.key] or [entry.value] is a [Widget], then they
  /// will be displayed and rendered as usual.
  ///
  /// The auto-generated [AutoTextWidget] for non-widget objects makes
  /// use the [toString] to generate the text to display. It is
  /// recommended to convert the non-widget objects of [entries] to
  /// widgets or strings before constructing the [TwoColumnDisplay]
  /// if nonsense is displayed.
  Widget _createEntryValueRowWidget(MapEntry<T, R> entry, EdgeInsets padding, BuildContext context) {
    return EntryData(entry: entry, builder: entryBuilder, padding: padding);
  }

  /// Creates a title widget with the specified [title] using [titleBuilder].
  Widget _createTitleWidget(String title, BuildContext context) {
    final Widget titleRow = Row(children: [Expanded(child: titleBuilder.build(title))]);
    // Uses Expanded to split all available space with other children
    // Uses SizedBox to keep space taken up to a constant
    return autoFit
        ? Expanded(child: titleRow)
        : SizedBox(
            height: titleBuilder.style?.fontSize?.toDouble() ?? 12.0 * 3,
            child: titleRow,
          );
  }
}
