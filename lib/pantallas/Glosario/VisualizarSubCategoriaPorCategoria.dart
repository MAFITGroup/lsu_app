import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/modelo/SubCategoria.dart';
import 'package:lsu_app/pantallas/Glosario/VisualizarSeniasPorSubCategoria.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class VisualizarSubCategoriaPorCategoria extends StatefulWidget {
  final String nombreCategoria;

  const VisualizarSubCategoriaPorCategoria({Key key, this.nombreCategoria})
      : super(key: key);

  @override
  _VisualizarSubCategoriaPorCategoriaState createState() =>
      _VisualizarSubCategoriaPorCategoriaState();
}

class _VisualizarSubCategoriaPorCategoriaState
    extends State<VisualizarSubCategoriaPorCategoria> {
  bool isUsuarioAdmin;
  List<SubCategoria> listaSubCategoriaPorCategoria = [];
  ControladorCategoria _controladorCategoria = new ControladorCategoria();

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
                titulo: Text(
                    "SUBCATEGORÍAS " + "- CATEGORÍA: " + widget.nombreCategoria,
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarSubCategoriasXCategorias(nombreCategoria),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('recursos/logo-carga.gif'),
                        );
                      } else if (listaSubCategoriaPorCategoria.length <= 0) {
                        return Center(
                          child: Image.asset('recursos/VuelvePronto.png'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: listaSubCategoriaPorCategoria.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VisualizarSeniasPorSubCategoria(
                                                nombreSubCategoria:
                                                    listaSubCategoriaPorCategoria[
                                                            index]
                                                        .nombre,
                                              )));
                                },
                                title: Text("SUBCATEGORÍA: " +
                                    listaSubCategoriaPorCategoria[index].nombre,
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

  Future<List<SubCategoria>> listarSubCategoriasXCategorias(
      String nombreCategoria) async {
    listaSubCategoriaPorCategoria = await _controladorCategoria
        .listarSubCategoriasPorCategoria(nombreCategoria);
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
