import 'package:flutter/material.dart';

class CustomColumn extends StatelessWidget {
  final double spaceHeight;
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  const CustomColumn({
    Key? key,
    required this.spaceHeight,
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: children
          .map((e) => Padding(
                padding: EdgeInsets.only(top: spaceHeight),
                child: e,
              ))
          .toList(),
    );
  }
}
