
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorContenido.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Contenido.dart';
import 'package:lsu_app/pantallas/Biblioteca/VisualizarContenido.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';

class VisualizarPDF extends StatefulWidget {
  final String archivoRef;
  final String titulo;

  const VisualizarPDF({ this.archivoRef, this.titulo });

  @override
  _VisualizarPDFState createState() => _VisualizarPDFState();
}

class _VisualizarPDFState extends State<VisualizarPDF> {
  static final int _initialPage = 2;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;
  String pdfPath;

  @override
  void initState() {
    loadFirebase();
    _pdfController = PdfController(
      document: PdfDocument.openFile(pdfPath),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(primaryColor: Colors.white),
    home: Scaffold(
      appBar: AppBar(
        title: Text('PdfView example'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (isSampleDoc) {
                _pdfController.loadDocument(
                    PdfDocument.openFile(pdfPath));
              } else {
                _pdfController.loadDocument(
                    PdfDocument.openFile(pdfPath));
              }
              isSampleDoc = !isSampleDoc;
            },
          )
        ],
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
    ),
  );

  Future<String> loadFirebase() async{
    final refPDF = FirebaseStorage.instance.ref().child('Biblioteca').child('Prueba2');
    final bytes = await refPDF.getData();

    return _storeFile('sample.pdf', bytes);
  }





  Future<String> _storeFile(String url, List<int> bytes) async {
    final filename = url;
    final dir = await getApplicationDocumentsDirectory();
    //${dir.path}
    String path = './recursos/$filename';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

}
