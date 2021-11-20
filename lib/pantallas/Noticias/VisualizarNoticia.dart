import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Noticia.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/RedesBotones.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Noticias.dart';

enum RedesSociales { facebook, twitter, email, whatsapp }

class VisualizarNoticia extends StatefulWidget {
  final Noticia noticia;
  final String tipo;
  final String titulo;
  final String descripcion;
  final String link;
  final bool isUsuarioAdmin;

  const VisualizarNoticia(
      {Key key,
      this.noticia,
      this.tipo,
      this.titulo,
      this.descripcion,
      this.link,
      this.isUsuarioAdmin})
      : super(key: key);

  @override
  _VisualizarNoticiaState createState() => _VisualizarNoticiaState();
}

class _VisualizarNoticiaState extends State<VisualizarNoticia> {
  List _tipo = ['CHARLAS', 'LLAMADOS'];

  bool modoEditar;

  final formKey = new GlobalKey<FormState>();

  dynamic tipoSeleccionadoNuevo;
  dynamic tituloNoticiaNuevo;
  dynamic descripcionNoticiaNueva;
  dynamic linkNoticiaNueva;

  @override
  void initState() {
    setState(() {
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Noticia noticia = widget.noticia;
    bool isUsuarioAdmin = widget.isUsuarioAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
                titulo: Text(
                  'NOTICIA' + '-' + noticia.titulo.toUpperCase(),
                  // AGREGRAR NOMBRE DE LA NOTICIA
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14),
                ),
                listaWidget: isUsuarioAdmin
                    ? [
                        PopupMenuButton<int>(
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 0,
                                child: ListTile(
                                    leading: Icon(
                                        !modoEditar
                                            ? Icons.edit
                                            : Icons.cancel_outlined,
                                        color: Colores().colorAzul),
                                    title: Text(
                                        !modoEditar
                                            ? "Editar Noticia"
                                            : "Cancelar Editar",
                                        style: TextStyle(
                                            fontFamily: 'Trueno',
                                            fontSize: 14,
                                            color: Colores()
                                                .colorSombraBotones)))),
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                  leading: Icon(Icons.delete_forever_outlined,
                                      color: Colores().colorAzul),
                                  title: Text("Eliminar Noticia",
                                      style: TextStyle(
                                          fontFamily: 'Trueno',
                                          fontSize: 14,
                                          color:
                                              Colores().colorSombraBotones))),
                            )
                          ],
                        ),
                      ]
                    : []),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DropdownSearch(
                            enabled: modoEditar,
                            selectedItem: noticia.tipo,
                            items: _tipo,
                            onChanged: (value) {
                              setState(() {
                                tipoSeleccionadoNuevo = value;
                              });
                            },
                            validator: ((dynamic value) {
                              if (value == null) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            }),
                            showSearchBox: true,
                            clearButton: Icon(Icons.close,
                                color: Colores().colorSombraBotones),
                            dropDownButton: Icon(Icons.arrow_drop_down,
                                color: Colores().colorSombraBotones),
                            showClearButton: true,
                            mode: Mode.DIALOG,
                            dropdownSearchDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 12,
                                    color: Colores().colorSombraBotones),
                                hintText: "TIPO",
                                prefixIcon: Icon(Icons.category_outlined),
                                focusColor: Colores().colorSombraBotones,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colores().colorSombraBotones),
                                )),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TÍTULO',
                          icon: Icon(Icons.format_size_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: noticia.titulo),
                          valor: (value) {
                            tituloNoticiaNuevo = value;
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'El título es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'LINK',
                          icon: Icon(Icons.link),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(text: noticia.link),
                          valor: (value) {
                            if (value.contains('https')) {
                              linkNoticiaNueva = value;
                            } else {
                              linkNoticiaNueva = 'https://$value';
                            }
                          },
                          validacion: ((value) =>
                              value.isEmpty ? 'El link es requerido' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar
                              ? null
                              : TextEditingController(
                                  text: noticia.descripcion),
                          valor: (value) {
                            descripcionNoticiaNueva = value;
                          },
                          validacion: ((value) => value.isEmpty
                              ? 'La descripción es requerida'
                              : null),
                        ),
                        !modoEditar ? SocialMediaBotones() : Container(),
                        !modoEditar
                            ? Boton(
                                titulo: 'NAVEGAR A LINK',
                                onTap: () {
                                  String link = noticia.link;

                                  if (link != null) {
                                    navegarALink(link, context);
                                  } else {
                                    DialogoAlerta(
                                      tituloMensaje: 'Navegación',
                                      mensaje:
                                          'La noticia no tiene un link asociado.',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                                },
                              )
                            : Boton(
                                titulo: 'GUARDAR',
                                onTap: () {
                                  if (tipoSeleccionadoNuevo == null) {
                                    tipoSeleccionadoNuevo = noticia.tipo;
                                  }
                                  if (tituloNoticiaNuevo == null) {
                                    tituloNoticiaNuevo = noticia.titulo;
                                  }
                                  if (descripcionNoticiaNueva == null) {
                                    descripcionNoticiaNueva =
                                        noticia.descripcion;
                                  }
                                  if (linkNoticiaNueva == null) {
                                    linkNoticiaNueva = noticia.link;
                                  }

                                  guardarEdicionNoticia(
                                      noticia.tipo,
                                      noticia.titulo,
                                      noticia.descripcion,
                                      noticia.link,
                                      tipoSeleccionadoNuevo,
                                      tituloNoticiaNuevo,
                                      descripcionNoticiaNueva,
                                      linkNoticiaNueva)
                                    ..then((userCreds) {
                                      showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Editar Noticia'),
                                              content: Text(
                                                  'Los datos han sido guardados correctamente'),
                                              actions: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navegacion(context)
                                                        .navegarANoticiasDest();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    });
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void editarNoticia() {
    setState(() {
      modoEditar = true;
    });
  }

  void canelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  void onSelected(BuildContext context, int item) {
    String titulo = widget.titulo;
    String tipo = widget.tipo;
    String descripcion = widget.descripcion;
    String link = widget.link;

    switch (item) {
      case 0:
        !modoEditar ? editarNoticia() : canelarEditar();
        break;
      case 1:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminar noticia'),
                content: Text('¿Desea eliminar la noticia $titulo ?'),
                actions: [
                  TextButton(
                      child: Text('Ok',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        eliminarNoticia(tipo, titulo, descripcion, link);
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return DialogoAlerta(
                                tituloMensaje: "Noticia Eliminada",
                                mensaje:
                                    "La noticia ha sido eliminado correctamente.",
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Noticias()),
                                    ModalRoute.withName('/'),
                                  );
                                },
                              );
                            }).catchError((e) {
                          ErrorHandler().errorDialog(context, e);
                        });
                      }),
                  TextButton(
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
        break;
    }
  }

  Widget SocialMediaBotones() {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RedesBotones(
            icon: FontAwesomeIcons.facebook,
            onTap: () => compartir(RedesSociales.facebook),
          ),
          RedesBotones(
            icon: FontAwesomeIcons.twitter,
            onTap: () => compartir(RedesSociales.twitter),
          ),
          RedesBotones(
            icon: FontAwesomeIcons.whatsapp,
            onTap: () => compartir(RedesSociales.whatsapp),
          ),
          RedesBotones(
            icon: Icons.email,
            onTap: () => compartir(RedesSociales.email),
          ),
        ],
      ),

    );
  }

  Future compartir(RedesSociales redes) async {

    final asunto = 'Plataforma LSU';
    final texto =
        'Nuevas noticias publicadas en Plataforma LSU. ¡No te las pierdas!';
    final urlCompartir = Uri.encodeComponent('https://prueba.com');

    final urls = {
      RedesSociales.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlCompartir&t=$texto',
      RedesSociales.twitter:
          'https://twitter.com/intent/tweet?url=$urlCompartir&text=$texto',
      RedesSociales.whatsapp:
          'https://api.whatsapp.com/send?text=$texto$urlCompartir',
      RedesSociales.email:
          'mailto:?subject=$asunto&body=$texto\n\n$urlCompartir',
    };

    final url = urls[redes];

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw AlertDialog().title;
    }

  }

  lanzarLink(String link) async {
    String url = link;
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, webOnlyWindowName: '_blank');
    } else {
      throw AlertDialog().title;

    }
  }

  Widget navegarALink(String link, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(2.0),
            title: const Text('Navegar al link'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      'Uds está a punto de visitar un sitio web fuera de la app,'),
                  SizedBox(height: 10.0),
                  Text('¿Desea continuar?'),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  Boton(
                    titulo: 'Confirmar',
                    onTap: () {
                      lanzarLink(link);
                      Navigator.of(context).pop();

                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('ATRÁS'))
                ],
              )
            ],
          );
        });
  }

  Future guardarEdicionNoticia(
      String tipoAnterior,
      String tituloAnterior,
      String descripcionAnterior,
      String linkAnterior,
      String tipoNuevo,
      String tituloNuevo,
      String descripcionNueva,
      String linkNuevo) async {
    ControladorNoticia().editarNoticia(
        tipoAnterior,
        tituloAnterior,
        descripcionAnterior,
        linkAnterior,
        tipoNuevo,
        tituloNuevo,
        descripcionNueva,
        linkNuevo);
  }

  Future eliminarNoticia(
      String tipo, String titulo, String descripcion, String link) async {
    ControladorNoticia().eliminarNoticia(tipo, titulo, descripcion, link);
  }

}
