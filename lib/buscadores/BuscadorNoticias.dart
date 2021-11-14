
import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Noticia.dart';
import 'package:lsu_app/pantallas/Noticias/VisualizarNoticia.dart';


class BuscadorNoticias extends SearchDelegate {
  final List<Noticia> noticia;
  final List<Noticia> noticiaSugerida;
  final bool isUsuarioAdmin;

  BuscadorNoticias(this.noticia, this.noticiaSugerida, this.isUsuarioAdmin);

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
  Widget buildResults(BuildContext context){
    final List<Noticia> todasNoticias = noticia
        .where((element) =>
          element.titulo.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: todasNoticias.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text('Titulo: ' + todasNoticias[index].titulo),
              subtitle: Text(
                  'Descripción: ' + todasNoticias[index].descripcion +
                      '\nFecha de Publicación: ' + todasNoticias[index].fechaSubida
              ),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarNoticia(
                          noticia: todasNoticias[index],
                          tipo: todasNoticias[index].tipo,
                          titulo: todasNoticias[index].titulo,
                          descripcion: todasNoticias[index].descripcion,
                          link: todasNoticias[index].link,
                          isUsuarioAdmin: isUsuarioAdmin,
                        )));
              }
            ),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final List<Noticia> noticiaSugerida = noticia
        .where((element) =>
        element.titulo.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: noticiaSugerida.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
              title: Text('Titulo: ' + noticiaSugerida[index].titulo),
              subtitle: Text(
                  'Descripción: ' + noticiaSugerida[index].descripcion +
                      '\nFecha de Publicación: ' + noticiaSugerida[index].fechaSubida
              ),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarNoticia(
                          noticia: noticiaSugerida[index],
                          tipo: noticiaSugerida[index].tipo,
                          titulo: noticiaSugerida[index].titulo,
                          descripcion: noticiaSugerida[index].descripcion,
                          link: noticiaSugerida[index].link,
                          isUsuarioAdmin: isUsuarioAdmin,
                        )));
              }
          ),

        );
      },
    );
  }


}
 // Widget de buscador
