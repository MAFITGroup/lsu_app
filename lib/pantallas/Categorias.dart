import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/widgets/BarraDeBusqueda.dart';

class Categorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              BarraDeBusqueda(
                titulo: 'Categorias',
                onPressed: () {}, //TODO Implementar busqueda de categorias
              ),
            ],
          ),
        ),
      ),
    );
  }
}
