import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<Usuario> pendienteUsuarios = [];
  List<Usuario> activoUsuarios = [];
  List<Usuario> inactivoUsuarios = [];

  Usuario usuario;

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
    final tabBar = new TabBar(labelColor: Colores().colorBlanco,
      indicatorColor: Colores().colorBlanco,
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

    return new DefaultTabController(length: 3, child: new Scaffold(
      appBar: AppBar(
          bottom:tabBar ,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title: Text("GESTION DE USUARIOS",style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
/*          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.search)),
          ]
*/      ),
      body: TabBarView(
        children: [
          listActivos(),
          listPendientes(),
          listInactivos()
        ],
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
