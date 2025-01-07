import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:flutter/material.dart';

class HeaderOption extends StatefulWidget {
  final String label;
  final bool isFocused;
  final void Function() onPressed;
  final double? width;
  final double? fontSize;
  final void Function()? onLongPress;
  const HeaderOption({
    super.key,
    required this.label,
    required this.isFocused,
    required this.onPressed,
    this.width,
    this.fontSize,
    this.onLongPress,
  });

  @override
  State<HeaderOption> createState() => _HeaderOptionState();
}

class _HeaderOptionState extends State<HeaderOption> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return GestureDetector(
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: Container(
        width: widget.width,
        height: 5 * vw,
        margin: EdgeInsets.only(right: 1 * vw),
        padding: EdgeInsets.symmetric(horizontal: 1.5 * vw),
        decoration: BoxDecoration(
          color: widget.isFocused
              ? Theme.of(context).primaryColor
              : Theme.of(context).splashColor,
          border: Border.all(
              color: Theme.of(context).primaryColor, width: 0.1 * vw),
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
      ),
    );
  }
}
