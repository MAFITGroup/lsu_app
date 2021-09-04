import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Categorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              BarraDeNavegacion(
                titulo: 'BUSQUEDA DE CATEGORIAS',
                onPressedBtnUno: () {},
                iconoBtnUno: Icon(Icons.search),// TODO Implementar busqueda de categorias
              ),
            ],
          ),
        ),
      ),
    );
  }
}


