import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/buscadores/BuscadorSenias.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

import 'VisualizarSubCategoriaPorCategoria.dart';

class Glosario extends StatefulWidget {
  @override
  _GlosarioState createState() => _GlosarioState();
}

class _GlosarioState extends State<Glosario> {
  List<Categoria> listaCategorias = [];
  List listaCategoriasParaAlta = [];
  List listaSubCategoriasParaAlta = [];
  List<Senia> listaSeniaXCategoria = [];
  List<Senia> listaSenias = [];
  bool isUsuarioAdmin;
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  ControladorCategoria _controladorCategoria = new ControladorCategoria();
  ControladorSenia _controladorSenia = new ControladorSenia();

  @override
  void initState() {
    listarCategoriasParaAlta();
    obtenerUsuarioAdministrador();
    listarSenias();
  }

  /*
  Req. del Cliente
 El glosario se muestra categorizado.

 Se mostraran las categorias existentes,
 dentro se muestran las senias que pertenecen a esa
 categoria
   */
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
                titulo: Text("GLOSARIO",
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
                listaWidget: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: BuscadorSenias(
                                listaSenias, listaSenias, isUsuarioAdmin));
                      },
                      icon: Icon(Icons.search)),
                ],
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarCategorias(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('recursos/logo-carga.gif'),
                        );
                      } else if (listaCategorias.length <= 0) {
                        return Center(
                          child: Image.asset('recursos/VuelvePronto.png'),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: listaCategorias.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VisualizarSubCategoriaPorCategoria(
                                                nombreCategoria:
                                                    listaCategorias[index]
                                                        .nombre,
                                              )));
                                },
                                title: Text("CATEGORÍA: " + listaCategorias[index].nombre),
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
                  onPressed: () {
                    Navegacion(context)
                        .navegarAltaSenia(listaCategoriasParaAlta);
                  })
              : null,
        ),
      ),
    );
  }

  /*
Lista de señas para el buscador.
 */
  Future<void> listarSenias() async {
    listaSenias = await _controladorSenia.obtenerTodasSenias();
  }

  /*
  Se listan las categorias para mostrar el glosario, devuelve Categoria
   */
  Future<void> listarCategorias() async {
    listaCategorias = await _controladorCategoria.obtenerTodasCategorias();
  }

  void listarCategoriasParaAlta() async {
    listaCategoriasParaAlta = await _controladorCategoria.listarCategorias();
  }

  void listarSubCategoriasParaAlta() async {
    listaSubCategoriasParaAlta =
        await _controladorCategoria.listarSubCategorias();
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await _controladorUsuario
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }
}
