import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldTexto extends StatelessWidget {
  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;

  TextFieldTexto({
    Key key,
    this.nombre,
    this.valor,
    this.validacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
          decoration: InputDecoration(
              labelText: nombre,
              labelStyle: TextStyle(
                  fontFamily: 'Trueno',
                  fontSize: 12.0,
                  color: Colors.grey.withOpacity(0.5)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores().colorAzul),
              )),
          onChanged: valor,
          validator: validacion),
    );
  }
}
