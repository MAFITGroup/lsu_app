import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';

class ErrorHandler {
  //Error Dialogs
  Future<bool> errorDialog(e, BuildContext context) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Login'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Center(
                        child: Text('Usuario y/o contraseña incorrectas.'
                            //e.message.toString()
                            ))),
                Container(
                    height: 50.0,
                    child: Row(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok',
                              style: TextStyle(
                                  color: Colores().colorAzul,
                                  fontFamily: 'Trueno',
                                  fontSize: 11.0,
                                  decoration: TextDecoration.underline)))
                    ]))
              ]));
        });
  }

  Future<bool> errorDialog2(BuildContext context, e) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Email no existe'),
              content: Text('El correo ingresado no se encuentra registrado'),
              actions: [
                TextButton(
                  child: Text('Ok',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navegacion(context).navegarAResetPassword;
                  },
                )
              ]);
        });
  }

  Future<bool> errorDialog3(BuildContext context, e) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Usuario registrado'),
              content: Text('El correo informado se encuentra registrado'),
              actions: [
                TextButton(
                    child: Text('Ok',
                        style: TextStyle(
                            color: Colores().colorAzul,
                            fontFamily: 'Trueno',
                            fontSize: 11.0,
                            decoration: TextDecoration.underline)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    onPressed: () {
                      Navegacion(context).navegarAResetPassword();
                    },
                    child: Text('Recuperar contraseña',
                        style: TextStyle(
                            color: Colores().colorAzul,
                            fontFamily: 'Trueno',
                            fontSize: 11.0,
                            decoration: TextDecoration.underline)))
              ]);
        });
  }

  Future<bool> errorDialogTooManyRequest(BuildContext context, e) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Demasiados intentos fallidos'),
              content: Text('Para acceder, debes restaurar tu contraseña'),
              actions: [
                TextButton(
                  child: Text('Resetear contraseña',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navegacion(context).navegarAResetPassword;
                  },
                )
              ]);
        });
  }

  Future<bool> errorDialogWrongPassword(BuildContext context, e) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Datos incorrectos'),
              content: Text('Usuario o contraseña incorrectas'),
              actions: [
                TextButton(
                  child: Text('ok',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  Future<bool> errorDialogEditarPerfil(BuildContext context, e) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Editar perfil'),
              content: Text(
                  'Ocurrió un error durante la modificación de datos, intente nuevamente'),
              actions: [
                TextButton(
                  child: Text('ok',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }
}
