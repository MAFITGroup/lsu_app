import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldNumerico extends StatefulWidget {
  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;
  final Icon icon;

  final TextEditingController controlador;
  final bool habilitado;

  TextFieldNumerico(
      {Key key,
      this.nombre,
      this.valor,
      this.validacion,
      this.icon,
      this.controlador,
      this.habilitado})
      : super(key: key);

  @override
  _TextFieldNumericoState createState() => _TextFieldNumericoState();
}

class _TextFieldNumericoState extends State<TextFieldNumerico> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
          enabled: widget.habilitado,
          controller: widget.controlador,
          decoration: InputDecoration(
              prefixIcon: widget.icon == null ? Icon(null) : widget.icon,
              labelText: widget.nombre,
              labelStyle: TextStyle(
                  fontFamily: 'Trueno',
                  fontSize: 12.0,
                  color: Colores().colorSombraBotones),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores().colorSombraBotones),
              )),
          // SOLO NUMEROS
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: widget.valor,
          validator: widget.validacion),
    );
  }
}
