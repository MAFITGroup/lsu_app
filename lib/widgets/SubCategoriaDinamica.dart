import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';

import 'TextFieldTexto.dart';

class SubCategoriaDinamica extends StatefulWidget {
  final List<dynamic> listaSubcategorias;
  final bool modoAlta;
  final bool modoEditar;
  final String nombreSubCategoria;
  final Function onPressed;
  final TextEditingController controller;

  const SubCategoriaDinamica(
      {Key key,
      this.listaSubcategorias,
      this.modoAlta,
      this.modoEditar,
      this.nombreSubCategoria,
      this.onPressed,
      this.controller})
      : super(key: key);

  @override
  _SubCategoriaDinamicaState createState() => _SubCategoriaDinamicaState();
}

class _SubCategoriaDinamicaState extends State<SubCategoriaDinamica> {
  String _nombreSubCategoria;

  @override
  Widget build(BuildContext context) {
    List<dynamic> listaSubcategorias = widget.listaSubcategorias;
    bool modoAlta = widget.modoAlta;
    bool modoEditar = widget.modoEditar;
    String nombreSubCategoria = widget.nombreSubCategoria;
    Function onPressed = widget.onPressed;
    TextEditingController controller = widget.controller;

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFieldTexto(
                      controlador: controller,
                      habilitado: modoEditar || modoAlta,
                      nombre: 'NOMBRE SUBCATEGORIA',
                      icon: Icon(Icons.account_tree_outlined),
                      valor: (value) {
                        setState(() {
                          _nombreSubCategoria = value;
                        });
                      },
                      validacion: ((value) =>
                          value.isEmpty ? 'Campo Obligatorio' : null),
                      onSaved: (value) {
                        if (_nombreSubCategoria == null) {
                          _nombreSubCategoria = value;
                        }
                        setState(() {
                          listaSubcategorias
                              .add(_nombreSubCategoria.toUpperCase().trim());
                        });
                      }),
                ),
                Container(
                    child: modoEditar
                        ? FloatingActionButton(
                            heroTag: "btnEliminar",
                            onPressed: onPressed,
                            child: Icon(Icons.remove),
                            backgroundColor: Colores().colorAzul,
                            splashColor: Colores().colorSombraBotones,
                          )
                        : null)
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
