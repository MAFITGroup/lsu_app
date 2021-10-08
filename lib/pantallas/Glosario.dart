import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/pantallas/VisualizarSenia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Glosario extends StatefulWidget {
  @override
  _GlosarioState createState() => _GlosarioState();
}

class _GlosarioState extends State<Glosario> {
  List<Senia> listaSenias = [];
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
                titulo: "BUSQUEDA DE SEÑAS",
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarSenias(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Cargando...");
                      } else {
                        return ListView.builder(
                            itemCount: listaSenias.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VisualizarSenia(senia: listaSenias[index])));
                                },
                                title: Text(listaSenias[index].nombre),
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
                  onPressed: Navegacion(context).navegarAltaSenia,
                )
              : null,
        ),
      ),
    );
  }

  Future<void> listarSenias() async {
    listaSenias = await ControladorSenia().obtenerTodasSenias();
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
