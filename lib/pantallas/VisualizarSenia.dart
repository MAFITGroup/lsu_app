import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Iconos.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
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
  File archivoDeVideo;
  Uint8List fileWeb;
  List listaCategorias;
  bool modoEditar = false;
  ControladorSenia _controladorSenia = new ControladorSenia();


  @override
  void initState() {
    listarCateogiras();
  }

  @override
  Widget build(BuildContext context) {
    Senia senia = widget.senia;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'SEÑA' + " - " + senia.nombre.toUpperCase(),
              listaWidget: [
                PopupMenuButton<int>(
                  /*
              Agregar en el metodo on Selected
              las acciones
               */
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 0,
                        child: Text(!modoEditar ?  "Editar Senia" : "Cancelar Editar"))
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: senia.urlVideo == null
                  ? Icon(Icons.video_library_outlined,
                      color: Colores().colorTextos, size: 150)
                  : SeleccionadorVideo(null, senia.urlVideo),
            ),
            SizedBox(height: 15.0),
            TextFieldTexto(
              nombre: 'NOMBRE',
              icon: Icon(Iconos.hand),
              botonHabilitado: modoEditar,
              textoSeteado: TextEditingController(text: senia.nombre),
              valor: (value) {
                if(modoEditar) {
                  senia.nombre = value;
                }
              },
            ),
            SizedBox(height: 15.0),
            TextFieldDescripcion(
              nombre: 'DESCRIPCION',
              icon: Icon(Icons.description),
              botonHabilitado: modoEditar,
              textoSeteado: TextEditingController(text: senia.descripcion),
              valor: (value) {
                if(modoEditar) {
                  senia.descripcion = value;
                }
              },
            ),
            SizedBox(height: 15.0),
            // Menu desplegable de Categorias
            SeleccionadorCategorias(
                listaCategorias, "DESCRIPCION", senia.categoria, modoEditar, senia.categoria),
            SizedBox(height: 20.0),
            modoEditar ? Boton(
              titulo: 'GUARDAR',
              onTap: (){
                guardarEdicion(senia.nombre,senia.descripcion,senia.categoria);
              }
            ): Container(),
          ],
        ),
      ),
    );
  }

  Future<void> listarCateogiras() async {
    listaCategorias = await ControladorCategoria().listarCategorias();
  }

  void editarSenia() {
    setState(() {
      modoEditar = true;
    });
  }

  void canelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  void guardarEdicion(String nombre, String descripcion, String categoria){
    _controladorSenia.editarSenia(nombre, descripcion, categoria);
  }

  void onSelected(BuildContext context, int item) {
    switch(item){
      case 0:
       !modoEditar ? editarSenia() : canelarEditar();
        break;
    }
  }

}
