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
    activoUsuarios.clear();
    pendienteUsuarios.clear();
    listPendientes();
    listInactivos();
    listActivos();

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
      body: Container(
        child: FutureBuilder(
            future: usuariosPendientes(),
            builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:  Image.asset('recursos/logo-carga.gif'),
            );
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
                      subtitle: Text('Correo : ' + pendienteUsuarios[index].correo +
                          '\nCelular: ' + pendienteUsuarios[index].telefono  +
                          '\nDepartamento: ' + pendienteUsuarios[index].localidad +
                          '\nEspecialidad: ' + pendienteUsuarios[index].especialidad),
                      onTap: () {

                        String nombre = pendienteUsuarios[index].nombreCompleto;
                        String correo = pendienteUsuarios[index].correo;
                        String estado = pendienteUsuarios[index].statusUsuario;
                        bool esAdmin = pendienteUsuarios[index].esAdministrador;

                        adminUsuario(nombre, correo, estado, esAdmin);

                      },
                    ),
                  );
                });
          }
        }),
      ),
    );
  }

  Widget listActivos() {
    return Scaffold(
        body: Container(
          child: FutureBuilder(
            future: usuariosActivos(),
              builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:  Image.asset('recursos/logo-carga.gif'),
          );
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
                      subtitle: Text('Correo : ' + activoUsuarios[index].correo +
                      '\nCelular: ' + activoUsuarios[index].telefono  +
                      '\nDepartamento: ' + activoUsuarios[index].localidad +
                      '\nEspecialidad: ' + activoUsuarios[index].especialidad),
                      onTap: () {
                        String nombre = activoUsuarios[index].nombreCompleto;
                        String correo = activoUsuarios[index].correo;
                        String estado = activoUsuarios[index].statusUsuario;
                        bool esAdmin = activoUsuarios[index].esAdministrador;

                        adminUsuario(nombre, correo, estado, esAdmin);


                      }),
                );
              });
      }
    }),
        ));
  }

  Widget listInactivos() {
    return Scaffold(
        body: Container(
          child: FutureBuilder(
              future: usuariosInactivos(),
              builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:  Image.asset('recursos/logo-carga.gif'),
          );
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
                    subtitle: Text('Correo : ' + inactivoUsuarios[index].correo +
                        '\nCelular: ' + inactivoUsuarios[index].telefono  +
                        '\nDepartamento: ' + inactivoUsuarios[index].localidad +
                        '\nEspecialidad: ' + inactivoUsuarios[index].especialidad),
                    onTap: () {

                      String nombre = inactivoUsuarios[index].nombreCompleto;
                      String correo = inactivoUsuarios[index].correo;
                      String estado = inactivoUsuarios[index].statusUsuario;
                      bool esAdmin = inactivoUsuarios[index].esAdministrador;

                      adminUsuario(nombre, correo, estado, esAdmin);


                    },
                  ),
                );
              });
      }
    }),
        ));
  }

  Widget adminUsuario(String nombre, String correo, String estadoU, bool esAdmin) {

    bool esAdministrador = esAdmin;
    bool estado;
    String estadoUsuario = estadoU;

    if(estadoU == 'PENDIENTE' || estadoU == 'INACTIVO'){
      estado = false;
    }
    if(estadoU == 'ACTIVO' ){
      estado = true;
    }

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(2.0),
              title: Text('Usuario'),
              content: SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Nombre: $nombre'),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Icon(Icons.group_add_rounded)
                          ),
                          Expanded(
                              child: Text('Administrador')
                          ),
                          Expanded(
                            child:Switch(
                              value: esAdministrador,
                              onChanged: (value) {
                                setState(() {
                                  esAdministrador = value;
                                });
                              },
                              activeTrackColor: Colores().colorAzul,
                              activeColor: Colores().colorCeleste,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Icon(Icons.supervised_user_circle_outlined)
                          ),
                          Expanded(
                              child: Text('Activo')
                          ),
                          Expanded(
                            child: Switch(
                              value: estado,
                              onChanged: (value) {
                                estado = value;
                                setState(() {
                                  if(estado) {
                                    estadoUsuario = 'ACTIVO';
                                  }
                                  else{
                                    estadoUsuario = 'INACTIVO';
                                  }

                                });
                              },
                              activeTrackColor: Colores().colorAzul,
                              activeColor: Colores().colorCeleste,
                            ),
                          )

                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 40),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Boton(
                        titulo: 'Guardar',
                        onTap: () {
                          Navigator.of(context).pop();

                          ControladorUsuario().administrarUsuario(correo, estadoUsuario, esAdministrador);

                          showDialog(
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
                                        Navegacion(context).navegarAPaginaGestionUsuarioDest();
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
                      ),
                      TextButton(
                        child: const Text('ATRAS'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),


                ],
              ),
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
