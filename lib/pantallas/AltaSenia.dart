import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:universal_html/html.dart' as html;

class AltaSenia extends StatefulWidget {
  @override
  _AltaSeniaState createState() => _AltaSeniaState();
}

class _AltaSeniaState extends State<AltaSenia> {
  String _nombreSenia;
  File archivoDeVideo;
  String _url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'ALTA DE SEÑA',
              iconoBtnUno: null,
              onPressedBtnUno: null,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
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
                      SizedBox(height: 50.0),
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: 'NOMBRE DE LA SEÑA',
                              labelStyle: TextStyle(
                                  fontFamily: 'Trueno',
                                  fontSize: 12.0,
                                  color: Colors.grey.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colores().colorTextos),
                              )),
                          onChanged: (value) {
                            this._nombreSenia = value;
                          }),
                      SizedBox(height: 20.0),
                      SeleccionadorCategorias(),
                      SizedBox(height: 20.0),
                      Boton(
                        titulo: 'SELECCIONAR ARCHIVO',
                        onTap: obtenerVideo,
                      ),
                      SizedBox(height: 20.0),
                      Boton(
                        titulo: 'GUARDAR',
                        onTap: () {},
                      ),
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

  Future<Uint8List> _getHtmlFileContent(html.File blob) async {
    Uint8List file;
    final reader = html.FileReader();
    reader.readAsDataUrl(blob.slice(0, blob.size, blob.type));
    reader.onLoadEnd.listen((event) {
      Uint8List data =
          Base64Decoder().convert(reader.result.toString().split(",").last);
      file = data;
    }).onData((data) {
      file = Base64Decoder().convert(reader.result.toString().split(",").last);
      return file;
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

  void obtenerVideo() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.video);

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
            archivoDeVideo = file;
          });
        }
      }
    }
  }
}

class SeleccionadorCategorias extends StatefulWidget {
  @override
  _SeleccionadorCategorias createState() => _SeleccionadorCategorias();
}

class _SeleccionadorCategorias extends State<SeleccionadorCategorias> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String country_id;
  List<String> country = [
    "America",
    "Brazil",
    "Canada",
    "India",
    "Mongalia",
    "USA",
    "China",
    "Russia",
    "Germany"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        DropdownSearch(
          showSearchBox: true,
          clearButton: Icon(Icons.close, color: Colors.blue),
          dropDownButton: Icon(Icons.arrow_drop_down, color: Colors.blue),
          showClearButton: true,
          mode: Mode.BOTTOM_SHEET,
          showSelectedItem: true,
          items: country,
          hint: "Categorias",
          autoFocusSearchBox: true,
          searchBoxDecoration: InputDecoration(
            focusColor: Colors.blue,
          ),
          dropdownSearchDecoration: InputDecoration(
            focusColor: Colors.blue,
          ),
        ),
      ]),
    );
  }
}
