import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VisualizarPDF extends StatefulWidget {
  final String ?archivoRef;
  final String ?titulo;

  const VisualizarPDF({Key? key, this.archivoRef, this.titulo})
      : super(key: key);

  @override
  _VisualizarPDFState createState() => _VisualizarPDFState();
}

class _VisualizarPDFState extends State<VisualizarPDF> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light),
        backgroundColor: Colores().colorAzul,
        title: Text('ARCHIVO - ' + widget.titulo!.toUpperCase(),
            style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
      ),
      body: Container(
          child: SfPdfViewer.network(widget.archivoRef!, pageSpacing: 2)),
    );
  }
}
