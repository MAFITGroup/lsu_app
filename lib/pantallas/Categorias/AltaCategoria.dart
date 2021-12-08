import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/SubCategoriaDinamica.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class AltaCategoria extends StatefulWidget {
  @override
  _AltaCategoria createState() => _AltaCategoria();
}

class _AltaCategoria extends State<AltaCategoria> {
  String _nombreCategoria;
  final formKey = new GlobalKey<FormState>();
  String _nombreSubCategoria;
  bool isCategoriaExistente = false;
  List<SubCategoriaDinamica> listaDinamicaWidgetSubCategoria = [];
  List<String> listaDeSubcategorias = [];
  List<String> listaDeSubcategoriasClaseDinamica = [];
  List<String> listaTotalSubs = [];
  ControladorCategoria _controladorCategoria = new ControladorCategoria();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        BarraDeNavegacion(
          titulo: Text("ALTA DE CATEGORÍA",
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
        ),
        Form(
          key: formKey,
          child: Container(
            child: Column(children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldTexto(
                            nombre: 'NOMBRE CATEGORÍA',
                            icon: Icon(Icons.category_outlined),
                            valor: (value) {
                              this._nombreCategoria = value;
                              //me guardo el valor en el metodo para hacer el chequeo.
                              existeCategoria(_nombreCategoria);
                            },
                            validacion: ((value) =>
                                value.isEmpty ? 'Campo Obligatorio' : null),
                          ),
                        ),
                        Container(
                            child: FloatingActionButton(
                          heroTag: "btnAgregar",
                          onPressed: agregarWidgetSubCategoria,
                          child: Icon(Icons.add),
                          backgroundColor: Colores().colorAzul,
                          splashColor: Colores().colorSombraBotones,
                        )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFieldTexto(
                              nombre: 'NOMBRE SUBCATEGORÍA',
                              icon: Icon(Icons.category_outlined),
                              valor: (value) {
                                setState(() {
                                  _nombreSubCategoria = value;
                                });
                              },
                              validacion: ((value) =>
                                  value.isEmpty ? 'Campo Obligatorio' : null),
                              onSaved: (value) {
                                listaDeSubcategorias.add(
                                    _nombreSubCategoria.toUpperCase().trim());
                              },
                            ),
                          ),
                          Container(
                              child: FloatingActionButton(
                            heroTag: "btnEliminar",
                            onPressed: eliminarWidgetSubCategoria,
                            child: Icon(Icons.remove),
                            backgroundColor: Colores().colorAzul,
                            splashColor: Colores().colorSombraBotones,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 550,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 350, minHeight: 56.0),
                      child: ListView.builder(
                          itemCount: listaDinamicaWidgetSubCategoria.length,
                          itemBuilder: (context, index) =>
                              listaDinamicaWidgetSubCategoria[index]),
                    ),
                    Boton(
                      titulo: 'GUARDAR',
                      onTap: () {
                        if (Validar().camposVacios(formKey)) {
                          listaTotalSubs.addAll(listaDeSubcategorias);
                          listaTotalSubs
                              .addAll(listaDeSubcategoriasClaseDinamica);
                          if (!isCategoriaExistente) {
                            if (!existeSubCategoria(listaTotalSubs)) {
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
                                        tituloMensaje: "Alta de Categoría",
                                        mensaje:
                                            "La categoría ha sido guardada correctamente",
                                        acciones: [
                                          TextButton(
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colores().colorAzul,
                                                    fontFamily: 'Trueno',
                                                    fontSize: 11.0,
                                                    decoration: TextDecoration
                                                        .underline)),
                                            onPressed: () {
                                              // cierro dialogo
                                              Navigator.of(context).pop();
                                              /*
                                                      elimino ventana alta
                                                       */
                                              Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => PaginaInicial()),
                                              (Route<dynamic> route) => false,
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    });
                                //TODO mensaje si falla.
                              }).catchError((e) {
                                ErrorHandler().errorDialog(context, e);
                              });
                            } else {
                              listaDeSubcategorias.clear();
                              listaDeSubcategoriasClaseDinamica.clear();
                              listaTotalSubs.clear();
                              return showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return DialogoAlerta(
                                      tituloMensaje: "Advertencia",
                                      mensaje:
                                          "Una de las subcategorías ingresadas está repetida.",
                                      acciones: [
                                        TextButton(
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: Colores().colorAzul,
                                                  fontFamily: 'Trueno',
                                                  fontSize: 11.0,
                                                  decoration: TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          } else {
                            return showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return DialogoAlerta(
                                    tituloMensaje: "Advertencia",
                                    mensaje: "La categoría ingresada " +
                                        _nombreCategoria +
                                        " ya existe.",
                                    acciones: [
                                      TextButton(
                                        child: Text('OK',
                                            style: TextStyle(
                                                color: Colores().colorAzul,
                                                fontFamily: 'Trueno',
                                                fontSize: 11.0,
                                                decoration:
                                                    TextDecoration.underline)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    )));
  }

  agregarWidgetSubCategoria() {
    setState(() {
      listaDinamicaWidgetSubCategoria.add(new SubCategoriaDinamica(
        listaSubcategorias: listaDeSubcategoriasClaseDinamica,
        modoAlta: true,
        modoEditar: false,
      ));
    });
  }

  eliminarWidgetSubCategoria() {
    setState(() {
      if (listaDinamicaWidgetSubCategoria.length > 0) {
        listaDinamicaWidgetSubCategoria
            .removeAt(listaDinamicaWidgetSubCategoria.length - 1);
      }
    });
  }

  Future crearCategoria() async {
    _controladorCategoria.crearCategoria(
        this._nombreCategoria, this.listaTotalSubs);
  }

  Future<bool> existeCategoria(String nombre) async {
    isCategoriaExistente = await _controladorCategoria.existeCategoria(nombre);
  }

  bool existeSubCategoria(List lista) {
    for (int i = 0; i < lista.length; i++) {
      if (lista.skip(i + 1).contains(lista[i])) {
        return true;
      }
    }
    return false;
  }
}
