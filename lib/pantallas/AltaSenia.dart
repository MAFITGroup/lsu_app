import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';

class AltaSenia extends StatefulWidget {
  @override
  _AltaSeniaState createState() => _AltaSeniaState();
}

class _AltaSeniaState extends State<AltaSenia> {
  Color _colorAzul = Colors.blue;
  String _nombreSenia;
  File archivoDeVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Container(
                    child: archivoDeVideo == null
                        ? Icon(Icons.video_library_outlined,
                            color: _colorAzul, size: 180)
                        : SeleccionadorVideo(archivoDeVideo),
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
                            borderSide: BorderSide(color: _colorAzul),
                          )),
                      onChanged: (value) {
                        this._nombreSenia = value;
                      }),
                  SizedBox(height: 20.0),
                  SeleccionadorCategorias(),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: obtenerVideo,
                    child: Container(
                        height: 50.0,
                        width: 600,
                        child: Material(
                            borderRadius: BorderRadius.circular(25.0),
                            shadowColor: Colors.blueAccent,
                            color: _colorAzul,
                            elevation: 7.0,
                            child: Center(
                                child: Text('SELECCIONAR ARCHIVO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Trueno'))))),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                        height: 50.0,
                        width: 600,
                        child: Material(
                            borderRadius: BorderRadius.circular(25.0),
                            shadowColor: Colors.blueAccent,
                            color: _colorAzul,
                            elevation: 7.0,
                            child: Center(
                                child: Text('GUARDAR',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Trueno'))))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future obtenerVideo() async {
    final media = await ImagePicker().pickVideo(source: ImageSource.gallery);
    final file = File(media.path);
    setState(() {
      archivoDeVideo = file;
    });
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
