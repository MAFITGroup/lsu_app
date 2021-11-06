
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TextFieldTexto.dart';

class SubCategoriaDinamica extends StatefulWidget {
  final List<String> listaSubcategorias;

  const SubCategoriaDinamica({Key key, this.listaSubcategorias})
      : super(key: key);

  @override
  _SubCategoriaDinamicaState createState() => _SubCategoriaDinamicaState();
}

class _SubCategoriaDinamicaState extends State<SubCategoriaDinamica> {
  String _nombreSubCategoria;

  @override
  Widget build(BuildContext context) {
    List<String> listaSubcategorias = widget.listaSubcategorias;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFieldTexto(
                    nombre: 'NOMBRE SUBCATEGORIA',
                    icon: Icon(Icons.account_tree_outlined),
                    valor: (value) {
                      _nombreSubCategoria = value;
                    },
                    validacion: ((value) => value.isEmpty
                        ? 'El nombre de la Sub Categoria es requerido'
                        : null),
                    onSaved: (value) {
                      listaSubcategorias.add(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
