import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarCategoria extends StatefulWidget {
  final Categoria categoria;

  const VisualizarCategoria({Key key, this.categoria})
      : super(key: key);

  @override
  _VisualizarCategoriaState createState() => _VisualizarCategoriaState();
}
class _VisualizarCategoriaState extends State<VisualizarCategoria> {
  bool modoEditar;
  ControladorCategoria _controladorCategoria = new ControladorCategoria();
  final formKey = new GlobalKey<FormState>();

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
              listaWidget:
              [
                PopupMenuButton<int>(
                  /*
              Agregar en el metodo on Selected
              las acciones
               */
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                        value: 0,
                        child: Text(!modoEditar
                            ? "Editar Categoria"
                            : "Cancelar Editar")),
                    PopupMenuItem(
                      value: 1,
                      child: Text("Eliminar Categoria"),
                      onTap: () {
                        eliminarCategoria(categoria.nombre)
                          ..then((userCreds) {
                            /*
                                    Luego de eliminar la categoria,
                                    creo un dialogo de alerta indicando que se
                                    elimino de forma ok
                                     */
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Eliminacion de Categoria'),
                                    content: Text(
                                        'La Categoria ha sido eliminada correctamente'),
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
                                            /*Al presionar Ok, cierro la el dialogo y cierro la
                                                   ventana de visualizacion categoria

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
                      },
                    )
                  ],
                ),
              ]
              ,
            ),
            Form(
              key: formKey,
              child: Container(
                child: Column( children: [
                  SizedBox(height: 10),
                  TextFieldTexto(
                    nombre: 'NOMBRE',
                    icon: Icon(Icons.account_tree_outlined),
                    botonHabilitado: modoEditar,
                    controlador: modoEditar
                        ? null
                        : TextEditingController(text: categoria.nombre),
                    valor: (value) {
                      setState(() {
                        nuevoNombreCategoria = value;
                      });
                    },

                  ),

                  SizedBox(height: 20.0),
                  modoEditar
                      ? Boton(
                      titulo: 'GUARDAR',
                      onTap: () {
                        if (nuevoNombreCategoria.isEmpty){
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog_campoVacioCat();
                              });
                        }
                        /*if (_controladorCategoria.obtenerCategoriaExistente(
                            nuevoNombreCategoria) != null) {
                          showCupertinoDialog
                            (context: context, barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog_catExistente();
                              });
                        }*/else {
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
                                                  color: Colores()
                                                      .colorAzul,
                                                  fontFamily:
                                                  'Trueno',
                                                  fontSize: 11.0,
                                                  decoration:
                                                  TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            guardarEdicion(categoria.nombre,
                                                nuevoNombreCategoria)
                                              ..then((userCreds) {
                                                modificarCatSenia(
                                                    categoria.nombre,
                                                    nuevoNombreCategoria);
                                                Navigator.of(context).pop();
                                                showCupertinoDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) {
                                                      return AlertDialog_EdicionSuccess();
                                                    });
                                              }
                                              );
                                          }),
                                      TextButton(
                                          child: Text('Cancelar',
                                              style: TextStyle(
                                                  color: Colores()
                                                      .colorAzul,
                                                  fontFamily:
                                                  'Trueno',
                                                  fontSize: 11.0,
                                                  decoration:
                                                  TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            /*Al presionar Cancelar, cierro el dialogo y me quedo en la misma pag*/
                                            Navigator.of(context)
                                                .pop();
                                          })
                                    ],
                                  );
                                });
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

  Future eliminarCategoria(String nombre)
  async { _controladorCategoria.eliminarCategoria(nombre);
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
    }
  }
}