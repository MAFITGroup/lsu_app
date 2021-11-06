import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:path/path.dart' as p;
import 'package:universal_html/html.dart' as html;

class AltaSenia extends StatefulWidget {
  final List listaCategorias;

  const AltaSenia({Key key, this.listaCategorias}) : super(key: key);

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
  String fileExtension;
  FirebaseFirestore firestore;
  List listaCategorias;
  List<dynamic> listaSubCategorias;
  dynamic _catSeleccionada;
  dynamic _subCatSeleccionada;
  UploadTask uploadTask;
  CollectionReference categoriasRef;

  @override
  void initState() {
    listarCateogiras();
    listarSubCateogiras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text("ALTA DE SEÑA",
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
                        SizedBox(height: 8.0),
                        TextFieldTexto(
                          nombre: 'NOMBRE',
                          icon: Icon(Iconos.hand),
                          valor: (value) {
                            this._nombreSenia = value;
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'El nombre es requerido' : null),
                        ),
                        SizedBox(height: 8.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCION',
                          icon: Icon(Icons.description),
                          valor: (value) {
                            this._descripcionSenia = value;
                          },
                          //No es necesario escribir una descripcion
                          /* validacion: ((value) => value.isEmpty
                              ? 'La descripcion es requerida'
                              : null),

                          */
                        ),
                        // CATEGORIA
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: listaCategorias,
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
                            searchBoxDecoration: InputDecoration(
                              focusColor: Colores().colorSombraBotones,
                              hintText: "Buscar",
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
                            validator: (dynamic valor) {
                              if (valor == null) {
                                return "La categoria es requerida";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        // SUB CATEGORIA
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: listaSubCategorias,
                            onChanged: (value) {
                              setState(() {
                                _subCatSeleccionada = value;
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
                                hintText: "SUB CATEGORIA",
                                prefixIcon: Icon(Icons.account_tree_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                            /*  validator: (dynamic valor) {
                              if (valor == null) {
                                return "La sub categoria es requerida";
                              } else {
                                return null;
                              }
                            },
                           */
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Boton(
                          titulo: 'SELECCIONAR ARCHIVO',
                          onTap: obtenerVideo,
                        ),
                        Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (kIsWeb
                                  ? fileWeb == null
                                  : archivoDeVideo == null) {
                                return showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return DialogoAlerta(
                                        tituloMensaje: "Advertencia",
                                        mensaje: "No ha seleccionado un archivo.",
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    });
                              }
                              if (Validar().camposVacios(formKey) &&
                                  /*verifico que el archivo de video no sea null dependiendo
                                  si estoy en la web
                                   */
                                  (kIsWeb
                                      ? fileWeb != null
                                      : archivoDeVideo != null) &&
                                  _catSeleccionada != null) {
                                guardarSenia().then((userCreds) {
                                  /*
                                    Luego de guardar la seña,
                                    creo un dialogo de alerta indicando que se
                                    guardo de forma ok
                                     */
                                  showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (BuildContext contextR) {
                                        return AlertDialog(
                                          title: Text('Alta de Seña'),
                                          content: Text(
                                              'La seña ha sido guardada correctamente'),
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

    if (result == null) return;

    if (kIsWeb) {
      if (result.files.first != null) {
        var fileBytes = result.files.first.bytes;
        var fileName = result.files.first.name;
        final blob = html.Blob([fileBytes]);
        //guardo fileWeb como bytes.
       fileWeb = fileBytes;

        // con esta URL reproduzco el video en la web
        this._url = html.Url.createObjectUrlFromBlob(blob);
        html.File file = html.File(fileBytes, fileName);

        if (fileName != null) {
          fileExtension = p.extension(fileName);
          if (verificarFormatoVideo(fileExtension)) {
            //metodo que hace que se pueda reproducir el video a traves de la URL
            //tambien ya con esa url guardo seteo la variable del archivo.
            await _getHtmlFileContent(file);
          }
        }
      }
    } else {
      if (result != null) {
        File file = File(result.files.single.path);
        if (file != null) {
          setState(() {
            if (file.path != null) {
              fileExtension = p.extension(file.path);
              if (verificarFormatoVideo(fileExtension)) {
                archivoDeVideo = file;
              }
            }
          });
        }
      }
    }
  }

  Future<Uint8List> _getHtmlFileContent(html.File blob) async {
    Uint8List file;
    final reader = html.FileReader();
    reader.readAsDataUrl(blob.slice(0, blob.size, blob.type));
    reader.onLoadEnd.listen((event) {
      Uint8List data =
          Base64Decoder().convert(reader.result.toString().split(",").last);
      file = data;
    });

    while (file == null) {
      await new Future.delayed(const Duration(milliseconds: 1));
      if (file != null) {
        break;
      }
    }
    setState(() {
      archivoDeVideo = File.fromRawPath(file);
    });
    return file;
  }

  bool verificarFormatoVideo(String fileExtension) {
    /*
    Chequeo extensiones para verificar que el archivo que me suban no sea de otro formato.
     */
    if (fileExtension != ".mp4" &&
        fileExtension != ".avi" &&
        fileExtension != ".wmv" &&
        fileExtension != ".mov") {
      showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return DialogoAlerta(
              tituloMensaje: "Formato Incorrecto",
              mensaje: "El formato del archivo seleccionado no es correcto."
                  "\nEl formato debe ser: mp4, avi, wmv, mov.",
              onPressed: () {
                Navigator.of(context).pop();
                archivoDeVideo = null;
                this._url = null;
              },
            );
          });
      return false;
    } else {
      return true;
    }
  }

  void listarCateogiras() async {
    listaCategorias = widget.listaCategorias;
  }

  Future<void> listarSubCateogiras() async {
    listaSubCategorias = await ControladorCategoria()
        .listarSubCategoriasxCategoria("CATEGORIA SUB");
  }
}
