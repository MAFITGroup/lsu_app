import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarraDeBusqueda extends StatelessWidget {
  final VoidCallback onPressed;
  final String titulo;

  const BarraDeBusqueda({
    Key key,
    this.onPressed,
    this.titulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo, style:TextStyle(fontFamily: 'Trueno', fontSize: 16)),
      actions: [
        IconButton(onPressed: onPressed, icon: Icon(Icons.search))
      ],
    );
  }
}