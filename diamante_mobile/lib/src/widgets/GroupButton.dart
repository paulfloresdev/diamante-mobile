import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:flutter/material.dart';

class GroupButton extends StatefulWidget {
  final String label;

  const GroupButton({super.key, required this.label});
  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(right: 1 * vw),
      padding: EdgeInsets.symmetric(horizontal: 1 * vw),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.1 * vw,
        ),
      ),
      child: Center(
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 1.25 * vw,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
