import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/pantallas/Login.dart';
import 'package:lsu_app/pantallas/PaginaInicial.dart';

import 'ErrorHandler.dart';

class AuthService {
  ControladorUsuario manej = new ControladorUsuario();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Determino si el usuario esta autenticado.
  handleAuth() {
    return StreamBuilder(
        stream: firebaseAuth.authStateChanges(),
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
    firebaseAuth.signOut();
  }

  //Iniciar Sesion
  signIn(String email, String password, context) {
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) {})
        .catchError((e) {
      ErrorHandler().errorDialog(context, e);
    });
  }

  //Iniciar sesion con usuario nuevo
  signUp(
      String uid,
      String email,
      String password,
      String nombreCompleto,
      String telefono,
      String localidad,
      String especialidad,
      bool esAdministrador) {
    return firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String userID = firebaseAuth.currentUser.uid;
      //creo mi nuevo usuario

      manej.crearUsuario(userID, email, nombreCompleto, telefono, localidad,
          especialidad, esAdministrador);
    });
  }

  //Resetear Password
  resetPasswordLink(String email) {
    firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
