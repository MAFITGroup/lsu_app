import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/widgets/Boton.dart';

class GestionUsuarios extends StatefulWidget {
  @override
  _GestionUsuarios createState() => _GestionUsuarios();
}

class _GestionUsuarios extends State<GestionUsuarios> {
  final formKey = new GlobalKey<FormState>();

  List<String> _tabs = ['ACTIVO', 'PENDIENTE', 'INACTIVO'];

  List<Usuario> pendienteUsuarios = [];
  List<Usuario> activoUsuarios = [];
  List<Usuario> inactivoUsuarios = [];

  Usuario usuario;

  @override
  void initState() {
    inactivoUsuarios.clear();
    listPendientes();
    listInactivos();
    listActivos();
    usuariosPendientes();
    usuariosActivos();
    usuariosInactivos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: _tabs.length, // This is the number of tabs.
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        title: const Text('GESTION DE USUARIOS',
                            style:
                                TextStyle(fontFamily: 'Trueno', fontSize: 16)),
                        // This is the title in the app bar.
                        backgroundColor: Colores().colorAzul,
                        pinned: false,
                        expandedHeight: 150.0,
                        forceElevated: innerBoxIsScrolled,
                        bottom: TabBar(
                          tabs: _tabs
                              .map((String name) => Tab(text: name))
                              .toList(),
                          indicatorColor: Colores().colorBlanco,
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    listActivos(),
                    listPendientes(),
                    listInactivos(),
                  ],
                )

                // TabBarView

                )));
  }

  Widget listPendientes() {

    return Scaffold(
      body: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
              itemCount: pendienteUsuarios.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colores().colorBlanco,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 0))
                      ]),
                  child: ListTile(
                    title: Text(pendienteUsuarios[index].nombreCompleto),
                    subtitle: Text('usuario pendiente'),
                    onTap: () {

                      String nombre = pendienteUsuarios[index].nombreCompleto;
                      String correo = activoUsuarios[index].correo;

                      adminUsuario(nombre, correo);
                    },
                  ),
                );
              });
        }
      }),
    );
  }

  Widget listActivos() {
    return Scaffold(
        body: FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else {
        return ListView.builder(
            itemCount: activoUsuarios.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colores().colorBlanco,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 0))
                    ]),
                child: ListTile(
                    title: Text(activoUsuarios[index].nombreCompleto),
                    subtitle: Text('usuario activo'),
                    onTap: () {}),
              );
            });
      }
    }));
  }

  Widget listInactivos() {
    return Scaffold(
        body: FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else {
        return ListView.builder(
            itemCount: inactivoUsuarios.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colores().colorBlanco,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 0))
                    ]),
                child: ListTile(
                  title: Text(inactivoUsuarios[index].nombreCompleto),
                  subtitle: Text('usuario inactivo'),
                  onTap: () {

                  },
                ),
              );
            });
      }
    }));
  }

  Widget adminUsuario(String nombre, String correo) {

    bool esAdministrador = false;
    bool estado = false;
    String estadoUsuario = 'INACTIVO';

    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(10.0),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              title: Text('Usuario'),
              content: Column(
                children: [
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Nombre: $nombre'),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.group_add_rounded),
                      SizedBox(height: 20.0),
                      Text('Es adminsitrador?'),
                      SizedBox(height: 20.0),
                      Switch(
                        value: esAdministrador,
                        onChanged: (value) {
                          setState(() {
                            esAdministrador = value;
                          });
                        },
                        activeTrackColor: Colores().colorAzul,
                        activeColor: Colores().colorCeleste,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.supervised_user_circle_outlined),
                      SizedBox(height: 20.0),
                      Text('Es un usuario activo'),
                      SizedBox(height: 20.0),
                      Switch(
                        value: estado,
                        onChanged: (value) {
                          estado = value;
                          setState(() {
                            if(estado) {
                              estadoUsuario = 'activo';
                            }
                            else{
                              estadoUsuario = 'inactivo';
                            }

                          });
                        },
                        activeTrackColor: Colores().colorAzul,
                        activeColor: Colores().colorCeleste,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Boton(
                    titulo: 'Guardar',
                    onTap: () {


                      ControladorUsuario().administrarUsuario(correo, estadoUsuario, esAdministrador);

                      showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            title: Text('El usuario $nombre, ha sido actualizado.'),
                            actions: [
                              TextButton(
                                  onPressed: (){

                                    Navigator.of(context).pop();
                                    Navegacion(context).navegarAPaginaGestionUsuario();
                                  },
                                  child: Text('Ok',
                                      style: TextStyle(
                                          color: Colores().colorAzul,
                                          fontFamily: 'Trueno',
                                          fontSize: 11.0,
                                          decoration: TextDecoration.underline)),
                              )
                            ],
                          );
                        }
                      );

                    },
                  )
                ],
              ),
            );
        },
        );
      },
    );
  }

  Future<void> usuariosPendientes() async {
    pendienteUsuarios = await ControladorUsuario().obtenerUsuariosPendiente();
  }

  Future<void> usuariosActivos() async {
    activoUsuarios = await ControladorUsuario().obtenerUsuariosActivos();
  }

  Future<void> usuariosInactivos() async {
    inactivoUsuarios = await ControladorUsuario().obtenerUsuariosInactivos();
  }
}
