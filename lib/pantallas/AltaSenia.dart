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
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:universal_html/html.dart' as html;

class AltaSenia extends StatefulWidget {
  @override
  _AltaSeniaState createState() => _AltaSeniaState();
}

class _AltaSeniaState extends State<AltaSenia> {
  ControladorSenia _controladorSenia = new ControladorSenia();
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  String _nombreSenia;
  String _descripcionSenia;
  File archivoDeVideo;
  String _url;
  Uint8List fileWeb;
  final formKey = new GlobalKey<FormState>();
  String _usuarioUID = FirebaseAuth.instance.currentUser.uid;

  List list;
  dynamic _catSeleccionada;
  UploadTask uploadTask;

  @override
  void initState() {
    listarCateogiras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'ALTA DE SEÑA',
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                        SizedBox(height: 20.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: archivoDeVideo == null && this._url == null
                              ? Icon(Icons.video_library_outlined,
                                  color: Colores().colorTextos, size: 150)
                              : (kIsWeb
                                  ? SeleccionadorVideo(null, _url)
                                  : SeleccionadorVideo(archivoDeVideo, null)),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'NOMBRE',
                          icon: Icon(Iconos.hand),
                          valor: (value) {
                            this._nombreSenia = value;
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'El nombre es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCION',
                          icon: Icon(Icons.description),
                          valor: (value) {
                            this._descripcionSenia = value;
                          },
                        ),
                        SizedBox(height: 15.0),
                        // Menu desplegable de Categorias
                        DropdownSearch(
                          items: list,
                          onChanged: (value) {
                            setState(() {
                              _catSeleccionada = value;
                            });
                          },
                          showSearchBox: true,
                          clearButton: Icon(Icons.close,
                              color: Colores().colorSombraBotones),
                          dropDownButton: Icon(Icons.arrow_drop_down,
                              color: Colores().colorSombraBotones),
                          showClearButton: true,
                          mode: Mode.DIALOG,
                          hint: "CATEGORIAS",
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
                        Boton(
                          titulo: 'SELECCIONAR ARCHIVO',
                          onTap: obtenerVideo,
                        ),
                        Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (Validar().camposVacios(formKey) &&
                                  /*verifico que el archivo de video no sea null dependiendo
                                  si estoy en la web
                                   */
                                  (kIsWeb
                                      ? fileWeb != null
                                      : archivoDeVideo != null) &&
                                  _catSeleccionada != null) {
                                guardarSenia()
                                  ..then((userCreds) {
                                    /*
                                    Luego de guardar la seña,
                                    creo un dialogo de alerta indicando que se
                                    guardo de forma ok
                                     */
                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (BuildContext contexto) {
                                          return AlertDialog(
                                            title: Text('Alta de Seña'),
                                            content: Text(
                                                'La seña ha sido guardada correctamente'),
                                            actions: [
                                              TextButton(
                                                  child: Text('Ok',
                                                      style: TextStyle(
                                                          color: Colores()
                                                              .colorAzul,
                                                          fontFamily: 'Trueno',
                                                          fontSize: 11.0,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline)),
                                                  onPressed: () {
                                                    /*Al presionar Ok, cierro la el dialogo y cierro la
                                                   ventana de alta seña

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
                            }),
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


  Future guardarSenia() async {
    String urlVideo;
    final destino = 'Videos/$_nombreSenia';
    String nombreUsuario =
        await _controladorUsuario.obtenerNombreUsuario(_usuarioUID);

    /*
    ESTOY EN LA WEB
     */
    if (kIsWeb) {
      if (fileWeb == null) {
        return;
      } else {
        /*
      GUARDO EL VIDEO WEB

      Si la plataforma es web, guardo el video en bytes,
      ya que es el tipo de archivo que se puede reproducir
      con el widget de reproductor de video.
       */
        _controladorSenia.crearYSubirSeniaBytes(_nombreSenia, _descripcionSenia,
            _catSeleccionada, nombreUsuario, destino, fileWeb);
      }
    } else {
      /*
      NO ESTOY EN LA WEB
       */
      if (archivoDeVideo == null) {
        return;
      } else {

        _controladorSenia.crearYSubirSenia(_nombreSenia, _descripcionSenia,
            _catSeleccionada, nombreUsuario, destino, archivoDeVideo);
      }
    }

    /*
    TERMINO DE SUBIR LOS ARCHIVOS Y GUARDO LA SENIA
    ESTO ES INDEPENDIENTE DE LA PLATAFORMA
     */
  }

  void obtenerVideo() async {
    /*
    Si al obtenerVideo, tengo algo cargado
    lo saco
     */
    setState(() {
        archivoDeVideo = null;
        this._url = null;
    });

    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (kIsWeb) {
      if (result.files.first != null) {
        var fileBytes = result.files.first.bytes;
        var fileName = result.files.first.name;
        final blob = html.Blob([fileBytes]);
        this._url = html.Url.createObjectUrlFromBlob(blob);
        html.File file = html.File(fileBytes, fileName);
        //metodo que hace que el video web se pueda reproducir
        await _getHtmlFileContent(file);
      }
    } else {
      if (result != null) {
        File file = File(result.files.single.path);
        if (file != null) {
          setState(() {
            archivoDeVideo = file;
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
      archivoDeVideo = File.fromRawPath(fileWeb);
    });
    return fileWeb;
  }

  Future<void> listarCateogiras() async {
    list = await ControladorCategoria().listarCategorias();
  }
}
