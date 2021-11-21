import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Contenido.dart';
import 'package:lsu_app/pantallas/Biblioteca/VisualizarContenido.dart';

class BuscadorContenido extends SearchDelegate {
  final List<Contenido> contenido;
  final List<Contenido> contenidoSugerido;
  final bool isUsuarioAdmin;

  BuscadorContenido(this.contenido, this.contenidoSugerido, this.isUsuarioAdmin);

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
    final List<Contenido> todosContenido = contenido
        .where((element) =>
        element.titulo.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: todosContenido.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                title: Text(todosContenido[index].titulo),
                subtitle: Text(todosContenido[index].categoria),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisualizarContenido(
                            contenido: todosContenido[index],
                            isUsuarioAdmin: isUsuarioAdmin,
                          )));
                },
              ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Contenido> contenidoSugeridos = contenido
        .where((element) =>
        element.titulo.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: contenidoSugeridos.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                title: Text(contenidoSugeridos[index].titulo),
                subtitle: Text(contenidoSugeridos[index].categoria),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisualizarContenido(
                            contenido: contenidoSugeridos[index],
                            isUsuarioAdmin: isUsuarioAdmin,
                          )));
                },
              ));
        });
  }
}
