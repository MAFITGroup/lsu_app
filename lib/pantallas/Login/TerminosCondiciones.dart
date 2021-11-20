import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TerminosCondiciones extends StatelessWidget {
  const TerminosCondiciones({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title: Text('TÉRMINOS Y CONDICIONES',
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
        ),
        body: Container(
            child: SfPdfViewer.asset(
                'recursos/TerminosCondicionesDeUsoPlataformaLSU.pdf',
                pageSpacing: 2)));
  }
}
