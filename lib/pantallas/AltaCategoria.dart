import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class AltaCategoria extends StatefulWidget {
  @override
  _AltaCategoria createState() => _AltaCategoria();
}

class _AltaCategoria extends State<AltaCategoria> {
  String _nombreCategoria;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        BarraDeNavegacion(
          titulo: Text("ALTA DE CATEGORIA",
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
        ),
        Form(
          key: formKey,
          child: Container(
            child: Column(children: [
              SizedBox(height: 10),
              TextFieldTexto(
                nombre: 'NOMBRE',
                icon: Icon(Icons.account_tree_outlined),
                valor: (value) {
                  this._nombreCategoria = value;
                },
                validacion: ((value) => value.isEmpty
                    ? 'El nombre de la categoria es requerido'
                    : null),
              ),
              SizedBox(height: 20.0),
              Boton(
                titulo: 'GUARDAR',
                onTap: () {
                  if (Validar().camposVacios(formKey)) {
                    crearCategoria().then((value) {
                      /*
                                    Luego de guardar la seña,
                                    creo un dialogo de alerta indicando que se
                                    guardo de forma ok
                                     */
                      showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alta de Categoria'),
                              content: Text(
                                  'La categoria ha sido guardada correctamente'),
                              actions: [
                                TextButton(
                                    child: Text('Ok',
                                        style: TextStyle(
                                            color: Colores().colorAzul,
                                            fontFamily: 'Trueno',
                                            fontSize: 11.0,
                                            decoration:
                                                TextDecoration.underline)),
                                    onPressed: () {
                                      /*Al presionar Ok, cierro la el dialogo y cierro la
                                                   ventana de alta categorias

                                                     */
                                      Navigator.of(context)
                                          .popUntil((route) =>
                                      route.isFirst);
                                    })
                              ],
                            );
                          });
                      //TODO mensaje si falla.
                    }).catchError((e) {
                      ErrorHandler().errorDialog(context, e);
                    });
                  }
                },
              ),
            ]),
          ),
        ),
      ],
    )));
  }

  Future crearCategoria() async {
    ControladorCategoria().crearCategoria(this._nombreCategoria);
  }
}
