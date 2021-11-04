import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/pantallas/Noticias/Noticias.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';


class AltaNoticias extends StatefulWidget {
  const AltaNoticias({Key key}) : super(key: key);

  @override
  _AltaNoticiasState createState() => _AltaNoticiasState();
}

class _AltaNoticiasState extends State<AltaNoticias> {

  TextEditingController _textEditingController = new TextEditingController();

  final formKey = new GlobalKey<FormState>();

  List _tipo = [ 'CHARLAS', 'LLAMADOS' ];

  String _usuarioUID = FirebaseAuth.instance.currentUser.uid;

  dynamic _tipoSeleccionado;
  UploadTask uploadTask;

  ControladorNoticia _controladorNoticia = new ControladorNoticia();
  ControladorUsuario _controladorUsuario = new ControladorUsuario();
  String _tituloNoticia;
  String _descripcionNoticia;
  String _linkNoticia;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text("ALTA DE NOTICIAS",
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
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            items: _tipo,
                            onChanged: (value) {
                              setState(() {
                                _tipoSeleccionado = value;
                              });
                            },
                            validator: ((value) =>
                            value == null ? 'El tipo es requerid0' : null),
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: Icon(Icons.arrow_drop_down,
                                color: Colores().colorSombraBotones),
                            showClearButton: true,
                            mode: Mode.DIALOG,
                            searchBoxDecoration: InputDecoration(
                              focusColor: Colores().colorSombraBotones,
                            ),
                            dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 12,
                                    color: Colores().colorSombraBotones),
                                hintText: "TIPO",
                                prefixIcon: Icon(Icons.account_tree_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TITULO',
                          icon: Icon(Icons.title),
                          valor: (value) {
                            this._tituloNoticia = value;
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'El título es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCION',
                          icon: Icon(Icons.description),
                          valor: (value) {
                            this._descripcionNoticia = value;
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'La descripción es requerida' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'Link',
                          icon: Icon(Icons.link),
                          valor: (value) {
                            if(value.contains('https')){
                              this._linkNoticia = value;
                            }else{
                              this._linkNoticia = 'https://$value';
                            }

                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'El link es requerido' : null),
                        ),
                        SizedBox(height: 20.0),

                        Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (Validar().camposVacios(formKey)) {

                                crearNoticia(
                                    _tipoSeleccionado,
                                    _tituloNoticia,
                                    _descripcionNoticia,
                                    _linkNoticia,
                                ).catchError((e){
                                  ErrorHandler().errorDialog(e, context);
                                });

                                showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogoAlerta(
                                        tituloMensaje: "Alta de Noticia",
                                        mensaje:
                                        "La noticia ha sido creada correctamente",
                                        onPressed: () {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    Noticias()),
                                            ModalRoute.withName('/'),
                                          );
                                        },
                                      );
                                    });

                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog_validarAltaContenido();
                                    });
                              }
                            }
                        ),

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

  Future crearNoticia(String tipo, String titulo, String descripcion, String link) async {
    String usuarioAlta = await _controladorUsuario.obtenerNombreUsuario(_usuarioUID);
    ControladorNoticia().crearNoticia(tipo, titulo, descripcion, link, usuarioAlta);
  }



}
