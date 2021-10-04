import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/pantallas/InicioPage.dart';
import 'package:lsu_app/pantallas/PaginaInicial.dart';

import 'ErrorHandler.dart';

class AuthService extends ChangeNotifier{
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
            return InicioPage();
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
        .then((val) {
          Navegacion(context).navegarAPaginaInicial();
    })
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
      bool esAdministrador,
      String statusUsuario) {
    return firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String userID = firebaseAuth.currentUser.uid;
      //creo mi nuevo usuario

      manej.crearUsuario(userID, email, nombreCompleto, telefono, localidad,
          especialidad, esAdministrador, statusUsuario);
    });
  }

  //Resetear Password
  resetPasswordLink(String email) {

    Future<bool> q  =  manej.existeUsuario(email);

    firebaseAuth.sendPasswordResetEmail(email: email);
  }



}
