import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/pantallas/Categorias/VisualizarCategoria.dart';

class BuscadorCategoria extends SearchDelegate {
  final List<Categoria> categorias;
  final List<Categoria> categoriasSugeridas;
  final bool isUsuarioAdmin;

  BuscadorCategoria(
      this.categorias, this.categoriasSugeridas, this.isUsuarioAdmin);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Categoria> todasCategorias = categorias
        .where((element) =>
            element.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: todasCategorias.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(todasCategorias[index].nombre),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarCategoria(
                            categoria: todasCategorias[index],
                          )));
            },
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Categoria> categoriasSugeridas = categorias
        .where((element) =>
            element.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: categoriasSugeridas.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(categoriasSugeridas[index].nombre),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarCategoria(
                            categoria: categoriasSugeridas[index],
                          )));
            },
          ));
        });
  }
}
