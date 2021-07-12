import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/servicios/AuthService.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        // Menu de dos columnas
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Botonera(titulo: 'Glosario', icono: Icons.search_rounded),
            Botonera(titulo: 'Biblioteca', icono: Icons.local_library_outlined),
            Botonera(titulo: 'Noticias', icono: Icons.chat_outlined),
            Botonera(titulo: 'Categorias', icono: Icons.category_outlined),
            Botonera(titulo: 'Perfil', icono: Icons.person_outline),
            ElevatedButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: Center(child: Text('LOG OUT')))
          ],
        ),
      ),
    ));
  }
}

class Botonera extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const Botonera({
    Key key,
    this.titulo,
    this.icono,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                this.icono,
                size: 70.0,
              ),
              Text(
                titulo,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
      ),
    );
  }
}
