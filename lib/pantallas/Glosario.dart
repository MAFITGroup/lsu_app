import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Glosario extends StatelessWidget {

  String user = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: 'BUSQUEDA DE SEÑAS',
                onPressedBtnUno: () {},// TODO Implementar busqueda de señas
                iconoBtnUno:
                    Icon(Icons.search),
              ),
            ],
          ),
          //TODO si el usuario no es administrador, no deberia ver el boton.
          floatingActionButton: ControladorUsuario().isUsuarioAdministrador(user) == true ? FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colores().colorAzul,
            onPressed: Navegacion(context).navegarAltaSenia,
          ) : null,
        ),
      ),
    );
  }
}
