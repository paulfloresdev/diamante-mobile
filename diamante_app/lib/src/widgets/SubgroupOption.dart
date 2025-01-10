import 'package:flutter/material.dart';

import '../models/auxiliars/Responsive.dart';

class SubgroupOption extends StatefulWidget {
  final String label;
  final int groupId;
  final bool isFocused;
  final double? width;
  final double? fontSize;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final EdgeInsetsGeometry? margin;
  const SubgroupOption({
    super.key,
    required this.label,
    required this.groupId,
    required this.isFocused,
    this.width,
    this.fontSize,
    this.onPressed,
    this.onLongPress,
    this.margin,
  });

  @override
  State<SubgroupOption> createState() => _SubgroupOptionState();
}

class _SubgroupOptionState extends State<SubgroupOption> {
  get isFocused => null;

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return GestureDetector(
      onTap: widget.onPressed ?? () {},
      onLongPress: widget.onLongPress,
      child: Container(
        width: 18.4 * vw,
        margin: EdgeInsets.only(top: 1.5 * vw),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 2.5 * vw,
              height: 2.5 * vw,
              padding: EdgeInsets.all(0.25 * vw),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.1 * vw,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              child: widget.isFocused
                  ? Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  : null,
            ),
            Container(
              width: 15.4 * vw,
              padding: EdgeInsets.symmetric(vertical: 0.25 * vw),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 1.2 * vw,
                  color: Theme.of(context).primaryColor,
                  fontWeight:
                      widget.isFocused ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
      /*child: OptionButton(
        label: widget.label,
        isFocused: widget.isFocused,
        width: widget.width,
        fontSize: widget.fontSize,
        margin: widget.margin,
      ),*/
    );
  }
}
