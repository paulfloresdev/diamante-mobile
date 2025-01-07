import 'package:diamante_mobile/src/database/DatabaseService.dart';
import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:diamante_mobile/src/widgets/Header/HeaderOption.dart';
import 'package:diamante_mobile/src/widgets/Input.dart';
import 'package:flutter/material.dart';

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
                '¿Estás seguro de que deseas eliminar este grupo?',
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
                  IconButton(
                    onPressed: () {
                      print('testing btn');
                    },
                    icon: Icon(
                      Icons.more_vert,
                      size: 2 * vw,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
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
                HeaderOption(
                  label: '+',
                  isFocused: false,
                  onPressed: _showAddGroupDialog,
                  width: 5 * vw,
                  fontSize: 1.6 * vw,
                ),
                HeaderOption(
                  label: 'Cotización',
                  isFocused: widget.page == 0,
                  onPressed: _showAddGroupDialog,
                  width: 10 * vw,
                  fontSize: 1.2 * vw,
                ),
                Container(
                  width: 78 * vw,
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
                            return HeaderOption(
                              label: group['nombre'],
                              isFocused: false,
                              onPressed: () {},
                              onLongPress: () => _showEditGroupDialog(
                                  group['nombre'], group['id']),
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
