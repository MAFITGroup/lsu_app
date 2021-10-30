import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarCategoria extends StatefulWidget {
  final Categoria categoria;

  const VisualizarCategoria({Key key, this.categoria}) : super(key: key);

  @override
  _VisualizarCategoriaState createState() => _VisualizarCategoriaState();
}

class _VisualizarCategoriaState extends State<VisualizarCategoria> {
  bool modoEditar;
  ControladorCategoria _controladorCategoria = new ControladorCategoria();
  final formKey = new GlobalKey<FormState>();
  bool isCategoriaExistente = false;
  bool isCategoriaEnSenia = false;
  String _nombreCategoria;

  //usadas para editar
  dynamic nuevoNombreCategoria;

  @override
  void initState() {
    setState(() {
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Categoria categoria = widget.categoria;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text('CATEGORIA' + " - " + categoria.nombre.toUpperCase(),
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              listaWidget: [
                PopupMenuButton<int>(
                  /*
              Agregar en el metodo on Selected
              las acciones
               */
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 0,
                        child: Text(!modoEditar
                            ? "Editar Categoria"
                            : "Cancelar Editar")),
                    PopupMenuItem(
                      value: 1,
                      child: Text("Eliminar Categoria"),
                    )
                  ],
                ),
              ],
            ),
            Form(
              key: formKey,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFieldTexto(
                      nombre: 'NOMBRE',
                      icon: Icon(Icons.account_tree_outlined),
                      botonHabilitado: modoEditar,
                      controlador: modoEditar
                          ? null
                          : TextEditingController(text: categoria.nombre),
                      valor: (value) {
                        this.nuevoNombreCategoria = value;
                        existeCategoria(nuevoNombreCategoria);
                      },
                      validacion: ((value) =>
                          value.isEmpty ? 'El nombe es requerido' : null),
                    ),
                    SizedBox(height: 20.0),
                    modoEditar
                        ? Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (nuevoNombreCategoria == null) {
                                nuevoNombreCategoria = categoria.nombre;
                              }
                              if (Validar().camposVacios(formKey)) {
                                if (!isCategoriaExistente) {
                                  showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edicion de Categoría'),
                                          content: Text(
                                              '¿Confirma que desea modificar la Categoría Seleccionada?'),
                                          actions: [
                                            TextButton(
                                                child: Text('Ok',
                                                    style: TextStyle(
                                                        color:
                                                            Colores().colorAzul,
                                                        fontFamily: 'Trueno',
                                                        fontSize: 11.0,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                                onPressed: () {
                                                  guardarEdicion(
                                                      categoria.nombre,
                                                      nuevoNombreCategoria)
                                                    ..then((userCreds) {
                                                      modificarCatSenia(
                                                          categoria.nombre,
                                                          nuevoNombreCategoria);
                                                      Navigator.of(context)
                                                          .pop();
                                                      showCupertinoDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (context) {
                                                            return AlertDialog_EdicionSuccess();
                                                          });
                                                    });
                                                }),
                                            TextButton(
                                                child: Text('Cancelar',
                                                    style: TextStyle(
                                                        color:
                                                            Colores().colorAzul,
                                                        fontFamily: 'Trueno',
                                                        fontSize: 11.0,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                                onPressed: () {
                                                  /*Al presionar Cancelar, cierro el dialogo y me quedo en la misma pag*/
                                                  Navigator.of(context).pop();
                                                })
                                          ],
                                        );
                                      });
                                } else {
                                  showCupertinoDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return DialogoAlerta(
                                          tituloMensaje: "Advertencia",
                                          mensaje:
                                              "La categoria ingresada ya existe.",
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                }
                              }
                            })
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editarCategoria() {
    setState(() {
      modoEditar = true;
    });
  }

  void cancelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  Future eliminarCategoria(String nombre) async {
    _controladorCategoria.eliminarCategoria(nombre);
  }

  Future<bool> existeCategoria(String nombre) async {
    isCategoriaExistente = await ControladorCategoria().existeCategoria(nombre);
  }

  Future<bool> existeCategoriaenSenia(String nombre) async {
    isCategoriaEnSenia = await ControladorCategoria().existeCategoriaenSenia(nombre);
  }

  /*
  Se pasan los params de nombre anterior
  para que el controlador los obtenga y pueda obtener
  el identificador del documento ya existente
  y setear los nuevos valores.
   */
  Future guardarEdicion(
    String nombreAnterior,
    String nombreNuevo,
  ) async {
    _controladorCategoria.editarCategoria(nombreAnterior, nombreNuevo);
  }

  Future modificarCatSenia(
    String nombreNuevo,
    String nombreAnterior,
  ) async {
    _controladorCategoria.obtenerSeniaModifCat(nombreNuevo, nombreAnterior);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarCategoria() : cancelarEditar();
        break;
      case 1:
        _nombreCategoria = widget.categoria.nombre;
        existeCategoriaenSenia(_nombreCategoria);
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminacion de Categoria'),
                content: Text(
                    '¿Confirma que desea eliminar la Categoría Seleccionada?'),
                actions: [
                  TextButton(
                      child: Text('Ok',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (isCategoriaEnSenia == false) {
                          eliminarCategoria(widget.categoria.nombre);
                          Navigator.of(context).pop();
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return DialogoAlerta(
                                  tituloMensaje: "Categoría Eliminada",
                                  mensaje:
                                      "La categoria ha sido eliminada correctamente.",
                                  onPressed: () {
                                    Navegacion(context).navegarACategorias();
                                  },
                                );
                              });
                        } else {
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return DialogoAlerta(
                                  tituloMensaje: "Aviso de Alerta",
                                  mensaje:
                                  "No es posible eliminar la categoría. La misma está asociada a una o más señas.",
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              });
                        }
                      }),
                  TextButton(
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        /*Al presionar Cancelar, cierro el dialogo y cierro la
                                                   ventana de visualizacion categoria
                                                     */
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
        break;
    }
  }
}
