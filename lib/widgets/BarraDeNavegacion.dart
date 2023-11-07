import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class BarraDeNavegacion extends StatelessWidget {
  final Widget ?titulo;
  final List<Widget> ?listaWidget;
  final PreferredSizeWidget ?bottom;

  const BarraDeNavegacion({
    Key ?key,
    this.titulo,
    this.listaWidget, this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppBar(
        bottom:bottom ,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title: titulo,
          actions: listaWidget),
    );
  }
}
