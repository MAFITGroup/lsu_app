import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Glosario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: 'BUSQUEDA DE SEÑAS',
                onPressedBtnUno: () {},
                iconoBtnUno:
                    Icon(Icons.search), // TODO Implementar busqueda de señas
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colores().colorAzul,
            onPressed: Navegacion(context).navegarAltaSenia,
          ),
        ),
      ),
    );
  }
}
