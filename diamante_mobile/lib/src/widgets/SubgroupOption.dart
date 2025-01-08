import 'package:diamante_mobile/src/widgets/OptionButton.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: widget.onPressed ?? () {},
      onLongPress: widget.onLongPress,
      child: OptionButton(
        label: widget.label,
        isFocused: widget.isFocused,
        width: widget.width,
        fontSize: widget.fontSize,
        margin: widget.margin,
      ),
    );
  }
}
