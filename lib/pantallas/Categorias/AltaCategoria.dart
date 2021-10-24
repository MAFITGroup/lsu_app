import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

import 'Categorias.dart';

class AltaCategoria extends StatefulWidget {
  @override
  _AltaCategoria createState() => _AltaCategoria();
}

class _AltaCategoria extends State<AltaCategoria> {
  String _nombreCategoria;
  final formKey = new GlobalKey<FormState>();
  TextEditingController _textEditingController = new TextEditingController();
  bool isCategoriaExistente = false;
  List<SubCategoriaDinamica> listaDinamicaSubCategoria = [];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    child: TextFieldTexto(
                      controlador: _textEditingController,
                      nombre: 'NOMBRE',
                      icon: Icon(Icons.account_tree_outlined),
                      valor: (value) {
                        this._nombreCategoria = value;
                        //me guardo el valor en el metodo para hacer el chequeo.
                        existeCategoria(_nombreCategoria);
                      },
                      validacion: ((value) => value.isEmpty
                          ? 'El nombre de la categoria es requerido'
                          : null),
                    ),
                  ),
                  Container(
                      child: FloatingActionButton(
                    onPressed: agregarSubCategoria,
                    child: Icon(Icons.add),
                    backgroundColor: Colores().colorAzul,
                    splashColor: Colores().colorSombraBotones,
                  )),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Container(
                    height: 100,
                    child: Flexible(
                      child: ListView.builder(
                          itemCount: listaDinamicaSubCategoria.length,
                          itemBuilder: (_, index) =>
                              listaDinamicaSubCategoria[index]),
                    ),
                  )
                ],
              ),
              Boton(
                titulo: 'GUARDAR',
                onTap: () {
                  if (Validar().camposVacios(formKey)) {
                    if (!isCategoriaExistente) {
                      crearCategoria().then((value) {
                        /*
                                    Luego de guardar la categoria,
                                    creo un dialogo de alerta indicando que se
                                    guardo de forma ok
                                     */
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogoAlerta(
                                tituloMensaje: "Alta de Categoria",
                                mensaje:
                                    "La categoria ha sido guardada correctamente",
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Categorias()),
                                    ModalRoute.withName('/'),
                                  );
                                },
                              );
                            });
                        //TODO mensaje si falla.
                      }).catchError((e) {
                        ErrorHandler().errorDialog(context, e);
                      });
                    } else {
                      return showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return DialogoAlerta(
                              tituloMensaje: "Advertencia",
                              mensaje: "La categoria ingresada ya existe.",
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    }
                  }
                },
              ),
            ]),
          ),
        ),
      ],
    )));
  }

  agregarSubCategoria() {
    listaDinamicaSubCategoria.add(new SubCategoriaDinamica());
    setState(() {});
  }

  Future crearCategoria() async {
    ControladorCategoria().crearCategoria(this._nombreCategoria);
  }

  Future<bool> existeCategoria(String nombre) async {
    isCategoriaExistente = await ControladorCategoria().existeCategoria(nombre);
  }
}

class SubCategoriaDinamica extends StatelessWidget {
  TextEditingController subCategoria = new TextEditingController();
  String _nombreSubCategoria;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: new TextFieldTexto(
                controlador: subCategoria,
                nombre: 'NOMBRE',
                icon: Icon(Icons.account_tree_outlined),
                valor: (value) {
                  this._nombreSubCategoria = value;
                },
                validacion: ((value) => value.isEmpty
                    ? 'El nombre de la Sub Categoria es requerido'
                    : null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
