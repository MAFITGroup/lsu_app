import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class visualizarPDF extends StatefulWidget {
  final String archivoRef;
  final String titulo;

  const visualizarPDF({Key key, this.archivoRef, this.titulo})
      : super(key: key);

  @override
  _visualizarPDFState createState() => _visualizarPDFState();
}

class _visualizarPDFState extends State<visualizarPDF> {
  PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          child: SfPdfViewer.network(widget.archivoRef, pageSpacing: 2)),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light),
        backgroundColor: Colores().colorAzul,
        title: Text('ARCHIVO - ' + widget.titulo.toUpperCase(),
            style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _pdfViewerController.zoomLevel = 1.25;
              },
              icon: Icon(
                Icons.zoom_in,
                color: Colors.white,
              ))
        ],
      ),
    ));
  }
}
