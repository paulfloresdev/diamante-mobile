import 'package:flutter/material.dart';

import '../models/auxiliars/Responsive.dart';

class OptionButton extends StatefulWidget {
  final String label;
  final bool isFocused;
  final double? width;
  final double? fontSize;
  final EdgeInsetsGeometry? margin;
  const OptionButton({
    super.key,
    required this.label,
    required this.isFocused,
    this.width,
    this.fontSize,
    this.margin,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Container(
      width: widget.width,
      height: 4.5 * vw,
      margin: widget.margin,
      padding: EdgeInsets.symmetric(horizontal: 1.5 * vw),
      decoration: BoxDecoration(
        color: widget.isFocused
            ? Theme.of(context).primaryColor
            : Theme.of(context).splashColor,
        border:
            Border.all(color: Theme.of(context).primaryColor, width: 0.1 * vw),
      ),
      child: Center(
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isFocused
                ? Theme.of(context).splashColor
                : Theme.of(context).primaryColor,
            fontSize: widget.fontSize ?? 1.2 * vw,
          ),
        ),
      ),
    );
  }
}
