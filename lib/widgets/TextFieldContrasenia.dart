import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldContrasenia extends StatefulWidget {
  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;
  bool verContrasenia = true;

  TextFieldContrasenia({Key key, this.nombre, this.valor, this.validacion})
      : super(key: key);

  @override
  _TextFieldContraseniaState createState() => _TextFieldContraseniaState();
}

class _TextFieldContraseniaState extends State<TextFieldContrasenia> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextFormField(
          obscureText: widget.verContrasenia,
          decoration: InputDecoration(
              labelText: widget.nombre,
              labelStyle: TextStyle(
                  fontFamily: 'Trueno',
                  fontSize: 12.0,
                  color: Colors.grey.withOpacity(0.5)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores().colorAzul),
              ),
              suffix: InkWell(
                onTap: _accionVerContrasenia,
                child: Icon(
                    widget.verContrasenia
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colores().colorAzul),
              )),
          onChanged: widget.valor,
          validator: widget.validacion),
    );
  }

  void _accionVerContrasenia() {
    setState(() {
      widget.verContrasenia = !widget.verContrasenia;
    });
  }
}
