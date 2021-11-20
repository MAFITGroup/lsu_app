import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

import 'Glosario.dart';

class VisualizarSenia extends StatefulWidget {
  final Senia senia;
  final bool isUsuarioAdmin;
  final List subCategorias;

  const VisualizarSenia(
      {Key key, this.senia, this.isUsuarioAdmin, this.subCategorias})
      : super(key: key);

  @override
  _VisualizarSeniaState createState() => _VisualizarSeniaState();
}

class _VisualizarSeniaState extends State<VisualizarSenia> {
  File archivoDeVideo;
  Uint8List fileWeb;
  List listaCategorias = [];
  List listaSubCategorias = [];
  bool modoEditar;
  ControladorSenia _controladorSenia = new ControladorSenia();
  final formKey = new GlobalKey<FormState>();
  final subCategoriaKey = new GlobalKey<DropdownSearchState>();
  final categoriaKey = new GlobalKey<DropdownSearchState>();
  bool isSubCategoriaSeleccionada;
  TextEditingController _textEditingController;

  //usadas para editar
  String nuevoNombreSenia;
  String nuevaDescripcionSenia;
  String nuevaCategoriaSenia;
  String nuevaSubCategoriaSenia;

  @override
  void initState() {
    isSubCategoriaSeleccionada = true;
    listarCateogiras();
    setState(() {
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Senia senia = widget.senia;
    bool isUsuarioAdmin = widget.isUsuarioAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text('SEÑA' + " - " + senia.nombre.toUpperCase(),
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
                                leading: Icon(!modoEditar
                                    ? Icons.edit
                                    : Icons.cancel_outlined),
                                title: Text(!modoEditar
                                    ? "Editar Seña"
                                    : "Cancelar Editar")),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                                leading: Icon(Icons.delete_forever_outlined),
                                title: Text("Eliminar Seña")),
                          ),
                        ],
                      ),
                    ]
                  : [],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: senia.urlVideo == null
                              ? Icon(Icons.video_library_outlined,
                                  color: Colores().colorTextos, size: 150)
                              : SeleccionadorVideo(null, senia.urlVideo),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'NOMBRE',
                          icon: Icon(Icons.format_size_outlined),
                          botonHabilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: senia.nombre),
                          valor: (value) {
                            setState(() {
                              nuevoNombreSenia = value;
                            });
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'El nombre es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          botonHabilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: senia.descripcion),
                          valor: (value) {
                            setState(() {
                              nuevaDescripcionSenia = value;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        // Menu desplegable de Categorias
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            key: categoriaKey,
                            items: listaCategorias,
                            enabled: modoEditar,
                            selectedItem: senia.categoria,
                            onChanged: (value) async {
                              await listarSubCateogiras(value);
                              subCategoriaKey.currentState.clear();
                              setState(() {
                                nuevaCategoriaSenia = value;
                                if (value != null) {
                                  isSubCategoriaSeleccionada = true;
                                  subCategoriaKey.currentState.clear();
                                } else {
                                  isSubCategoriaSeleccionada = false;
                                  subCategoriaKey.currentState.clear();
                                }
                              });
                            },
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: modoEditar
                                ? Icon(Icons.arrow_drop_down,
                                    color: Colores().colorSombraBotones)
                                : Container(),
                            showClearButton: modoEditar ? true : false,
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
                            validator: (dynamic valor) {
                              if (valor == null) {
                                return "La categoría es requerida";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        // Menu desplegable de SubCategorias
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            key: subCategoriaKey,
                            items: listaSubCategorias,
                            enabled: modoEditar && isSubCategoriaSeleccionada,
                            selectedItem: senia.subCategoria,
                            onChanged: (value) {
                              setState(() {
                                nuevaSubCategoriaSenia = value;
                              });
                            },
                            dropdownBuilderSupportsNullItem: true,
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: modoEditar
                                ? Icon(Icons.arrow_drop_down,
                                    color: Colores().colorSombraBotones)
                                : Container(),
                            showClearButton: modoEditar ? true : false,
                            mode: Mode.DIALOG,
                            dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 12,
                                    color: Colores().colorSombraBotones),
                                hintText: "SUBCATEGORÍA",
                                prefixIcon: Icon(Icons.category_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                            validator: (dynamic valor) {
                              if (valor == null) {
                                return "La subcategoría es requerida";
                              } else {
                                return null;
                              }
                            },
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
                                  if (nuevoNombreSenia == null) {
                                    nuevoNombreSenia = senia.nombre;
                                  }
                                  if (nuevaDescripcionSenia == null) {
                                    nuevaDescripcionSenia = senia.descripcion;
                                  }
                                  if (nuevaCategoriaSenia == null) {
                                    nuevaCategoriaSenia = senia.categoria;
                                  }
                                  if (nuevaSubCategoriaSenia == null) {
                                    nuevaSubCategoriaSenia = senia.subCategoria;
                                  }
                                  if (Validar().camposVacios(formKey)) {
                                    guardarEdicion(
                                        senia.nombre,
                                        senia.descripcion,
                                        senia.categoria,
                                        senia.subCategoria,
                                        nuevoNombreSenia,
                                        nuevaDescripcionSenia,
                                        nuevaCategoriaSenia,
                                        nuevaSubCategoriaSenia)
                                      ..then((userCreds) {
                                        /*
                                        Luego de editar la seña,
                                        creo un dialogo de alerta indicando que se
                                        guardo de forma ok
                                         */
                                        showDialog(
                                            useRootNavigator: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Edición de Seña'),
                                                content: Text(
                                                    'La seña ha sido modificada correctamente'),
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
                                                       ventana de alta seña

                                                         */
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Glosario();
                                                            },
                                                          ),
                                                        );
                                                        /*
                                                        Cuatro POP, uno para el diologo y los demas
                                                        para la volver a la
                                                        pantalla de glosario
                                                         */
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
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
          ],
        ),
      ),
    );
  }

  Future<void> listarCateogiras() async {
    listaCategorias = await ControladorCategoria().listarCategorias();
  }

  Future<void> listarSubCateogiras(String nombreCategoria) async {
    listaSubCategorias = await ControladorCategoria()
        .listarSubCategoriasPorCategoriaList(nombreCategoria);
  }

  void editarSenia() {
    setState(() {
      modoEditar = true;
    });
  }

  void canelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  Future eliminarSenia(
      String nombre, String descripcion, String categoria) async {
    _controladorSenia.eliminarSenia(nombre, descripcion, categoria);
  }

  /*
  Se pasan los params de nombre anterior
  para que el controlador los obtenga y pueda obtener
  el identificador del documento ya existente
  y setear los nuevos valores.
   */
  Future guardarEdicion(
      String nombreAnterior,
      String descripcionAnterior,
      String categoriaAnterior,
      String subCategoriaAnterior,
      String nombreNuevo,
      String descripcionNueva,
      String categoriaNueva,
      String subCategoriaNueva) async {
    _controladorSenia.editarSenia(
        nombreAnterior,
        descripcionAnterior,
        categoriaAnterior,
        subCategoriaAnterior,
        nombreNuevo,
        descripcionNueva,
        categoriaNueva,
        subCategoriaNueva);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarSenia() : canelarEditar();
        break;
      case 1:
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminación de Seña'),
                content: Text('¿Está seguro que desea eliminar la seña?'),
                actions: [
                  TextButton(
                      child: Text('OK',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        eliminarSenia(widget.senia.nombre,
                            widget.senia.descripcion, widget.senia.categoria)
                          ..then((userCreds) {
                            /*
                                    Luego de eliminar la seña,
                                    creo un dialogo de alerta indicando que se
                                    elimino de forma ok
                                     */
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Eliminación de Seña'),
                                    content: Text(
                                        'La seña ha sido eliminada correctamente'),
                                    actions: [
                                      TextButton(
                                          child: Text('Ok',
                                              style: TextStyle(
                                                  color: Colores().colorAzul,
                                                  fontFamily: 'Trueno',
                                                  fontSize: 11.0,
                                                  decoration: TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            /*Al presionar Ok, cierro la el dialogo y cierro la
                                                   ventana de visualizacion seña

                                                     */
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return Glosario();
                                                },
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          })
                                    ],
                                  );
                                });
                            //TODO mensaje si falla.
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
    }
  }
}
