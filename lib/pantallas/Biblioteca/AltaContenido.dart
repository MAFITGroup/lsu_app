import 'dart:async';
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
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:path/path.dart' as p;

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
  String _autorContenido;
  File archivo;
  String _url;
  String fileExtension;
  Uint8List fileWeb;
  final formKey = new GlobalKey<FormState>();
  String _usuarioUID = FirebaseAuth.instance.currentUser.uid;
  dynamic _catSeleccionada;
  UploadTask uploadTask;
  String archivoNombre = 'Seleccione un archivo pdf';

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
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TÍTULO',
                          icon: Icon(Icons.format_size_outlined),
                          valor: (value) {
                            this._tituloContenido = value;
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          valor: (value) {
                            this._descripcionContenido = value;
                          },
                          validacion: ((value) => value.isEmpty
                              ? 'Campo Obligatorio'
                              : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'AUTOR',
                          icon: Icon(Icons.person_outline_sharp),
                          valor: (value) {
                            this._autorContenido = value;
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
                            onChanged: (value) {
                              setState(() {
                                _catSeleccionada = value;
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
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Boton(
                          titulo: 'SELECCIONAR ARCHIVO',
                          onTap: () {
                            obtenerArchivo();
                          },
                        ),
                        SizedBox(height: 5.0),
                        Text(archivoNombre,
                            style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                            )),
                        SizedBox(height: 5.0),
                        Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (kIsWeb ? fileWeb == null : archivo == null) {
                                return showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return DialogoAlerta(
                                        tituloMensaje: "Advertencia",
                                        mensaje:
                                            "No ha seleccionado un archivo.",
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
                              if (Validar().camposVacios(formKey) &&
                                  /*verifico que el archivo no sea null dependiendo
                                  si estoy en la web
                                   */
                                  (kIsWeb
                                      ? fileWeb != null
                                      : archivo != null) &&
                                  _catSeleccionada != null &&
                                  verificarFormato(fileExtension)) {
                                guardarContenido().then((userCreds) {
                                  showCupertinoDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (BuildContext contextR) {
                                        return DialogoAlerta(
                                          tituloMensaje: 'Alta de Contenido',
                                          mensaje:
                                              'El contenido ha sido guardado correctamente \n El mismo podrá tardar unos minutos en visualizarse.',
                                          acciones: [
                                            TextButton(
                                                child: Text('OK',
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

  Future guardarContenido() async {
    String docID = new UniqueKey().toString();
    final destino = 'Biblioteca/$docID';
    String nombreUsuario =
        await _controladorUsuario.obtenerNombreUsuario(_usuarioUID);

    /*ESTOY EN LA WEB*/

    if (kIsWeb) {
      if (fileWeb == null) {
        return;
      } else {
        /*GUARDA EL ARCHIVO WEB WEB

      Si la plataforma es web, guarda el archivo en byte.*/

        _controladorContenido.crearYSubirContenidoWeb(
            docID,
            _tituloContenido,
            _descripcionContenido,
            _autorContenido,
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
            docID,
            _tituloContenido,
            _descripcionContenido,
            _autorContenido,
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
    if (result == null) return;

    if (kIsWeb) {
      if (result.files.first != null) {
        var fileBytes = result.files.first.bytes;
        var fileName = result.files.first.name;
        //guardo fileWeb como bytes.
        fileWeb = fileBytes;

        if (fileName != null) {
          archivoNombre = p.basename(fileName);
          fileExtension = p.extension(fileName);
          verificarFormato(fileExtension);
        }
      }
    } else {
      if (result != null) {
        File file = File(result.files.single.path);
        if (file != null) {
          setState(() {
            if (file.path != null) {
              fileExtension = p.extension(file.path);
              archivoNombre = p.basename(file.path);
              if (verificarFormato(fileExtension)) {
                archivo = file;
                setState(() {
                  archivoNombre;
                });
              }
            }
          });
        }
      }
    }
  }

  bool verificarFormato(String fileExtension) {
    /*
    Chequeo extensiones para verificar que el archivo que me suban no sea de otro formato.
     */
    if (fileExtension != ".pdf") {
      showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return DialogoAlerta(
              tituloMensaje: "Formato Incorrecto",
              mensaje: "El formato del archivo seleccionado no es correcto."
                  "\nEl formato debe ser: pdf",
              acciones: [
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    setState(() {
                      archivoNombre = 'Seleccione un archivo en formato pdf';
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      archivo = null;
      this._url = null;
      return false;
    } else {
      return true;
    }
  }
}
