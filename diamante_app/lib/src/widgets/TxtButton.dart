import 'package:flutter/material.dart';

import '../models/auxiliars/Responsive.dart';

class TxtButton extends StatefulWidget {
  final void Function() onTap;
  final String label;
  final EdgeInsetsGeometry? margin;
  const TxtButton(
      {super.key, required this.onTap, required this.label, this.margin});

  @override
  State<TxtButton> createState() => _TxtButtonState();
}

class _TxtButtonState extends State<TxtButton> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin,
        padding: EdgeInsets.all(0.75 * vw),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1 * vw,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 1.2 * vw,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
