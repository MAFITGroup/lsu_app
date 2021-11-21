import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/buscadores/BuscadorContenido.dart';
import 'package:lsu_app/controladores/ControladorContenido.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Contenido.dart';
import 'package:lsu_app/pantallas/Biblioteca/VisualizarContenido.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Biblioteca extends StatefulWidget {
  @override
  _BibliotecaState createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  List<Contenido> listaContenido = [];
  bool isUsuarioAdmin;
  bool isSearching = false;

  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: Text("CONTENIDO",
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
                listaWidget: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: BuscadorContenido(listaContenido,
                                listaContenido, isUsuarioAdmin));
                      },
                      icon: Icon(Icons.search)),
                ],
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarContenido(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('recursos/logo-carga.gif'),
                        );
                      } else if (listaContenido.length <= 0) {
                        return Center(
                          child: Image.asset('recursos/VuelvePronto.png'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: listaContenido.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VisualizarContenido(
                                                contenido:
                                                    listaContenido[index],
                                                isUsuarioAdmin: isUsuarioAdmin,
                                              )));
                                },
                                title: Text(
                                    "TÍTULO: " + listaContenido[index].titulo),
                                subtitle: Text("AUTOR: " +
                                    listaContenido[index].autor +
                                    '\nCATEGORÍA: ' +
                                    listaContenido[index].categoria),
                              ));
                            });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          /*
          Si es usuario administrador muestro el boton
           */
          floatingActionButton: isUsuarioAdmin == true
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colores().colorAzul,
                  onPressed: Navegacion(context).navegarAltaContenido,
                )
              : null,
        ),
      ),
    );
  }

  Future<void> listarContenido() async {
    listaContenido = await ControladorContenido().obtenerTodosContenido();
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
