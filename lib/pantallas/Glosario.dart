import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/widgets/BarraDeBusqueda.dart';

import 'AltaSenia.dart';

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
              BarraDeBusqueda(
                titulo: 'Busqueda de Señas',
                onPressed: () {}, // TODO Implementar busqueda de señas
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AltaSenia(),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
