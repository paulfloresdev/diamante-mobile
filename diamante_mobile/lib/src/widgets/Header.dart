import 'package:diamante_mobile/src/database/DatabaseService.dart';
import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:diamante_mobile/src/models/auxiliars/Router.dart';
import 'package:diamante_mobile/src/views/OverView.dart';
import 'package:diamante_mobile/src/widgets/CircularIconButton.dart';
import 'package:diamante_mobile/src/widgets/GroupOption.dart';
import 'package:diamante_mobile/src/widgets/Input.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Header extends StatefulWidget {
  final int page;
  const Header({super.key, required this.page});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController _groupNameController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureGroups;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _futureGroups = DatabaseService.instance.getAllGrupos();
  }

  Future<void> requestStoragePermission() async {
    // Solicitar permisos de almacenamiento
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      print("Permiso de almacenamiento concedido");
    } else if (status.isDenied) {
      print("Permiso de almacenamiento denegado");
    } else if (status.isPermanentlyDenied) {
      // Si el permiso está permanentemente denegado, puedes redirigir al usuario a la configuración
      openAppSettings();
    }
  }

  Future<void> exportDatabase() async {
    await requestStoragePermission();

    // Solicitar permisos de almacenamiento antes de exportar
    try {
      // Localiza la base de datos
      final dbPath =
          '/data/user/0/com.example.diamante_mobile/databases/app_database.db';

      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        print('La base de datos no existe.');
        return;
      }

      // Solicita permiso para acceder a almacenamiento externo
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Permiso denegado para acceder al almacenamiento.');
        return;
      }

      // Copia el archivo a la carpeta Descargas
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        print('No se encontró la carpeta Descargas.');
        return;
      }

      final exportPath = '${downloadDir.path}/my_database.db';
      await dbFile.copy(exportPath);

      // Comparte el archivo exportado
      await Share.shareFiles([exportPath], text: 'Base de datos exportada');
      print('Base de datos exportada exitosamente a: $exportPath');
    } catch (e) {
      print('Error al exportar la base de datos: $e');
    }
  }

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var responsive = Responsive(context);
        var vw = responsive.viewportWidth;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30 * vw),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5 * vw),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2 * vw),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Nuevo grupo',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 1.2 * vw,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 2 * vw),
                          Input(
                              controller: _groupNameController, hint: 'Nombre'),
                          SizedBox(height: 2 * vw),
                          GestureDetector(
                            onTap: () async {
                              final groupName =
                                  _groupNameController.text.trim();
                              if (groupName.isNotEmpty) {
                                await DatabaseService.instance
                                    .createGrupo(groupName);
                                print('Grupo creado: $groupName');

                                setState(() {
                                  // Actualiza la lista de grupos después de agregar uno
                                  _loadGroups();
                                });
                                _groupNameController.clear();
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'El nombre del grupo no puede estar vacío'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 3.5 * vw,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                    color: Theme.of(context).splashColor,
                                    fontSize: 1.2 * vw,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditGroupDialog(String currentName, int groupId) {
    final TextEditingController editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        var responsive = Responsive(context);
        var vw = responsive.viewportWidth;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30 * vw),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5 * vw),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2 * vw),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Editar grupo',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 1.2 * vw,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2 * vw),
                          Input(
                            controller: editController,
                            hint: 'Nuevo nombre',
                          ),
                          SizedBox(height: 2 * vw),
                          GestureDetector(
                            onTap: () async {
                              final newGroupName = editController.text.trim();
                              if (newGroupName.isNotEmpty) {
                                await DatabaseService.instance
                                    .updateGrupo(groupId, newGroupName);
                                print('Grupo actualizado: $newGroupName');
                                _loadGroups(); // Recarga los grupos.
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo.
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'El nombre del grupo no puede estar vacío',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 3.5 * vw,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                    color: Theme.of(context).splashColor,
                                    fontSize: 1.2 * vw,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2 * vw),
                          GestureDetector(
                            onTap: () async {
                              bool confirm =
                                  await _showDeleteConfirmationDialog();

                              if (confirm) {
                                // Llamada a la base de datos para eliminar el grupo
                                await DatabaseService.instance
                                    .deleteGrupo(groupId);
                                print('Grupo eliminado');
                                setState(() {
                                  _loadGroups();
                                });
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              }
                            },
                            child: Container(
                              height: 2 * vw,
                              child: Text(
                                'Eliminar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 1.2 * vw,
                                  color: Colors.redAccent.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            var responsive = Responsive(context);
            var vw = responsive.viewportWidth;

            return AlertDialog(
              title: Text(
                'Confirmar eliminación',
                style:
                    TextStyle(fontSize: 1.2 * vw, fontWeight: FontWeight.w600),
              ),
              content: Text(
                '¿Estás seguro de que deseas eliminar este grupo?\n',
                style:
                    TextStyle(fontSize: 1.2 * vw, fontWeight: FontWeight.w400),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancela la eliminación
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 1.2 * vw,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirma la eliminación
                  },
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                        fontSize: 1.2 * vw, color: Colors.redAccent.shade700),
                  ),
                ),
              ],
            );
          },
        )) ??
        false; // Devuelve false si el valor retornado es nulo
  }

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Container(
      margin: EdgeInsets.only(top: 1.5 * vw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 4 * vw,
                  ),
                  CircularIconButton(
                      onTap: () async {
                        await requestStoragePermission();
                      },
                      icon: Icons.arrow_upward_rounded),
                  CircularIconButton(
                      onTap: () {}, icon: Icons.arrow_downward_rounded),
                  CircularIconButton(
                      onTap: () {}, icon: Icons.restart_alt_outlined),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Hernán Cota',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 1.2 * vw,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 1 * vw),
                  Icon(
                    Icons.person_2_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.5 * vw),
          Container(
            width: 95 * vw,
            height: 5 * vw,
            child: Row(
              children: [
                GroupOption(
                  label: '+',
                  groupId: 0,
                  isFocused: false,
                  onPressed: _showAddGroupDialog,
                  width: 5 * vw,
                  fontSize: 1.6 * vw,
                ),
                GroupOption(
                  label: 'Cotización',
                  groupId: 0,
                  isFocused: widget.page == 0,
                  onPressed: () => Routes(context).goTo(OverView()),
                  width: 10 * vw,
                  fontSize: 1.2 * vw,
                  margin: EdgeInsets.only(left: 1.5 * vw),
                ),
                Container(
                  width: 77 * vw,
                  height: 5 * vw,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureGroups,
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Cargando...');
                      } else if (snapshot.data!.isEmpty) {
                        return Text('Vacía');
                      } else {
                        final groups = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final group = groups[index];
                            return GroupOption(
                              label: group['nombre'],
                              groupId: group['id'],
                              isFocused: widget.page == group['id'],
                              onLongPress: () => _showEditGroupDialog(
                                  group['nombre'], group['id']),
                              margin: EdgeInsets.only(left: 1.5 * vw),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 95 * vw,
            height: 0.075 * vw,
            margin: EdgeInsets.symmetric(vertical: 1.5 * vw),
            decoration: BoxDecoration(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}
