import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

import 'VisualizarSenia.dart';

class VisualizarSeniaPorCategoria extends StatefulWidget {
  final String nombreCategoria;

  const VisualizarSeniaPorCategoria({Key key, this.nombreCategoria})
      : super(key: key);

  @override
  _VisualizarSeniaPorCategoriaState createState() =>
      _VisualizarSeniaPorCategoriaState();
}

class _VisualizarSeniaPorCategoriaState
    extends State<VisualizarSeniaPorCategoria> {
  bool isUsuarioAdmin;
  List<Senia> listaSeniaXCategoria = [];
  ControladorSenia _controladorSenia = new ControladorSenia();

  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    String nombreCategoria = widget.nombreCategoria;
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: Text("BUSQUEDA DE SEÑA",
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarSeniasXCategorias(nombreCategoria),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Cargando...");
                      } else {
                        return ListView.builder(
                            itemCount: listaSeniaXCategoria.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VisualizarSenia(
                                                senia:
                                                    listaSeniaXCategoria[index],
                                                isUsuarioAdmin: isUsuarioAdmin,
                                              )));
                                },
                                title: Text(listaSeniaXCategoria[index].nombre),
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

  Future<List<Senia>> listarSeniasXCategorias(String nombreCategoria) async {
    listaSeniaXCategoria =
        await _controladorSenia.obtenerSeniasXCategoria(nombreCategoria);
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
