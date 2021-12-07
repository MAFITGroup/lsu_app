import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/buscadores/BuscadorUsuario.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/pantallas/Gestion%20de%20Usuario/VisualizarUsuario.dart';

class GestionUsuarios extends StatefulWidget {
  @override
  _GestionUsuarios createState() => _GestionUsuarios();
}

class _GestionUsuarios extends State<GestionUsuarios> {
  final formKey = new GlobalKey<FormState>();

  List<Usuario> pendienteUsuarios = [];
  List<Usuario> activoUsuarios = [];
  List<Usuario> inactivoUsuarios = [];
  List<Usuario> listaUsuarios = [];

  Usuario usuario;
  bool isUsuarioAdmin;

  int _selectedIndexForBottomNavigationBar = 0;
  int _selectedIndexForTabBar = 0;



  @override
  void initState() {
    inactivoUsuarios.clear();
    activoUsuarios.clear();
    pendienteUsuarios.clear();
    listPendientes();
    listInactivos();
    listActivos();
    listUsuarios();
    obtenerUsuarioAdministrador();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void _onItemTappedForTabBar(int index) {
      setState(() {
        _selectedIndexForTabBar = index + 1;
        _selectedIndexForBottomNavigationBar = 0;
      });
    }

    final tabBar = new TabBar(
      labelColor: Colores().colorBlanco,
      indicatorColor: Colores().colorBlanco,
      labelStyle: TextStyle(fontFamily: 'Trueno', fontSize: 14),
      onTap: _onItemTappedForTabBar,
      tabs: <Widget>[
        new Tab(
          text: "ACTIVO",
        ),
        new Tab(
          text: "PENDIENTE",
        ),
        new Tab(
          text: "INACTIVO",
        ),
      ],
    );

    return new DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: new Scaffold(
        appBar: AppBar(
            bottom: tabBar,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light),
            backgroundColor: Colores().colorAzul,
            title: Text("GESTIÓN DE USUARIOS",
                style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: BuscardorUsuario(
                            listaUsuarios, listaUsuarios, isUsuarioAdmin));
                  },
                  icon: Icon(Icons.search)),
            ]),
        body: TabBarView(
          children: [listActivos(), listPendientes(), listInactivos()],
        ),
      ),
    );
  }

  Widget listPendientes() {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: usuariosPendientes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset('recursos/logo-carga.gif'),
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
                          subtitle: Text('Correo : ' +
                              pendienteUsuarios[index].correo +
                              '\nCelular: ' +
                              pendienteUsuarios[index].telefono +
                              '\nDepartamento: ' +
                              pendienteUsuarios[index].departamento +
                              '\nEspecialidad: ' +
                              pendienteUsuarios[index].especialidad),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisualizarUsuario(
                                          usuario: pendienteUsuarios[index],
                                          nombre: pendienteUsuarios[index]
                                              .nombreCompleto,
                                          correo:
                                              pendienteUsuarios[index].correo,
                                          departamento: pendienteUsuarios[index]
                                              .departamento,
                                          esAdministrador:
                                              pendienteUsuarios[index]
                                                  .esAdministrador,
                                          especialidad: pendienteUsuarios[index]
                                              .especialidad,
                                          statusUsuario:
                                              pendienteUsuarios[index]
                                                  .statusUsuario,
                                          telefono:
                                              pendienteUsuarios[index].telefono,
                                        )));
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
                child: Image.asset('recursos/logo-carga.gif'),
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
                          subtitle: Text('Correo : ' +
                              activoUsuarios[index].correo +
                              '\nCelular: ' +
                              activoUsuarios[index].telefono +
                              '\nDepartamento: ' +
                              activoUsuarios[index].departamento +
                              '\nEspecialidad: ' +
                              activoUsuarios[index].especialidad),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisualizarUsuario(
                                          usuario: activoUsuarios[index],
                                          nombre: activoUsuarios[index]
                                              .nombreCompleto,
                                          correo: activoUsuarios[index].correo,
                                          departamento: activoUsuarios[index]
                                              .departamento,
                                          esAdministrador: activoUsuarios[index]
                                              .esAdministrador,
                                          especialidad: activoUsuarios[index]
                                              .especialidad,
                                          statusUsuario: activoUsuarios[index]
                                              .statusUsuario,
                                          telefono:
                                              activoUsuarios[index].telefono,
                                        )));
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
                child: Image.asset('recursos/logo-carga.gif'),
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
                        subtitle: Text('Correo : ' +
                            inactivoUsuarios[index].correo +
                            '\nCelular: ' +
                            inactivoUsuarios[index].telefono +
                            '\nDepartamento: ' +
                            inactivoUsuarios[index].departamento +
                            '\nEspecialidad: ' +
                            inactivoUsuarios[index].especialidad),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisualizarUsuario(
                                        usuario: inactivoUsuarios[index],
                                        nombre: inactivoUsuarios[index]
                                            .nombreCompleto,
                                        correo: inactivoUsuarios[index].correo,
                                        departamento: inactivoUsuarios[index]
                                            .departamento,
                                        esAdministrador: inactivoUsuarios[index]
                                            .esAdministrador,
                                        especialidad: inactivoUsuarios[index]
                                            .especialidad,
                                        statusUsuario: inactivoUsuarios[index]
                                            .statusUsuario,
                                        telefono:
                                            inactivoUsuarios[index].telefono,
                                      )));
                        },
                      ),
                    );
                  });
            }
          }),
    ));
  }

  Widget listUsuarios() {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
          future: todosUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('recursos/logo-carga.gif'),
              );
            } else {
              return ListView.builder(
                  itemCount: listaUsuarios.length,
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
                        title: Text(listaUsuarios[index].nombreCompleto),
                        subtitle: Text('Correo : ' +
                            listaUsuarios[index].correo +
                            '\nCelular: ' +
                            listaUsuarios[index].telefono +
                            '\nDepartamento: ' +
                            listaUsuarios[index].departamento +
                            '\nEspecialidad: ' +
                            listaUsuarios[index].especialidad),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisualizarUsuario(
                                        usuario: listaUsuarios[index],
                                        nombre:
                                            listaUsuarios[index].nombreCompleto,
                                        correo: listaUsuarios[index].correo,
                                        departamento:
                                            listaUsuarios[index].departamento,
                                        esAdministrador: listaUsuarios[index]
                                            .esAdministrador,
                                        especialidad:
                                            listaUsuarios[index].especialidad,
                                        statusUsuario:
                                            listaUsuarios[index].statusUsuario,
                                        telefono: listaUsuarios[index].telefono,
                                      )));
                        },
                      ),
                    );
                  });
            }
          }),
    ));
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

  Future<void> todosUsuarios() async {
    listaUsuarios = await ControladorUsuario().obtenerUsuarios();
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await ControladorUsuario()
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }
}
