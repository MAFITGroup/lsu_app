import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldTexto extends StatefulWidget {

  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;
  final Icon icon;
  final TextEditingController textoSeteado;
  final bool botonHabilitado;


  TextFieldTexto({
    Key key,
    this.nombre,
    this.valor,
    this.validacion,
    this.icon,
    this.textoSeteado,
    this.botonHabilitado,
  }) : super(key: key);


  @override
  _TextFieldTextoState createState() => _TextFieldTextoState();

}

class _TextFieldTextoState extends State<TextFieldTexto> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
          enabled: widget.botonHabilitado,
          controller: widget.textoSeteado,
          //La primera letra siempre mayus
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              prefixIcon: widget.icon == null ? Icon(null) : widget.icon,
              labelText: widget.nombre.toUpperCase(),
              labelStyle: TextStyle(
                  fontFamily: 'Trueno',
                  fontSize: 12.0,
                  color: Colores().colorSombraBotones),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores().colorSombraBotones),
              )),
          onChanged: widget.valor,
          validator: widget.validacion),
    );
  }
}
