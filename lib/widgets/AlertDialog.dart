import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';

class AlertDialog_resetPass extends StatelessWidget {

  final Widget child;

  const AlertDialog_resetPass ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      title: Text('Solicitud de nueva contraseña'),
      content: Text('Link enviado a su casilla de correo'),
      actions: [
        TextButton(
          child: Text('Ok',
              style: TextStyle(
                  color: Colores().colorAzul,
                  fontFamily: 'Trueno',
                  fontSize: 11.0,
                  decoration: TextDecoration.underline)),
          onPressed: Navegacion(context).navegarALoginDest,
        )
      ],
    );
  }
}


class AlertDialog_usrInactivo extends StatelessWidget {

  final Widget child;

  const AlertDialog_usrInactivo ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: Text('Usuario inactivo'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                  child: Text(
                      'Por favor, entre en contacto con el Administrador'))),
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
  }

}

class AlertDialog_usrPendiente extends StatelessWidget {

  final Widget child;

  const AlertDialog_usrPendiente ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: Text('Usuario pendiente'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                  child: Text(
                      'Usuario pendiente de aprobación. Entre en contacto con el Administrador'))),
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
  }

}class AlertDialog_usrNoRegistrado extends StatelessWidget {

  final Widget child;

  const AlertDialog_usrNoRegistrado ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: Text('Usuario no registrado'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                  child: Text(
                      'El usuario informado no se encuentra registrado'))),
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
              ]))
        ]));
  }

}

class AlertDialog_resgistro extends StatelessWidget {

  final Widget child;

  const AlertDialog_resgistro ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registro realizado'),
      content:
      Text('Pendiente de aprobacion del administrador'),
      actions: [
        TextButton(
          child: Text('Ok',
              style: TextStyle(
                  color: Colores().colorAzul,
                  fontFamily: 'Trueno',
                  fontSize: 11.0,
                  decoration: TextDecoration.underline)),
          onPressed: Navegacion(context).navegarALogin,
        ),
      ],
    );
  }

}class AlertDialog_usrRegistrado extends StatelessWidget {

  final Widget child;

  const AlertDialog_usrRegistrado ({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Usuario registrado'),
      content:
      Text('El usuario ya se encuentra registrado'),
      actions: [
        TextButton(
          child: Text('Ok',
              style: TextStyle(
                  color: Colores().colorAzul,
                  fontFamily: 'Trueno',
                  fontSize: 11.0,
                  decoration: TextDecoration.underline)),
          onPressed: Navegacion(context).navegarALogin,
        ),

      ],
    );
  }

}