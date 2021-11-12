import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManualDeUsuario extends StatefulWidget {

  @override
  _ManualDeUsuarioState createState() => _ManualDeUsuarioState();
}

class _ManualDeUsuarioState extends State<ManualDeUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title:Text('MANUAL DE USUARIO',
              style:TextStyle( fontFamily:'Trueno', fontSize: 14)),
        ),
        body: Container(
            child: SfPdfViewer.asset('recursos/ManualUsuarioLSUApp.pdf',
                pageSpacing: 2)));
  }


}


