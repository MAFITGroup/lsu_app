import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class TextFieldContrasenia extends StatefulWidget {
  final String nombre;
  final Function(String) valor;
  final Function(String) validacion;
  bool verContrasenia = true;
  final Icon icon;
  final Widget iconInfo;
  final TextEditingController controlador;
  final bool habilitado;

  TextFieldContrasenia(
      {Key key,
      this.nombre,
      this.valor,
      this.validacion,
      this.icon,
      this.controlador,
      this.habilitado, this.iconInfo})
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
          enabled: widget.habilitado,
          controller: widget.controlador,
          obscureText: widget.verContrasenia,
          decoration: InputDecoration(
              prefixIcon: widget.icon == null ? Icon(null) : widget.icon,
              labelText: widget.nombre,
              labelStyle: TextStyle(
                  fontFamily: 'Trueno',
                  fontSize: 12.0,
                  color: Colores().colorSombraBotones),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores().colorSombraBotones),
              ),
              suffixIcon: widget.iconInfo,
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
