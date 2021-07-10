import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/pantallas/PaginInicial.dart';
import 'package:lsu_app/pantallas/loginPage.dart';

import 'ErrorHandler.dart';

class AuthService {
  //Determino si el usuario esta autenticado.
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return PaginaInicial();
          } else
            return LoginPage();
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
      print('signed in');
    }).catchError((e) {
      ErrorHandler().errorDialog(context, e);
    });
  }


  //Iniciar sesion con usuario nuevo
  signUp(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  //Resetear Password
  resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}