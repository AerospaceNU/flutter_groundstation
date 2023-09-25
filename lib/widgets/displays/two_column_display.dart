import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TwoColumnDisplay<T, R> extends StatelessWidget {
  final String? title;
  final Map<T, R> entries;
  final double width;
  final double height;

  // width and height default infinity to take up as much space as possible
  // by default.
  const TwoColumnDisplay({
    super.key,
    required this.entries,
    this.width = double.infinity,
    this.height = double.infinity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Ideally somehow insert these preferences into the build context of
    // children widgets so that widgets that are not constructed in this
    // block still inherit this formatting stuff.
    EdgeInsets titlePadding = const EdgeInsets.all(25.0);
    EdgeInsets entryPadding = const EdgeInsets.only(left: 25.0, bottom: 10);
    TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;
    TextStyle? entryStyle = Theme.of(context).textTheme.bodyMedium;
    TextAlign entryAlign = TextAlign.left;

    List<Widget> children = [];

    // This shit is horrendous
    for (final entry in entries.entries) {
      children.add(
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: entryPadding,
                  child:
                  entry.key is Widget ?
                  entry.key as Widget :
                  Text(entry.key.toString(),
                    style: entryStyle,
                    textAlign: entryAlign,
                    softWrap: true,
                  ),
                )
              ),
              Expanded(
                flex: 5,
                child:
                  Padding(
                    padding: entryPadding,
                    child:
                    entry.value is Widget ?
                    entry.value as Widget :
                    Text(entry.value.toString(),
                      style: entryStyle,
                      textAlign: entryAlign,
                      softWrap: true,
                    ),
                  )
              )
            ]
          )
      );
    }

    // A bit hacky.
    // Like this because wanted there to not be a huge space between the
    // top of the display when no title is specified.
    if (title != null) {
      children.insert(0, Padding(
          padding: titlePadding,
          child: Text(title!,
            style: titleStyle,
            textAlign: TextAlign.center,)
      ));
    }

    return Container(
      width: this.width,
      height: this.height,
      color: Theme.of(context).focusColor,
      alignment: Alignment.center,
      child: Column(
        children: children,
      )
    );
  }
}