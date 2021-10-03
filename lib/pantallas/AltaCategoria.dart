import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class AltaCategoria extends StatefulWidget {
  @override
  _AltaCategoria createState() => _AltaCategoria();
}

class _AltaCategoria extends State<AltaCategoria> {
  String _nombreCategoria;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                BarraDeNavegacion(
                  titulo: 'ALTA DE CATEGORIA',
                  iconoBtnUno: null,
                  onPressedBtnUno: null,
                ),
                SizedBox(height: 10),
                TextFieldTexto(
                  nombre: 'NOMBRE',
                  icon: Icon(Icons.account_tree_outlined),
                  valor: (value) {
                    this._nombreCategoria = value;
                  },
                  validacion: ((value) =>
                  value.isEmpty ? 'El nombre de la categoria es requerido' : null),
                ),
                SizedBox(height: 20.0),
                Boton(
                  titulo: 'GUARDAR',
                  onTap: crearSenia,
                ),
              ],
            )));
  }

  void crearSenia(){
    ControladorCategoria().crearCategoria(this._nombreCategoria);
  }
}
