
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/map_widget.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';

class HomeTab extends StatelessWidget {
  final HomeTopBar topBar;
  final HomeLeftBar leftBar;


  const HomeTab({
    super.key,
    required this.topBar,
    required this.leftBar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: topBar
                ),
                const Expanded(
                  flex: 9,
                  child: Center(
                    child: MapWidget(),
                  )
                )
              ],
            )
          ), Expanded(
            flex: 2,
            child: leftBar,
          )
        ]
    );
  }
}


class ResizeableHomeTab extends StatelessWidget {
  final HomeTopBar topBar;
  final HomeLeftBar leftBar;


  const ResizeableHomeTab({
    super.key,
    required this.topBar,
    required this.leftBar,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: LayoutBuilder(
            builder: (context, constraints) => ResizableContainer(
                direction: Axis.horizontal,
                children: [ResizableChildData(
                    child: ResizableContainer(
                        direction: Axis.vertical,
                        children: [
                          ResizableChildData(
                              child: topBar,
                              startingRatio: 0.1,
                              minSize: constraints.maxHeight / 10
                          ),
                          ResizableChildData(
                              child: const MapWidget(),
                              startingRatio: 0.9,
                              minSize: constraints.maxHeight / 10
                          ),
                        ]
                    ),
                    startingRatio: 0.8,
                    minSize: constraints.maxWidth / 10
                ),
                  ResizableChildData(
                    child: leftBar,
                    startingRatio: 0.2,
                    minSize: constraints.maxWidth / 10,
                  ),
                ]
            )
        )
    );
  }
}

class HomeTopBar extends StatelessWidget {
  final List<Widget> widgets;
  final bool fit;
  final Color? border;

  const HomeTopBar({
    super.key,
    required this.widgets,
    this.fit = true,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return fit ? Row(
      children: widgets.map((w)=>Flexible(
          child: Container(
            width: double.infinity,
            decoration: border != null ? BoxDecoration(
              border: Border.all(color: Colors.black38),
            ) : null,
            child: Center(child: w),
          ))).toList(),
    ) : ListView(
      scrollDirection: Axis.horizontal,
      children: widgets.map((w)=>Flexible(
          child: Container(
            width: double.infinity,
            decoration: border != null ? BoxDecoration(
              border: Border.all(color: Colors.black38),
            ) : null,
            child: Center(child: w),
          ))).toList(),
    );
  }
}

class HomeLeftBar extends StatelessWidget {
  final List<Widget> widgets;
  final bool fit;
  final Color? border;

  const HomeLeftBar({
    super.key,
    required this.widgets,
    this.fit = true,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return fit ? Column(
        children: widgets.map((w)=>Flexible(
            child: Container(
              width: double.infinity,
              decoration: border != null ? BoxDecoration(
                border: Border.all(color: Colors.black38),
              ) : null,
              child: Center(heightFactor: 1, child: w),
            ))).toList(),
    ) : ListView(
        scrollDirection: Axis.vertical,
        children: widgets.map((w)=>Flexible(
            child: Container(
              width: double.infinity,
              decoration: border != null ? BoxDecoration(
                  border: Border.all(color: Colors.black38),
                ) : null,
              child: Center(heightFactor: 1, child: w),
            ))).toList(),
    );
  }
}
