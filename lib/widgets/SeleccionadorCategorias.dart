import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class SeleccionadorCategorias extends StatefulWidget {
  final List list;
  final String nombre;
  final dynamic catSeleccionada;
  final bool habilitado;
  final dynamic itemSeleccionado;

  const SeleccionadorCategorias(this.list, this.nombre, this.catSeleccionada,
      this.habilitado, this.itemSeleccionado);

  @override
  SeleccionadorCategoriasState createState() => SeleccionadorCategoriasState();
}

class SeleccionadorCategoriasState extends State<SeleccionadorCategorias> {
  @override
  Widget build(BuildContext context) {
    List list = widget.list;
    String nombre = widget.nombre;
    dynamic catSeleccionada = widget.catSeleccionada;
    dynamic itemSeleccionado = widget.itemSeleccionado;
    bool habilitado = widget.habilitado;
    return Container(
      child: DropdownSearch(
        items: list,
        enabled: habilitado,
        selectedItem: itemSeleccionado,
        onChanged: (value) {
          setState(() {
            catSeleccionada = value;
          });
        },
        showSearchBox: true,
        clearButton: Icon(Icons.close, color: Colores().colorSombraBotones),
        dropDownButton:
            Icon(Icons.arrow_drop_down, color: Colores().colorSombraBotones),
        showClearButton: true,
        mode: Mode.DIALOG,
        dropdownSearchDecoration: InputDecoration(
          focusColor: Colores().colorSombraBotones,
        ),
        autoValidateMode: AutovalidateMode.always,
      ),
    );
  }
}
