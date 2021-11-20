import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';

class DialogoAlerta extends StatelessWidget {
  final String tituloMensaje;
  final String mensaje;
  final Function onPressed;

  const DialogoAlerta(
      {Key key, this.tituloMensaje, this.mensaje, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(tituloMensaje),
      content: Text(mensaje),
      actions: [
        TextButton(
          child: Text('Ok',
              style: TextStyle(
                  color: Colores().colorAzul,
                  fontFamily: 'Trueno',
                  fontSize: 11.0,
                  decoration: TextDecoration.underline)),
          onPressed: onPressed,
        )
      ],
    );
  }
}
/*
class AlertDialog_usrRegistrado extends StatelessWidget {
  final Widget child;

  const AlertDialog_usrRegistrado({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Usuario registrado'),
      content: Text('El usuario ya se encuentra registrado'),
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

class AlertDialog_cargaArchivo extends StatelessWidget {
  final Widget child;

  const AlertDialog_cargaArchivo({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Carga de Archivo'),
      content: Text('Su archivo ha sido seleccionado correctamente'),
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
            })
      ],
    );
  }
}

class AlertDialog_altaConfirmacion extends StatelessWidget {
  final Widget child;

  const AlertDialog_altaConfirmacion({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alta Realizada'),
      content: Text('Se ha realizado el alta de forma satisfactora'),
      actions: [
        TextButton(
          child: Text('Ok',
              style: TextStyle(
                  color: Colores().colorAzul,
                  fontFamily: 'Trueno',
                  fontSize: 11.0,
                  decoration: TextDecoration.underline)),
          onPressed: Navegacion(context).navegarAPaginaInicialDest,
        ),
      ],
    );
  }
}

class AlertDialog_campoVacioCat extends StatelessWidget {
  final Widget child;

  const AlertDialog_campoVacioCat({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Campos obligatorios'),
      content: Text('El nombre de la categoría no puede estar vacía'),
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
      ],
    );
  }
}

class AlertDialog_catExistente extends StatelessWidget {
  final Widget child;

  const AlertDialog_catExistente({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Categoría Existente'),
      content: Text(
          'Por favor, verifique. La categoría que intenta ingresar ya existe'),
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
      ],
    );
  }
}
*/