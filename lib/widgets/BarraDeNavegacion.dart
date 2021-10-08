import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class BarraDeNavegacion extends StatelessWidget {
  final String titulo;
  final List<Widget> listaWidget;

  const BarraDeNavegacion({
    Key key,
    this.titulo,
    this.listaWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title: Text(titulo,
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          actions: listaWidget),
    );
  }
}
