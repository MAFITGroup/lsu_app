import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/pantallas/Glosario/VisualizarSenia.dart';

class BuscadorSenias extends SearchDelegate {
  final List<Senia> senias;
  final List<Senia> seniasSugeridas;
  final bool isUsuarioAdmin;

  BuscadorSenias(this.senias, this.seniasSugeridas, this.isUsuarioAdmin);

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
    final List<Senia> todasSenias = senias
        .where((element) =>
            element.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: todasSenias.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(todasSenias[index].nombre),
            subtitle: Text("CATEGORIA " + todasSenias[index].categoria),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarSenia(
                            senia: todasSenias[index],
                            isUsuarioAdmin: isUsuarioAdmin,
                          )));
            },
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Senia> seniasSugeridas = senias
        .where((element) =>
            element.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: seniasSugeridas.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(seniasSugeridas[index].nombre),
            subtitle: Text("CATEGORIA: " + seniasSugeridas[index].categoria),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarSenia(
                            senia: seniasSugeridas[index],
                            isUsuarioAdmin: isUsuarioAdmin,
                          )));
            },
          ));
        });
  }
}
