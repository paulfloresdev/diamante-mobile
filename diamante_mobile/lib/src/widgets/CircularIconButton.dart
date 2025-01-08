import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatefulWidget {
  final void Function() onTap;
  final IconData icon;
  const CircularIconButton(
      {super.key, required this.onTap, required this.icon});

  @override
  State<CircularIconButton> createState() => _CircularIconButtonState();
}

class _CircularIconButtonState extends State<CircularIconButton> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 2.5 * vw,
        height: 2.5 * vw,
        margin: EdgeInsets.only(left: 2 * vw),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.1 * vw,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: 1.5 * vw,
          ),
        ),
      ),
    );
  }
}
