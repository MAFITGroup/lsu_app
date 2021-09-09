import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class Boton extends StatelessWidget {

  final String titulo;
  final VoidCallback onTap;

  const Boton({
    Key key,
    this.titulo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            height: 50.0,
            width: 600,
            child: Material(
                borderRadius: BorderRadius.circular(25.0),
                shadowColor: Colores().colorSombraBotones,
                color: Colores().colorAzul,
                elevation: 7.0,
                child: Center(
                    child: Text(titulo,
                        style: TextStyle(
                            color: Colores().colorBlanco,
                            fontFamily: 'Trueno',))))),
      ),

    );
  }
}