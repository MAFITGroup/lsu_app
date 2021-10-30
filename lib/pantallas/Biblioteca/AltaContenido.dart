import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorContenido.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:universal_html/html.dart' as html;

class AltaContenido extends StatefulWidget {
  @override
  _AltaContenidoState createState() => _AltaContenidoState();
}

class _AltaContenidoState extends State<AltaContenido> {
  List _categorias = [
    'Papers',
    'Tesis',
    'Investigaciones',
    'Otros'
  ]; // Lista de las categorias dentro de biblioteca. Hardcodeadas xq son únicas.
  ControladorContenido _controladorContenido = new ControladorContenido();
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  String _tituloContenido;
  String _descripcionContenido;
  File archivo;
  String _url;
  Uint8List fileWeb;
  final formKey = new GlobalKey<FormState>();
  String _usuarioUID = FirebaseAuth.instance.currentUser.uid;
  dynamic _catSeleccionada;
  UploadTask uploadTask;

  @override
  void initState() {
    _categorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text("ALTA DE CONTENIDO",
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                /*
                Los campos estan dentro de un Form para que cuando
                se presione guardar se validen los campos.
                 */
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TITULO',
                          icon: Icon(Iconos.hand),
                          valor: (value) {
                            this._tituloContenido = value;
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'El título es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCION',
                          icon: Icon(Icons.description),
                          valor: (value) {
                            this._descripcionContenido = value;
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'La descripción es requerida' : null),
                        ),
                        SizedBox(height: 15.0),
                        // Menu desplegable de Categorias
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: _categorias,
                            onChanged: (value) {
                              setState(() {
                                _catSeleccionada = value;
                              });
                            },
                            validator: ((value) =>
                            value == null ? 'La categoría es requerida' : null),
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
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Boton(
                          titulo: 'SELECCIONAR ARCHIVO',
                          onTap: () {
                            obtenerArchivo()
                              ..then((userCreds) {
                                showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog_cargaArchivo();
                                    });
                              });
                          },
                        ),
                        Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (Validar().camposVacios(formKey) &&
                                  /*verifico que el archivo no sea null dependiendo
                                  si estoy en la web
                                   */
                                  (kIsWeb
                                      ? fileWeb != null
                                      : archivo != null) &&
                                  _catSeleccionada != null) {
                                guardarContenido().then((userCreds) {
                                  showCupertinoDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return AlertDialog_altaConfirmacion();
                                      }); //TODO mensaje si falla.
                                }).catchError((e) {
                                  ErrorHandler().errorDialog(context, e);
                                });
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog_validarAltaContenido();
                                    });
                              }
                            }
                        ),
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

  Future guardarContenido() async {
    String url;
    final destino = 'Biblioteca/$_tituloContenido';
    String nombreUsuario =
    await _controladorUsuario.obtenerNombreUsuario(_usuarioUID);

    /*ESTOY EN LA WEB*/

    if (kIsWeb) {
      if (fileWeb == null) {
        return;
      } else {
        /*GUARDA EL ARCHIVO WEB WEB

      Si la plataforma es web, guarda el archivo en byte,
      ya que es el tipo de archivo que se puede reproducir
      con el widget de reproductor de video.*/

        _controladorContenido.crearYSubirContenidoBytes(
            _tituloContenido,
            _descripcionContenido,
            _catSeleccionada,
            nombreUsuario,
            destino,
            fileWeb);
      }
    } else {
      /*NO ESTOY EN LA WEB*/

      if (archivo == null) {
        return;
      } else {
        _controladorContenido.crearYSubirContenido(
            _tituloContenido,
            _descripcionContenido,
            _catSeleccionada,
            nombreUsuario,
            destino,
            archivo);
      }
    }
  }

  Future obtenerArchivo() async {
    /*
    Si al obtenerArchivo tengo algo cargado,
    lo saco
     */
    setState(() {
      archivo = null;
      this._url = null;
    });

    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']); //te permite cargar pdf

    if (kIsWeb) {
      if (result.files.first != null) {
        var fileBytes = result.files.first.bytes;
        var fileName = result.files.first.name;
        final blob = html.Blob([fileBytes]);
        this._url = html.Url.createObjectUrlFromBlob(blob);
        html.File file = html.File(fileBytes, fileName);
        await _getHtmlFileContent(file);
      }
    } else {
      if (result != null) {
        File file = File(result.files.single.path);
        if (file != null) {
          setState(() {
            archivo = file;
          });
        }
      }
    }
  }

  Future<Uint8List> _getHtmlFileContent(html.File blob) async {
    final reader = html.FileReader();
    reader.readAsDataUrl(blob.slice(0, blob.size, blob.type));
    reader.onLoadEnd.listen((event) {
      Uint8List data =
          Base64Decoder().convert(reader.result.toString().split(",").last);
      fileWeb = data;
    }).onData((data) {
      fileWeb =
          Base64Decoder().convert(reader.result.toString().split(",").last);
      return fileWeb;
    });
    while (fileWeb == null) {
      await new Future.delayed(const Duration(milliseconds: 1));
      if (fileWeb != null) {
        break;
      }
    }
    setState(() {
      archivo = File.fromRawPath(fileWeb);
    });
    return fileWeb;
  }
}
