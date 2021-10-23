import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

import 'VisualizarSenia.dart';

class VisualizarSeniaPorCategoria extends StatefulWidget {
  final Categoria categoria;

  const VisualizarSeniaPorCategoria({Key key, this.categoria})
      : super(key: key);

  @override
  _VisualizarSeniaPorCategoriaState createState() =>
      _VisualizarSeniaPorCategoriaState();
}

class _VisualizarSeniaPorCategoriaState
    extends State<VisualizarSeniaPorCategoria> {
  List<Senia> listaSenias = [];
  bool isUsuarioAdmin;

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
                titulo: Text("BUSQUEDA DE SEÑA",
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              ),
              Text("Senias"),
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
                                          builder: (context) => VisualizarSenia(
                                                senia: listaSenias[index],
                                                isUsuarioAdmin: isUsuarioAdmin,
                                              )));
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
