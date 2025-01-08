import 'package:diamante_mobile/src/database/DatabaseService.dart';
import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:diamante_mobile/src/widgets/Header.dart';
import 'package:diamante_mobile/src/widgets/SubgroupOption.dart';
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  final int groupId;
  const GroupView({super.key, required this.groupId});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5 * vw),
        child: ListView(
          children: [
            Header(page: widget.groupId),
            Row(
              children: [
                Container(
                  width: 20 * vw,
                  padding: EdgeInsets.only(right: 1.5 * vw),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border(
                          right: BorderSide(
                              width: 0.1 * vw,
                              color: Theme.of(context).primaryColor))),
                  child: Column(
                    children: [
                      SubgroupOption(
                        label: '+',
                        groupId: 0,
                        isFocused: false,
                        fontSize: 1.6 * vw,
                        onPressed: () async {
                          await DatabaseService.instance.printDatabasePath();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
