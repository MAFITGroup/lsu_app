import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BotoneraMenuInicio.dart';

import 'Biblioteca.dart';
import 'Categorias.dart';
import 'Glosario.dart';
import 'Noticias.dart';
import 'Perfil.dart';

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
          mainAxisSpacing: 2,
          children: [
            Botonera(
                titulo: 'Glosario',
                icono: Icons.search_rounded,
                onTap: navegarAGlosario),
            Botonera(
                titulo: 'Biblioteca',
                icono: Icons.local_library_outlined,
                onTap: navegarABiblioteca),
            Botonera(
                titulo: 'Noticias',
                icono: Icons.chat_outlined,
                onTap: navegarANoticias),
            Botonera(
                titulo: 'Categorias',
                icono: Icons.category_outlined,
                onTap: navegarACategorias),
            Botonera(
                titulo: 'Perfil',
                icono: Icons.person_outline,
                onTap: navegarAPerfil),
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

  void navegarAGlosario() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Glosario(),
        ));
  }

  void navegarABiblioteca() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Biblioteca(),
        ));
  }

  void navegarANoticias() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Noticias(),
        ));
  }

  void navegarACategorias() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Categorias(),
        ));
  }

  void navegarAPerfil() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Perfil(),
        ));
  }
}
