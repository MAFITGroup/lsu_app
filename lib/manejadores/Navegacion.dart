import 'package:flutter/material.dart';
import 'package:lsu_app/pantallas/AltaSenia.dart';
import 'package:lsu_app/pantallas/Biblioteca.dart';
import 'package:lsu_app/pantallas/Categorias.dart';
import 'package:lsu_app/pantallas/Glosario.dart';
import 'package:lsu_app/pantallas/Noticias.dart';
import 'package:lsu_app/pantallas/Perfil.dart';
import 'package:lsu_app/servicios/AuthService.dart';

/*
Clase que controla la navegacion entre pantallas del sistema
 */
class Navegacion {
  BuildContext context;

  Navegacion(this.context);

  void _cerrarSesion() {
    AuthService().signOut();
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

  void navegarAltaSenia() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AltaSenia(),
        ));
  }
}
