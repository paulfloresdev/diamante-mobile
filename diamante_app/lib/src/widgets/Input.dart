import 'package:flutter/material.dart';
import '../models/auxiliars/Responsive.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const Input({super.key, required this.controller, required this.hint});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return SizedBox(
      height: 4 * vw,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey.shade700),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 0.1 * vw,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.1 * vw,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 1.0 * vw,
            horizontal: 1.5 * vw,
          ),
        ),
        style: TextStyle(
          fontSize: 1.2 * vw,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
