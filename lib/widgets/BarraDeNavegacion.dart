import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class BarraDeNavegacion extends StatelessWidget {
  final VoidCallback onPressedBtnUno;
  final String titulo;
  final Icon iconoBtnUno;
  final VoidCallback onPressedBtnDos;
  final Icon iconoBtnDos;

  const BarraDeNavegacion({
    Key key,
    this.onPressedBtnUno,
    this.titulo,
    this.iconoBtnUno,
    this.onPressedBtnDos,
    this.iconoBtnDos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light),

        backgroundColor: Colores().colorAzul,
        title:
            Text(titulo, style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
        actions: [
          /*
          El ultimo icono que se agrege se posiciona a la izquierda,
          por lo tanto si se usa el btn dos, queda un espacio inicial
          a la derecha de este

          Usar los botones en orden, si se quiere agregar un btn3
          se debe agregar primero que el btn 2.
           */
          IconButton(
              onPressed: onPressedBtnDos == null ? null : onPressedBtnDos,
              icon: iconoBtnDos == null ? Icon(null) : iconoBtnDos),
          SizedBox(width: 5),
          IconButton(
              onPressed: onPressedBtnUno == null ? null : onPressedBtnUno,
              icon: iconoBtnUno == null ? Icon(null) : iconoBtnUno),
        ],
      ),
    );
  }
}
