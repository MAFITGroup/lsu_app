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
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarSenia extends StatefulWidget {
  final Senia senia;
  final File file;

  const VisualizarSenia({Key key, this.senia, this.file}) : super(key: key);

  @override
  _VisualizarSeniaState createState() => _VisualizarSeniaState();
}

class _VisualizarSeniaState extends State<VisualizarSenia> {
  File archivoDeVideo;
  Uint8List fileWeb;
  List listaCategorias;
  bool modoEditar = false;
  ControladorSenia _controladorSenia = new ControladorSenia();

  //usadas para editar
  dynamic nuevoNombreSenia;
  dynamic nuevaDescripcionSenia;
  dynamic nuevaCategoriaSenia;

  @override
  void initState() {
    listarCateogiras();
  }

  @override
  Widget build(BuildContext context) {
    Senia senia = widget.senia;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'SEÑA' + " - " + senia.nombre.toUpperCase(),
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
                        child: Text(
                            !modoEditar ? "Editar Seña" : "Cancelar Editar")),
                    PopupMenuItem(
                      value: 1,
                      child: Text("Eliminar Seña"),

                      onTap: () {
                        eliminarSenia(
                            senia.nombre, senia.descripcion, senia.categoria)
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
                                    title: Text('Eliminar de Seña'),
                                    content: Text(
                                        'La seña ha eliminado modificada correctamente'),
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
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
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
              ],
            ),
            SizedBox(height: 20.0),
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
              icon: Icon(Iconos.hand),
              botonHabilitado: modoEditar,
              textoSeteado: TextEditingController(text: senia.nombre),
              valor: (value) {
                setState(() {
                  nuevoNombreSenia = value;
                });
              },
            ),
            SizedBox(height: 15.0),
            TextFieldDescripcion(
              nombre: 'DESCRIPCION',
              icon: Icon(Icons.description),
              botonHabilitado: modoEditar,
              textoSeteado: TextEditingController(text: senia.descripcion),
              valor: (value) {
                setState(() {
                  nuevaDescripcionSenia = value;
                });
              },
            ),
            SizedBox(height: 15.0),
            // Menu desplegable de Categorias
            DropdownSearch(
              items: listaCategorias,
              enabled: modoEditar,
              selectedItem: senia.categoria,
              onChanged: (value) {
                setState(() {
                  nuevaCategoriaSenia = value;
                });
              },
              showSearchBox: true,
              clearButton:
                  Icon(Icons.close, color: Colores().colorSombraBotones),
              dropDownButton: Icon(Icons.arrow_drop_down,
                  color: Colores().colorSombraBotones),
              showClearButton: true,
              mode: Mode.DIALOG,
              hint: "DESCRIPCION",
              autoFocusSearchBox: true,
              searchBoxDecoration: InputDecoration(
                focusColor: Colores().colorSombraBotones,
              ),
              dropdownSearchDecoration: InputDecoration(
                focusColor: Colores().colorSombraBotones,
              ),
              autoValidateMode: AutovalidateMode.always,
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
                      guardarEdicion(
                          senia.nombre,
                          senia.descripcion,
                          senia.categoria,
                          nuevoNombreSenia,
                          nuevaDescripcionSenia,
                          nuevaCategoriaSenia)
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
                                  title: Text('Edicion de Seña'),
                                  content: Text(
                                      'La seña ha sido modificada correctamente'),
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
                                                   ventana de alta seña

                                                     */
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                        })
                                  ],
                                );
                              });
                          //TODO mensaje si falla.
                        }).catchError((e) {
                          ErrorHandler().errorDialog(context, e);
                        });
                    })
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> listarCateogiras() async {
    listaCategorias = await ControladorCategoria().listarCategorias();
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
      String nombreNuevo,
      String descripcionNueva,
      String categoriaNueva) async {
    _controladorSenia.editarSenia(nombreAnterior, descripcionAnterior,
        categoriaAnterior, nombreNuevo, descripcionNueva, categoriaNueva);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarSenia() : canelarEditar();
        break;
    }
  }
}
