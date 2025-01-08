import 'package:diamante_app/src/widgets/Dialogs-Snackbars/ConfirmDialog.dart';
import 'package:diamante_app/src/widgets/Dialogs-Snackbars/CustomSnackBar.dart';
import 'package:diamante_app/src/widgets/Dialogs-Snackbars/SingleInputDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../database/DatabaseService.dart';
import '../models/auxiliars/Responsive.dart';
import '../models/auxiliars/Router.dart';
import '../views/OverView.dart';
import 'CircularIconButton.dart';
import 'GroupOption.dart';

class Header extends StatefulWidget {
  final int page;
  const Header({super.key, required this.page});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController _addGroupController = TextEditingController();
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
      final dbPath = '/data/user/0/com.example.myapp/databases/app_database.db';

      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        print('La base de datos no existe.');
        return;
      }

      // Solicita permiso para acceder a almacenamiento externo
      final status = await Permission.manageExternalStorage.request();
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

      final exportPath =
          '${downloadDir.path}/Plantilla-exportada-${DateFormat('yyyy-MM-dd-hhmmss').format(DateTime.now())}.db';
      await dbFile.copy(exportPath);

      // Comparte el archivo exportado
      await Share.shareFiles([exportPath], text: 'Base de datos exportada');
      print('Base de datos exportada exitosamente a: $exportPath');
    } catch (e) {
      print('Error al exportar la base de datos: $e');
    }
  }

  Future<void> selectAndImportDatabase(BuildContext context) async {
    final dbPath = '/data/user/0/com.example.myapp/databases/app_database.db';

    try {
      // Select the .db file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Se puede seleccionar cualquier archivo
      );

      if (result != null) {
        // Path of the selected file
        String selectedFilePath = result.files.single.path!;
        print('Selected file: $selectedFilePath');

        // Show confirmation dialog before replacing the database
        bool shouldReplaceDatabase = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar reemplazo'),
              content: Text(
                '¿Deseas reemplazar la base de datos actual con la nueva plantilla seleccionada? Esta acción eliminará la base de datos actual.',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Don't replace or close the app
                  },
                ),
                TextButton(
                  child: Text('Reemplazar'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Proceed with replacing the database
                  },
                ),
              ],
            );
          },
        );

        // If the user confirmed, proceed with replacing the database
        if (shouldReplaceDatabase) {
          // Check if the selected file exists
          final importedFile = File(selectedFilePath);
          if (!importedFile.existsSync()) {
            throw Exception('The selected file does not exist.');
          }

          // Check if the destination database exists and remove it
          final destinationFile = File(dbPath);
          if (destinationFile.existsSync()) {
            print('Deleting existing database at: $dbPath');
            destinationFile.deleteSync();
          }

          // Copy the file to the database location
          importedFile.copySync(dbPath);
          print('Database copied to: $dbPath');

          // Verify the database has been copied
          if (destinationFile.existsSync()) {
            print('Database imported successfully.');

            // Show confirmation dialog before closing the app
            bool shouldCloseApp = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Plantilla Importada'),
                  content: Text(
                      'La plantilla ha sido importada con éxito. La app se cerrará ahora.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cerrar app'),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Close the app
                      },
                    ),
                  ],
                );
              },
            );

            // If the user confirmed, close the app
            if (shouldCloseApp) {
              SystemNavigator.pop(); // This will close the app
            }
          } else {
            throw Exception('Error importing the database.');
          }
        } else {
          print('Database import canceled.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error during database import: $e');
    }
  }

  // Agregar nuevo grupo
  Future<void> addGroup() async {
    final groupName = _addGroupController.text.trim();
    if (groupName.isNotEmpty) {
      await DatabaseService.instance.createGrupo(groupName);
      CustomSnackBar(context: context).show('Grupo creado correctamente.');
      setState(() {
        // Actualiza la lista de grupos después de agregar uno
        _loadGroups();
      });
      _addGroupController.clear();
      Navigator.of(context).pop(); // Cierra el diálogo
    } else {
      CustomSnackBar(context: context)
          .show('El nombre del grupo no puede estar vacío.');
    }
  }

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleInputDialog(
          title: 'Nuevo grupo',
          inputController: _addGroupController,
          inputHint: 'Nombre',
          onConfirm: addGroup,
          confirmLabel: 'Guardar',
        );
      },
    );
  }

  Future<void> editGroup(String newGroupName, int groupId) async {
    if (newGroupName.isNotEmpty) {
      await DatabaseService.instance.updateGrupo(groupId, newGroupName);
      CustomSnackBar(context: context).show('Grupo actualizado correctamente.');
      _loadGroups(); // Recarga los grupos.
      Navigator.of(context).pop(); // Cierra el diálogo.
    } else {
      CustomSnackBar(context: context)
          .show('El nombre del grupo no puede estar vacío.');
    }
  }

  void _showEditGroupDialog(String currentName, int groupId) {
    final TextEditingController editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return SingleInputDialog(
          title: 'Editar grupo',
          inputController: editController,
          inputHint: 'Nombre',
          inputValue: currentName,
          onConfirm: () => editGroup(editController.text.trim(), groupId),
          confirmLabel: 'Guardar',
          onDecline: () async {
            final bool confirmDelete = await _showDeleteConfirmationDialog();

            if (confirmDelete) {
              await DatabaseService.instance.deleteGrupo(groupId);
              CustomSnackBar(context: context)
                  .show('Grupo eliminado correctamente.');

              // Cierra el diálogo inmediatamente
              Navigator.of(context).pop();

              // Actualiza la lista de grupos después de eliminar
              setState(() {
                _loadGroups();
              });

              // Verifica si el grupo eliminado es el que está visible en la página actual
              if (groupId == widget.page) {
                // Realiza la navegación después de que el diálogo se cierre
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OverView()), // Navega a Overview
                );
              }
            } else {
              Navigator.of(context)
                  .pop(); // Cierra el diálogo si no se confirma la eliminación
            }
          },
          declineLabel: 'Eliminar',
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: 'Confirmar Eliminación',
              subTitle:
                  '¿Estás seguro de que deseas eliminar este grupo?\nTodos los datos contenidos en él también se perderán.',
              confirmLabel: 'Eliminar',
              confirmColor: Colors.redAccent.shade700,
              declineLabel: 'Cancelar',
              declineColor: Colors.grey.shade700,
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
                        await exportDatabase();
                      },
                      icon: Icons.arrow_upward_rounded),
                  CircularIconButton(
                      onTap: () async {
                        await selectAndImportDatabase(context);
                      },
                      icon: Icons.arrow_downward_rounded),
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
    _addGroupController.dispose();
    super.dispose();
  }
}
