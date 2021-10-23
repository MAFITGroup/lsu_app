import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
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
  List<Categoria> listaCategoriasFiltradas = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BarraDeNavegacion(
            titulo: !isSearching
                ? Text("BUSQUEDA DE CATEGORIAS",
                style: TextStyle(fontFamily: 'Trueno', fontSize: 14))
                : TextField(
              onChanged: (valor) {
                _filtrarCategorias(valor);
              },
              style: TextStyle(color: Colores().colorBlanco),
              decoration: InputDecoration(
                  hintText: "BUSCA UNA CATEGORIA",
                  hintStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 14,
                      color: Colores().colorBlanco)),
            ),
            listaWidget: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this.isSearching = !isSearching;
                  });
                },
              )
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

  Future<void> listarCategorias() async {
    listaCategorias = listaCategoriasFiltradas =
    await ControladorCategoria().obtenerTodasCategorias();
  }

  void _filtrarCategorias(String valor) {
    setState(() {
      listaCategoriasFiltradas = listaCategorias
          .where((cat) =>
          cat.toString().startsWith(valor))
          .toList();
    });
  }
}
