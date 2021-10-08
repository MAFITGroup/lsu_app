import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  bool isUsuarioAdmin = false;

  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        BarraDeNavegacion(
          titulo: 'MENU',
          iconoBtnUno: Icon(Icons.person_off),
          onPressedBtnUno: () {}, //TODO agregar opcion cerrar sesion y perfiles
        ),
        Center(
          child: Container(
              height: 700,
              width: 600,
              // Menu de dos columnas
              child: !isUsuarioAdmin
                  ? Column(
                      children: [
                        SizedBox(height: 50),
                        Boton(
                            onTap: Navegacion(context).navegarAGlosario,
                            titulo: 'GLOSARIO'),
                        Boton(
                            onTap: Navegacion(context).navegarABiblioteca,
                            titulo: 'BIBLIOTECA'),
                        Boton(
                            onTap: Navegacion(context).navegarANoticias,
                            titulo: 'NOTICIAS'),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: 50),
                        Boton(
                            onTap: Navegacion(context).navegarAGlosario,
                            titulo: 'GLOSARIO'),
                        Boton(
                            onTap: Navegacion(context).navegarABiblioteca,
                            titulo: 'BIBLIOTECA'),
                        Boton(
                            onTap: Navegacion(context).navegarANoticias,
                            titulo: 'NOTICIAS'),
                        Boton(
                            onTap: Navegacion(context).navegarACategorias,
                            titulo: 'CATEGORIAS'),
                        Boton(
                            onTap: Navegacion(context)
                                .navegarAPaginaGestionUsuario,
                            titulo: 'GESTIÓN DE USUARIOS'),
                      ],
                    )),
        ),
      ]),
    ));
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await ControladorUsuario()
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }
}
