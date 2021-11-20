import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/pantallas/Login/Principal.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';

import 'ErrorHandler.dart';

class AuthService extends ChangeNotifier {
  ControladorUsuario manej = new ControladorUsuario();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User usuario = FirebaseAuth.instance.currentUser;

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
        .obtenerEstadoUsuario(email, context)
        .then((value) => value.toString());

    // Accion segun el tipo de usuario que se esta intentado logueando
    switch (estadoUsuario) {
      case 'PENDIENTE':
        {
          return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return DialogoAlerta(
                  tituloMensaje: 'Usuario pendiente',
                  mensaje: 'Usuario pendiente de aprobación. Entre en contacto con el Administrador',
                  onPressed: (){
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK',
                            style: TextStyle(
                                color: Colores().colorAzul,
                                fontFamily: 'Trueno',
                                fontSize: 11.0,
                                decoration: TextDecoration.underline)));
                  },
                );
              });
        }
        break;

      case 'ACTIVO':
        {
          firebaseAuth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((val) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PaginaInicial();
                },
              ),
            );
            Navigator.of(context).pop();
          }).catchError((e) {
            String error = e.toString();
            ErrorHandler().errorDialog(e, context);

            if (error.contains('too-many-requests')) {
              ErrorHandler().errorDialogTooManyRequest(e, context);
            }
            if (error.contains('wrong-password')) {
              ErrorHandler().errorDialogWrongPassword(e, context);
            }
          });
        }
        break;

        case 'INACTIVO':
          {
            return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: Text('Usuario inactivo'),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                                child: Text('¿Desea reactiviar su usuario?'))),
                        Container(
                            height: 50.0,
                            child: Row(children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ATRÁS',
                                      style: TextStyle(
                                          color: Colores().colorAzul,
                                          fontFamily: 'Trueno',
                                          fontSize: 11.0,
                                          decoration:
                                              TextDecoration.underline))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navegacion(context)
                                        .navegarAReactivarUsuario();
                                  },
                                  child: Text('REACTIVAR USUARIO',
                                      style: TextStyle(
                                          color: Colores().colorAzul,
                                          fontFamily: 'Trueno',
                                          fontSize: 11.0,
                                          decoration:
                                              TextDecoration.underline)))
                            ]))
                      ]));
                });
          }
          break;

      default:
        {
          return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Usuario no registrado'),
                  content: Text('El usuario informado no se encuentra registrado'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK',
                            style: TextStyle(
                                color: Colores().colorAzul,
                                fontFamily: 'Trueno',
                                fontSize: 11.0,
                                decoration: TextDecoration.underline))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navegacion(context).navegarARegistrarse();
                        },
                        child: Text('Registrarse',
                            style: TextStyle(
                                color: Colores().colorAzul,
                                fontFamily: 'Trueno',
                                fontSize: 11.0,
                                decoration: TextDecoration.underline)))
                  ],
                );
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
      String departamento,
      String especialidad,
      bool esAdministrador,
      String statusUsuario,
      context) {
    return firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      String userID = firebaseAuth.currentUser.uid;
      manej.crearUsuario(userID, email, nombreCompleto, telefono, departamento,
          especialidad, esAdministrador, statusUsuario);

      usuario.sendEmailVerification();



      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogoAlerta(
              tituloMensaje: 'Registro realizado',
              mensaje:
                  'El registro esta pendiente de aprobacion del administrador. '
                  '\nUna vez autorizado, recibirás una notificación en tu correo.',
              onPressed: () {
                TextButton(
                    child: Text('OK',
                        style: TextStyle(
                            color: Colores().colorAzul,
                            fontFamily: 'Trueno',
                            fontSize: 11.0,
                            decoration: TextDecoration.underline)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navegacion(context).navegarAPrincipal();
                    });
              },
            );
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
