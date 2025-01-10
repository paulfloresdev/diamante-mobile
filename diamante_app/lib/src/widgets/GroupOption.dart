import 'package:diamante_app/src/database/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/auxiliars/Router.dart';
import '../views/GroupView.dart';
import 'OptionButton.dart';

class GroupOption extends StatefulWidget {
  final String label;
  final int groupId;
  final bool isFocused;
  final double? width;
  final double? fontSize;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final EdgeInsetsGeometry? margin;
  const GroupOption({
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
  State<GroupOption> createState() => _GroupOptionState();
}

class _GroupOptionState extends State<GroupOption> {
  get isFocused => null;

  Future<int> getFirstId() async {
    final data =
        await DatabaseService.instance.getSubgruposByGrupo(widget.groupId);
    if (data.isEmpty) {
      return 0;
    } else {
      return data.first['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ??
          () async {
            final subgroupId = await getFirstId();

            Routes(context).goTo(GroupView(
              groupId: widget.groupId,
              subGroupId: subgroupId,
            ));
          },
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
