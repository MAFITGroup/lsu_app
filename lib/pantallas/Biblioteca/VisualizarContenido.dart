import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorContenido.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Contenido.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

import 'VisualizarPDF.dart';

class VisualizarContenido extends StatefulWidget {
  final Contenido contenido;
  final bool isUsuarioAdmin;
  final String archivoRef;
  final String titulo;
  final String autor;

  const VisualizarContenido(
      {Key key,
      this.contenido,
      this.isUsuarioAdmin,
      this.archivoRef,
      this.titulo,
      this.autor})
      : super(key: key);

  @override
  _VisualizarContenidoState createState() => _VisualizarContenidoState();
}

class _VisualizarContenidoState extends State<VisualizarContenido> {
  List _categorias = [
    'Papers',
    'Tesis',
    'Investigaciones',
    'Otros'
  ]; // Lista de las categorias dentro de biblioteca. Hardcodeadas xq son únicas.
  bool modoEditar;
  ControladorContenido _controladorContenido = new ControladorContenido();
  final formKey = new GlobalKey<FormState>();

  //usadas para editar
  dynamic nuevoTituloContenido;
  dynamic nuevaDescripcionContenido;
  dynamic nuevoAutorContenido;
  dynamic nuevaCategoriaContenido;

  @override
  void initState() {
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
                              child: ListTile(
                                  leading: Icon(
                                      !modoEditar
                                          ? Icons.edit
                                          : Icons.cancel_outlined,
                                      color: Colores().colorAzul),
                                  title: Text(
                                      !modoEditar
                                          ? "Editar Contenido"
                                          : "Cancelar Editar",
                                      style: TextStyle(
                                          fontFamily: 'Trueno',
                                          fontSize: 14,
                                          color:
                                              Colores().colorSombraBotones)))),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                                leading: Icon(Icons.delete_forever_outlined,
                                    color: Colores().colorAzul),
                                title: Text("Eliminar Contenido",
                                    style: TextStyle(
                                        fontFamily: 'Trueno',
                                        fontSize: 14,
                                        color: Colores().colorSombraBotones))),
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
                          nombre: 'TÍTULO',
                          icon: Icon(Icons.format_size_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: contenido.titulo),
                          valor: (value) {
                            setState(() {
                              nuevoTituloContenido = value;
                            });
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(
                                  text: contenido.descripcion),
                          valor: (value) {
                            setState(() {
                              nuevaDescripcionContenido = value;
                            });
                          },
                          validacion: ((value) => value.isEmpty
                              ? 'Campo Obligatorio'
                              : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'AUTOR',
                          icon: Icon(Icons.person_outline_sharp),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: contenido.autor),
                          valor: (value) {
                            setState(() {
                              nuevoAutorContenido = value;
                            });
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        // Menu desplegable de Categorias
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: _categorias,
                            enabled: modoEditar,
                            selectedItem: contenido.categoria,
                            onChanged: (value) {
                              setState(() {
                                nuevaCategoriaContenido = value;
                              });
                            },
                            validator: ((value) => value == null
                                ? 'Campo Obligatorio'
                                : null),
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: Icon(Icons.arrow_drop_down,
                                color: Colores().colorSombraBotones),
                            showClearButton: true,
                            mode: Mode.DIALOG,
                            dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 12,
                                    color: Colores().colorSombraBotones),
                                hintText: "CATEGORÍA",
                                prefixIcon: Icon(Icons.category_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                            autoValidateMode: AutovalidateMode.always,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Visibility(
                          visible: !modoEditar,
                          child: Boton(
                              titulo: 'VER ARCHIVO',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisualizarPDF(
                                              archivoRef: contenido.urlarchivo,
                                              titulo: contenido.titulo,
                                            )));
                              }),
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
                                  if (nuevoAutorContenido == null) {
                                    nuevoAutorContenido = contenido.autor;
                                  }
                                  if (nuevaDescripcionContenido == null) {
                                    nuevaDescripcionContenido =
                                        contenido.descripcion;
                                  }
                                  if (nuevaCategoriaContenido == null) {
                                    nuevaCategoriaContenido =
                                        contenido.categoria;
                                  }
                                  if (Validar().camposVacios(formKey)) {
                                    guardarEdicion(
                                        contenido.titulo,
                                        contenido.descripcion,
                                        contenido.categoria,
                                        contenido.autor,
                                        nuevoTituloContenido,
                                        nuevaDescripcionContenido,
                                        nuevaCategoriaContenido,
                                        nuevoAutorContenido)
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
                                              return DialogoAlerta(
                                                tituloMensaje:
                                                    'Edicion de Contenido',
                                                mensaje:'El contenido ha sido modificado correctamente',
                                                acciones: [
                                                  TextButton(
                                                      child: Text('OK',
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
                                                        /*Al presionar Ok, cierro el dialogo y cierro la
                                                       ventana de alta contenido

                                                         */
                                                        Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => PaginaInicial()),
                                                              (Route<dynamic> route) => false,
                                                        );
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
      String titulo, String descripcion, String categoria, String autor) async {
    _controladorContenido.eliminarContenido(
        titulo, descripcion, categoria, autor);
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
      String autorAnterior,
      String tituloNuevo,
      String descripcionNueva,
      String categoriaNueva,
      String autorNuevo) async {
    _controladorContenido.editarContenido(
        tituloAnterior,
        descripcionAnterior,
        categoriaAnterior,
        autorAnterior,
        tituloNuevo,
        descripcionNueva,
        categoriaNueva,
        autorNuevo);
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
              return DialogoAlerta(
                tituloMensaje: 'Eliminación de Contenido',
                mensaje: '¿Confirma que desea eliminar el contenido seleccionado?',
                acciones: [
                  TextButton(
                      child: Text('OK',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        eliminarContenido(
                            widget.contenido.titulo,
                            widget.contenido.descripcion,
                            widget.contenido.categoria,
                            widget.contenido.autor);
                        showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return DialogoAlerta(
                                tituloMensaje: "Contenido Eliminado",
                                mensaje:
                                    "El contenido ha sido eliminado correctamente.",
                                acciones: [
                                  TextButton(
                                    child: Text('OK',
                                        style: TextStyle(
                                            color: Colores().colorAzul,
                                            fontFamily: 'Trueno',
                                            fontSize: 11.0,
                                            decoration: TextDecoration.underline)),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => PaginaInicial()),
                                              (Route<dynamic> route) => false,
                                        );
                                      },
                                  )
                                ],
                              );
                            }).catchError((e) {
                          ErrorHandler().errorDialog(context, e);
                        });
                      }),
                  TextButton(
                      child: Text('CANCELAR',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
        break;
    }
  }
}
