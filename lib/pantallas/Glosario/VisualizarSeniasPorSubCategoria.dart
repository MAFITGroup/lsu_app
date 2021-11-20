import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

import 'VisualizarSenia.dart';

class VisualizarSeniasPorSubCategoria extends StatefulWidget {
  final String nombreSubCategoria;

  const VisualizarSeniasPorSubCategoria({Key key, this.nombreSubCategoria})
      : super(key: key);

  @override
  _VisualizarSeniasPorSubCategoriaState createState() =>
      _VisualizarSeniasPorSubCategoriaState();
}

class _VisualizarSeniasPorSubCategoriaState
    extends State<VisualizarSeniasPorSubCategoria> {
  bool isUsuarioAdmin;
  List<Senia> listaSeniaPorSubCategoria = [];
  ControladorSenia _controladorSenia = new ControladorSenia();

  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    String nombreSubCategoria = widget.nombreSubCategoria;
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: Text(
                    "SEÑAS " + "- SUBCATEGORÍA: " + widget.nombreSubCategoria,
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarSeniasPorSubCategorias(nombreSubCategoria),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('recursos/logo-carga.gif'),
                        );
                      } else if (listaSeniaPorSubCategoria.length <= 0) {
                        return Center(
                          child: Image.asset('recursos/VuelvePronto.png'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: listaSeniaPorSubCategoria.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  incrementarVisualizacionSenia(
                                      listaSeniaPorSubCategoria[index].nombre);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VisualizarSenia(
                                                senia:
                                                    listaSeniaPorSubCategoria[
                                                        index],
                                                isUsuarioAdmin: isUsuarioAdmin,
                                              )));
                                },
                                title: Text(
                                    listaSeniaPorSubCategoria[index].nombre,
                                    style: TextStyle(
                                        fontFamily: 'Trueno', fontSize: 14)),
                              ));
                            });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Senia>> listarSeniasPorSubCategorias(
      String nombreSubCategoria) async {
    listaSeniaPorSubCategoria = await _controladorSenia
        .obtenerSeniasPorSubCategoria(nombreSubCategoria);
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

  void incrementarVisualizacionSenia(String nombreSenia) async {
    await _controladorSenia.incrementarVisualizacionSenia(nombreSenia);
  }
}
