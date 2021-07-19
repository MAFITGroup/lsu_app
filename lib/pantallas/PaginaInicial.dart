import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/ManejadorUsuario.dart';
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
  String _usuarioUID = FirebaseAuth.instance.currentUser.uid;
  ManejadorUsuario _manejadorUsuario = new ManejadorUsuario();

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
                onTap: _navegarAGlosario),
            Botonera(
                titulo: 'Biblioteca',
                icono: Icons.local_library_outlined,
                onTap: _navegarABiblioteca),
            Botonera(
                titulo: 'Noticias',
                icono: Icons.chat_outlined,
                onTap: _navegarANoticias),
             Botonera(
                  titulo: 'Categorias',
                  icono: Icons.category_outlined,
                  onTap: _navegarACategorias),
            Botonera(
                titulo: 'Perfil',
                icono: Icons.person_outline,
                onTap: _navegarAPerfil),
            Botonera(
                titulo: 'Cerrar Sesion',
                icono: Icons.logout,
                onTap: _cerrarSesion),
          ],
        ),
      ),
    ));
  }

  void _cerrarSesion() {
    AuthService().signOut();
  }

  void _navegarAGlosario() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Glosario(),
        ));
  }

  void _navegarABiblioteca() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Biblioteca(),
        ));
  }

  void _navegarANoticias() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Noticias(),
        ));
  }

  void _navegarACategorias() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Categorias(),
        ));
  }

  void _navegarAPerfil() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Perfil(),
        ));
  }
}
