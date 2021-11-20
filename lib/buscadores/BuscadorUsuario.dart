import 'package:flutter/material.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/pantallas/Gestion%20de%20Usuario/VisualizarUsuario.dart';

class BuscardorUsuario extends SearchDelegate{

  final List<Usuario> usuario;
  final List<Usuario> usuarioSugerido;
  final bool isUsuarioAdmin;

  BuscardorUsuario(this.usuario, this.usuarioSugerido, this.isUsuarioAdmin);


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
    final List<Usuario> todosUsuarios = usuario
        .where((element) =>
        element.nombreCompleto.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
        itemCount: todosUsuarios.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text('Nombre: ' + todosUsuarios[index].nombreCompleto),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisualizarUsuario(
                        usuario: todosUsuarios[index],
                        nombre: todosUsuarios[index].nombreCompleto,
                        correo: todosUsuarios[index].correo,
                        departamento: todosUsuarios[index].departamento,
                        esAdministrador: todosUsuarios[index].esAdministrador,
                        especialidad: todosUsuarios[index].especialidad,
                        statusUsuario: todosUsuarios[index].statusUsuario,
                        telefono: todosUsuarios[index].telefono,

                      )
                  )
                );
              },
            ),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final List<Usuario> usuarioSugerido = usuario
        .where((element) =>
        element.nombreCompleto.toLowerCase().contains(query.toLowerCase())
        ).toList();

    return ListView.builder(
      itemCount: usuarioSugerido.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            title: Text('Nombre: ' + usuarioSugerido[index].nombreCompleto),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarUsuario(
                      usuario: usuarioSugerido[index],
                      nombre: usuarioSugerido[index].nombreCompleto,
                      correo: usuarioSugerido[index].correo,
                      departamento: usuarioSugerido[index].departamento,
                      esAdministrador: usuarioSugerido[index].esAdministrador,
                      especialidad: usuarioSugerido[index].especialidad,
                      statusUsuario: usuarioSugerido[index].statusUsuario,
                      telefono: usuarioSugerido[index].telefono,
                    )
                  )
              );
            },
          ),
        );
      },
    );
  }
}