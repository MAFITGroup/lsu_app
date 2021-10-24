import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/pantallas/Login/Principal.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';

import 'ErrorHandler.dart';

class AuthService extends ChangeNotifier {
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
            return Principal();
          }
        });
  }

  //Cerrar sesion
  signOut() {
    firebaseAuth.signOut();


  }

  //Iniciar Sesion
  signIn(String email, String password, context) async {
    final estadoUsuario = await manej
        .obtenerEstadoUsuario(email)
        .then((value) => value.toString());

    // Accion segund el tipo de usuario que se esta intentado logueando
    switch (estadoUsuario) {
      case 'PENDIENTE':
        {
          return showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog_usrPendiente();
              });
        }
        break;

      case 'ACTIVO':
        {
          firebaseAuth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((val) {
            Navegacion(context).navegarAPaginaInicial();
          }).catchError((e) {
            String erro = e.toString();
            ErrorHandler().errorDialog(e, context);

            if (erro.contains('too-many-requests')) {
              ErrorHandler().errorDialogTooManyRequest(e, context);
            }
            if (erro.contains('wrong-password')) {
              ErrorHandler().errorDialogWrongPassword(e, context);
            }
          });
        }
        break;

      case 'INACTIVO':
        {
          return showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog_usrInactivo();
              });
        }
        break;

      default:
        {
          return showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog_usrNoRegistrado();
              });
        }
        break;
    }
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
      String statusUsuario,
      context) {
    return firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String userID = firebaseAuth.currentUser.uid;
      //creo mi nuevo usuario

      manej.crearUsuario(userID, email, nombreCompleto, telefono, localidad,
          especialidad, esAdministrador, statusUsuario);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog_resgistro();
          });
    }).catchError((e) {
      ErrorHandler().errorDialog3(context, e);
    });
  }

  //Resetear Password
  resetPasswordLink(String email, context) {
    firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogoAlerta(
                      tituloMensaje: "Solicitud de nueva contraseña",
                      mensaje: "Link enviado a su casilla de correo",
                      onPressed: Navegacion(context).navegarALoginDest,
                    );
                  })
            })
        .catchError((e) {
      ErrorHandler().errorDialog2(context, e);
    });
  }
}
