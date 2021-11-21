import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldTexto extends StatefulWidget {
  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;

  /*
  @onSaved se usa para las subCategorias
   */
  final Function(String) onSaved;
  final Icon icon;

  /*
  Con este controlador, puedo limpiar el textfield,
  setearle un valor por defecto,etc.
   */
  final TextEditingController controlador;
  final bool habilitado;

  TextFieldTexto({
    Key key,
    this.nombre,
    this.valor,
    this.validacion,
    this.icon,
    this.controlador,
    this.habilitado,
    this.onSaved,
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
        enabled: widget.habilitado,
        controller: widget.controlador,
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
        validator: widget.validacion,
        onSaved: widget.onSaved,
      ),
    );
  }
}
