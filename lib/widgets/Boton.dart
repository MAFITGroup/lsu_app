import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class Boton extends StatefulWidget {
  final String ?titulo;
  final VoidCallback ?onTap;

  const Boton({Key ?key, this.titulo, this.onTap}) : super(key: key);

  @override
  _BotonState createState() => _BotonState();
}

class _BotonState extends State<Boton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onTap,
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
                    child: Text(widget.titulo!,
                        style: TextStyle(
                          color: Colores().colorBlanco,
                          fontFamily: 'Trueno',
                        ))))),
      ),
    );
  }
}
