import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Botonera extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final VoidCallback onTap;

  const Botonera({
    Key key,
    this.titulo,
    this.icono,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                this.icono,
                size: 60.0,
              ),
              Text(
                titulo,
                style: TextStyle(fontSize: 14,fontFamily: 'Trueno'),
              )
            ],
          ),
        ),
      ),
    );
  }
}