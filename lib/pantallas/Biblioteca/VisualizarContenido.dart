import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorContenido.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Contenido.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarContenido extends StatefulWidget {
  final Contenido contenido;
  final bool isUsuarioAdmin;

  const VisualizarContenido({Key key, this.contenido, this.isUsuarioAdmin})
      : super(key: key);

  @override
  _VisualizarContenidoState createState() => _VisualizarContenidoState();
}

class _VisualizarContenidoState extends State<VisualizarContenido> {
  File archivo;
  Uint8List fileWeb;
  List listaCategorias;
  bool modoEditar;
  ControladorContenido _controladorContenido = new ControladorContenido();
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  final formKey = new GlobalKey<FormState>();

  //usadas para editar
  dynamic nuevoTituloContenido;
  dynamic nuevaDescripcionContenido;
  dynamic nuevaCategoriaContenido;

  @override
  void initState() {
    listarCateogiras();
    setState(() {
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Contenido contenido = widget.contenido;
    bool isUsuarioAdmin = widget.isUsuarioAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text('CONTENIDO' + " - " + contenido.titulo.toUpperCase(),
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              listaWidget: isUsuarioAdmin
              ? [
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
                          ? "Editar Contenido"
                          : "Cancelar Editar")),
                  PopupMenuItem(
                    value: 1,
                    child: Text("Eliminar Contenido"),
                  )
                ],
              ),
              ]
              : [],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TITULO',
                          icon: Icon(Iconos.hand),
                          botonHabilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: contenido.titulo),
                          valor: (value) {
                            setState(() {
                              nuevoTituloContenido = value;
                            });
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'El titulo es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCION',
                          icon: Icon(Icons.description),
                          botonHabilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: contenido.descripcion),
                          valor: (value) {
                            setState(() {
                              nuevaDescripcionContenido = value;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        // Menu desplegable de Categorias
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: listaCategorias,
                            enabled: modoEditar,
                            selectedItem: contenido.categoria,
                            onChanged: (value) {
                              setState(() {
                                nuevaCategoriaContenido = value;
                              });
                            },
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: Icon(Icons.arrow_drop_down,
                                color: Colores().colorSombraBotones),
                            showClearButton: true,
                            mode: Mode.DIALOG,
                            searchBoxDecoration: InputDecoration(
                              focusColor: Colores().colorSombraBotones,
                            ),
                            dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 12,
                                    color: Colores().colorSombraBotones),
                                hintText: "CATEGORIA",
                                prefixIcon: Icon(Icons.account_tree_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                            autoValidateMode: AutovalidateMode.always,
                          ),
                        ),

                        SizedBox(height: 20.0),
                        modoEditar
                            ? Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              /*
                          Si presiono guardar y no modifique ningun campo
                          los valores son nullos, por lo tanto les seteo
                          el valor que tienen.
                           */
                              if (nuevoTituloContenido == null) {
                                nuevoTituloContenido = contenido.titulo;
                              }
                              if (nuevaDescripcionContenido == null) {
                                nuevaDescripcionContenido = contenido.descripcion;
                              }
                              if (nuevaCategoriaContenido == null) {
                                nuevaCategoriaContenido = contenido.categoria;
                              }
                              if (Validar().camposVacios(formKey)) {
                                guardarEdicion(
                                    contenido.titulo,
                                    contenido.descripcion,
                                    contenido.categoria,
                                    nuevoTituloContenido,
                                    nuevaDescripcionContenido,
                                    nuevaCategoriaContenido)
                                  ..then((userCreds) {
                                    /*
                                        Luego de editar el contenido,
                                        creo un dialogo de alerta indicando que se
                                        guardo de forma ok
                                         */
                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Edicion de Contenido'),
                                            content: Text(
                                                'El contenido ha sido modificado correctamente'),
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
                                                    /*Al presionar Ok, cierro la el dialogo y cierro la
                                                       ventana de alta contenido

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
                            })
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> listarCateogiras() async {
    listaCategorias = await ControladorCategoria().listarCategorias();
  }

  void editarContenido() {
    setState(() {
      modoEditar = true;
    });
  }

  void canelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  Future eliminarContenido(
      String titulo, String descripcion, String categoria) async {
    _controladorContenido.eliminarContenido(titulo, descripcion, categoria);
  }

  /*
  Se pasan los params de nombre anterior
  para que el controlador los obtenga y pueda obtener
  el identificador del documento ya existente
  y setear los nuevos valores.
   */
  Future guardarEdicion(
      String tituloAnterior,
      String descripcionAnterior,
      String categoriaAnterior,
      String tituloNuevo,
      String descripcionNueva,
      String categoriaNueva) async {
    _controladorContenido.editarContenido(tituloAnterior, descripcionAnterior,
        categoriaAnterior, tituloNuevo, descripcionNueva, categoriaNueva);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarContenido() : canelarEditar();
        break;
      case 1:
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminacion de Contenido'),
                content: Text(
                    'El Contenido ha sido eliminado correctamente'),
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
                                                   ventana de visualizacion contenido

                                                     */
                        Navigator.of(context)
                            .popUntil((route) =>
                        route.isFirst);
                      })
                ],
              );
            });

          /*eliminarContenido(contenido.titulo, contenido.descripcion,
              contenido.categoria)
            ..then((userCreds) {
              /*
                                    Luego de eliminar el contenido,
                                    creo un dialogo de alerta indicando que se
                                    elimino de forma ok
                                     */
              showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Eliminacion de Contenido'),
                      content: Text(
                          'El Contenido ha sido eliminado correctamente'),
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
                                                   ventana de visualizacion contenido

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
        },*/

        break;
    }
  }
}