import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  bool isUsuarioAdmin = false;
  ControladorUsuario controladorUsuario = new ControladorUsuario();

  Usuario usuario = new Usuario();

  @override
  void initState() {
    obtenerUsuarioAdministrador();
    datosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        BarraDeNavegacion(
          titulo: Text("MENU",
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          listaWidget: [
            PopupMenuButton<int>(
              /*
              Agregar en el metodo on Selected
              las acciones
               */
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                        value: 0,
                        child: Text("Cerrar Sesión")),
                    PopupMenuItem(
                        value: 1,
                        child: Text("Perfil")),
                  ],
            ),
          ],
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
                            onTap:
                            Navegacion(context)
                                .navegarAPaginaGestionUsuario,
                            titulo: 'GESTIÓN DE USUARIOS'),
                      ],
                    )),
        ),
      ]),
    ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        AuthService().signOut();
        break;
      case 1:
        Navegacion(context).navegarAPerfil(usuario);
    }
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

  Future<void> datosUsuario() async {
    usuario = await controladorUsuario
        .obtenerUsuarioLogueado(FirebaseAuth.instance.currentUser.uid);
  }
}