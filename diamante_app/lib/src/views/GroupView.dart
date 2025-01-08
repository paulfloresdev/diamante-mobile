import 'package:diamante_app/src/models/auxiliars/Router.dart';
import 'package:flutter/material.dart';

import '../database/DatabaseService.dart';
import '../models/auxiliars/Responsive.dart';
import '../widgets/Dialogs-Snackbars/CustomSnackBar.dart';
import '../widgets/Dialogs-Snackbars/SingleInputDialog.dart';
import '../widgets/Header.dart';
import '../widgets/SubgroupOption.dart';

class GroupView extends StatefulWidget {
  final int groupId;
  final int subGroupId;
  const GroupView({super.key, required this.groupId, required this.subGroupId});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  final TextEditingController _addSubGroupController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureSubGroups;
  late int page;

  @override
  void initState() {
    super.initState();
    _reload();
    if (widget.subGroupId != 0) {
      page = widget.subGroupId;
    } else {
      getFirstId();
    }
  }

  void getFirstId() async {
    final data = await _futureSubGroups;
    if (data.isEmpty) {
      page = 0;
    } else {
      page = data.first['id'];
    }
  }

  void _reload() {
    _futureSubGroups =
        DatabaseService.instance.getSubgruposByGrupo(widget.groupId);
  }

  // Agregar nuevo grupo
  Future<void> addSubGroup() async {
    final subGroupName = _addSubGroupController.text.trim();
    if (subGroupName.isNotEmpty) {
      await DatabaseService.instance
          .createSubgrupo(subGroupName, widget.groupId);
      CustomSnackBar(context: context).show('Subgrupo creado correctamente.');
      setState(() {
        // Actualiza la lista de grupos después de agregar uno
        _reload();
      });
      _addSubGroupController.clear();
      Navigator.of(context).pop(); // Cierra el diálogo
    } else {
      CustomSnackBar(context: context)
          .show('El nombre del subgrupo no puede estar vacío.');
    }
  }

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleInputDialog(
          title: 'Nuevo subgrupo',
          inputController: _addSubGroupController,
          inputHint: 'Nombre',
          onConfirm: addSubGroup,
          confirmLabel: 'Guardar',
        );
      },
    );
  }

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
                      border: Border(
                          right: BorderSide(
                              width: 0.1 * vw, color: Colors.grey.shade500))),
                  child: Column(
                    children: [
                      SubgroupOption(
                        label: '+',
                        groupId: 0,
                        isFocused: false,
                        fontSize: 1.6 * vw,
                        onPressed: _showAddGroupDialog,
                      ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _futureSubGroups,
                        builder: (
                          context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
                        ) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          }
                          if (snapshot.data!.isEmpty) {
                            return SizedBox(
                              child: Text('empty'),
                            );
                          }
                          final subGroups = snapshot.data!;
                          return Container(
                            width: double.maxFinite,
                            height: 6.5 * vw * subGroups.length,
                            child: ListView.builder(
                              itemCount: subGroups.length,
                              itemBuilder: (context, index) {
                                final subGroup = subGroups[index];
                                return SubgroupOption(
                                  label: subGroup['nombre'],
                                  groupId: subGroup['id'],
                                  isFocused: subGroup['id'] == page,
                                  margin: EdgeInsets.only(top: 1.5 * vw),
                                  onPressed: () => Routes(context).goTo(
                                    GroupView(
                                      groupId: widget.groupId,
                                      subGroupId: subGroup['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
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
