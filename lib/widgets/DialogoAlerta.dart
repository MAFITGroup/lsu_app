import 'package:flutter/material.dart';

class DialogoAlerta extends StatelessWidget {
  final String tituloMensaje;
  final String mensaje;
  final List<Widget> acciones;

  const DialogoAlerta(
      {Key key, this.tituloMensaje, this.mensaje, this.acciones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(tituloMensaje),
      content: mensaje != null ? Text(mensaje) : null,
      actions: acciones,
    );
  }
}
