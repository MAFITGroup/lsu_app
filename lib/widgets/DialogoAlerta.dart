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
