import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/SeleccionadorCategorias.dart';
import 'package:lsu_app/widgets/SeleccionadorVideo.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarSenia extends StatefulWidget {
  final Senia senia;
  final File file;

  const VisualizarSenia({Key key, this.senia, this.file}) : super(key: key);

  @override
  _VisualizarSeniaState createState() => _VisualizarSeniaState();
}

class _VisualizarSeniaState extends State<VisualizarSenia> {
  String _nombreSenia;
  String _descripcionSenia;
  File archivoDeVideo;
  String _url;
  Uint8List fileWeb;
  List list;
  dynamic _catSeleccionada;

  @override
  Widget build(BuildContext context) {
    Senia senia = widget.senia;
    archivoDeVideo = widget.file;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'SEÑA' + " - " + senia.nombre.toUpperCase(),
              iconoBtnUno: Icon(Icons.adaptive.more),
              onPressedBtnUno: () {},
            ),
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
              botonHabilitado: false,
              textoSeteado: TextEditingController(text: senia.nombre),
            ),
            SizedBox(height: 15.0),
            TextFieldDescripcion(
              nombre: 'DESCRIPCION',
              icon: Icon(Icons.description),
              botonHabilitado: false,
              textoSeteado: TextEditingController(text: senia.descripcion),
            ),
            SizedBox(height: 15.0),
            // Menu desplegable de Categorias
            SeleccionadorCategorias(
                list, "DESCRIPCION", senia.categoria, false,senia.categoria),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Future<void> listarCateogiras() async {
    list = await ControladorCategoria().listarCategorias();
  }
}
