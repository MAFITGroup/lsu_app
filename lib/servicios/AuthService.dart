import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/pantallas/PaginInicial.dart';
import 'package:lsu_app/pantallas/loginPage.dart';
import 'package:lsu_app/servicios/database.dart';

import 'ErrorHandler.dart';

class AuthService {
  //Determino si el usuario esta autenticado.
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return PaginaInicial();
          } else {
            return LoginPage();
          }
        });
  }

  //Cerrar sesion
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Iniciar Sesion
  signIn(String email, String password, context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) {
    }).catchError((e) {
      ErrorHandler().errorDialog(context, e);
    });
  }

  //Iniciar sesion con usuario nuevo
  signUp(String email, String password, String nombreCompleto, String telefono,
      String localidad, String especialidad, bool esAdministrador) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      //creo mi nuevo usuario
      Usuario usuario = new Usuario(value.user.uid, email, nombreCompleto,
          telefono, localidad, especialidad, esAdministrador);
      Database database = new Database();
      database.crearUsuario(usuario);
    });
  }

  //Resetear Password
  resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
