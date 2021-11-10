import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/buscadores/BuscadorCategoria.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/pantallas/Categorias/VisualizarCategoria.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  List<Categoria> listaCategorias = [];
  bool isUsuarioAdmin;
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  ControladorCategoria _controladorCategoria = new ControladorCategoria();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BarraDeNavegacion(
            titulo: Text("CATEGORIAS",
                style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
            listaWidget: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: BuscadorCategoria(
                            listaCategorias, listaCategorias, isUsuarioAdmin));
                  },
                  icon: Icon(Icons.search)),
            ],
          ),
          Expanded(
            child: Container(
              height: 600,
              child: FutureBuilder(
                future: listarCategorias(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Cargando...");
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
                                      builder: (context) => VisualizarCategoria(
                                            categoria: listaCategorias[index],
                                          )));
                            },
                            title: Text(listaCategorias[index].nombre),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colores().colorAzul,
        onPressed: Navegacion(context).navegarAAltaCategoria,
      ),
    );
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

  Future<void> listarCategorias() async {
    listaCategorias = await _controladorCategoria.obtenerTodasCategorias();
  }
}
