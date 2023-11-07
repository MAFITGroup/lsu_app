import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Noticia.dart';
import 'package:lsu_app/pantallas/Login/PaginaInicial.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/RedesBotones.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:url_launcher/url_launcher.dart';


enum RedesSociales { facebook, twitter, email, whatsapp }

class VisualizarNoticia extends StatefulWidget {
  final Noticia ?noticia;
  final bool ?isUsuarioAdmin;

  const VisualizarNoticia(
      {Key ?key,
      this.noticia,
      this.isUsuarioAdmin})
      : super(key: key);

  @override
  _VisualizarNoticiaState createState() => _VisualizarNoticiaState();
}

class _VisualizarNoticiaState extends State<VisualizarNoticia> {
  List _tipo = ['CHARLAS', 'LLAMADOS'];

  bool ?modoEditar;

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
    Noticia? noticia = widget.noticia;
    bool? isUsuarioAdmin = widget.isUsuarioAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
                titulo: Text(
                  'NOTICIA' + '-' + noticia!.titulo.toUpperCase(),
                  // AGREGRAR NOMBRE DE LA NOTICIA
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14),
                ),
                listaWidget: isUsuarioAdmin!
                    ? [
                        PopupMenuButton<int>(
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 0,
                                child: ListTile(
                                    leading: Icon(
                                        !modoEditar!
                                            ? Icons.edit
                                            : Icons.cancel_outlined,
                                        color: Colores().colorAzul),
                                    title: Text(
                                        !modoEditar!
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
                            enabled: modoEditar!,
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
                          ),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'TÍTULO',
                          icon: Icon(Icons.format_size_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar!
                              ? null
                              : TextEditingController(text: noticia.titulo),
                          valor: (value) {
                            tituloNoticiaNuevo = value;
                          },
                          validacion: ((value) =>
                              value!.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'LINK',
                          icon: Icon(Icons.link),
                          habilitado: modoEditar,
                          controlador: modoEditar!
                              ? null
                              : TextEditingController(text: noticia.link),
                          valor: (value) {
                            if (value!.contains('https')) {
                              linkNoticiaNueva = value;
                            } else {
                              linkNoticiaNueva = 'https://$value';
                            }
                          },
                          validacion: ((value) =>
                              value!.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          habilitado: modoEditar,
                          controlador: modoEditar!
                              ? null
                              : TextEditingController(
                                  text: noticia.descripcion),
                          valor: (value) {
                            descripcionNoticiaNueva = value;
                          },
                          /*
                          validacion: ((value) => value.isEmpty
                              ? 'La descripción es requerida'
                              : null),

                           */
                        ),
                        !modoEditar! ? SocialMediaBotones() : Container(),
                        !modoEditar!
                            ? Boton(
                                titulo: 'NAVEGAR AL SITIO',
                                onTap: () {
                                  String link = noticia.link;
                                  if (link != null) {
                                    navegarALink(link, context);
                                  } else {
                                    DialogoAlerta(
                                      tituloMensaje: 'Navegación',
                                      mensaje:
                                          'La noticia no tiene un link asociado.',
                                      acciones: [
                                        TextButton(
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: Colores().colorAzul,
                                                  fontFamily: 'Trueno',
                                                  fontSize: 11.0,
                                                  decoration: TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
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
                                  if (Validar().camposVacios(formKey)) {
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
                                              return DialogoAlerta(
                                                tituloMensaje: 'Edición de Noticia',
                                                mensaje:
                                                    'Los datos han sido guardados correctamente',
                                                acciones: [
                                                  TextButton(
                                                    child: Text('OK',
                                                        style: TextStyle(
                                                            color: Colores()
                                                                .colorAzul,
                                                            fontFamily:
                                                            'Trueno',
                                                            fontSize: 11.0,
                                                            decoration:
                                                            TextDecoration
                                                                .underline)),
                                                    onPressed: () {
                                                      // cierro dialogo
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => PaginaInicial()),
                                                            (Route<dynamic> route) => false,
                                                      );
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      });
                                  }
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
    String titulo = widget.noticia!.titulo;
    String tipo = widget.noticia!.tipo;
    String descripcion = widget.noticia!.descripcion;
    String link = widget.noticia!.link;

    switch (item) {
      case 0:
        !modoEditar! ? editarNoticia() : canelarEditar();
        break;
      case 1:
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return DialogoAlerta(
                tituloMensaje: 'Eliminación de Noticia',
                mensaje: '¿Está seguro que desea eliminar la noticia?',
                acciones: [
                  TextButton(
                      child: Text('OK',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        eliminarNoticia(tipo, titulo, descripcion, link)
                          ..then((userCreds) {
                            /*
                                    Luego de eliminar la seña,
                                    creo un dialogo de alerta indicando que se
                                    elimino de forma ok
                                     */
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogoAlerta(
                                    tituloMensaje: 'Eliminación de Noticia',
                                    mensaje:
                                        'La noticia ha sido eliminada correctamente',
                                    acciones: [
                                      TextButton(
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: Colores().colorAzul,
                                                  fontFamily: 'Trueno',
                                                  fontSize: 11.0,
                                                  decoration: TextDecoration
                                                      .underline)),
                                          onPressed: () {
                                            /*Al presionar Ok, cierro la el dialogo y cierro la
                                                   ventana de visualizacion seña

                                                     */
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => PaginaInicial()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          })
                                    ],
                                  );
                                });
                            //TODO mensaje si falla.
                          }).catchError((e) {
                            ErrorHandler().errorDialog(context, e);
                          });
                      }),
                  TextButton(
                      child: Text('CANCELAR',
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
    }
  }

  Widget SocialMediaBotones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RedesBotones(
          icon: FontAwesomeIcons.facebook,
          onTap: () => compartir(RedesSociales.facebook, widget.noticia!.titulo,
              widget.noticia!.link),
        ),
        RedesBotones(
          icon: FontAwesomeIcons.twitter,
          onTap: () => compartir(RedesSociales.twitter, widget.noticia!.titulo,
              widget.noticia!.link),
        ),
        RedesBotones(
          icon: FontAwesomeIcons.whatsapp,
          onTap: () => compartir(RedesSociales.whatsapp, widget.noticia!.titulo,
              widget.noticia!.link),
        ),
        RedesBotones(
          icon: Icons.email,
          onTap: () => compartir(
              RedesSociales.email, widget.noticia!.titulo, widget.noticia!.link),
        ),
      ],
    );
  }

  Future compartir(
      RedesSociales redes, String tituloNoticia, String linkNoticia) async {
    final asunto = 'Plataforma LSU';
    final texto = 'Noticia publicada en Plataforma LSU. ' +
        tituloNoticia +
        ' ¡No te la pierdas! ';
    final urlCompartir = Uri.encodeComponent(linkNoticia);

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

    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw AlertDialog().title!;
    }
  }

  lanzarLink(String link) async {
    String url = link;
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: '_blank');
    } else {
      throw AlertDialog().title!;
    }
  }

  Future navegarALink(String link, BuildContext context) {
   return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return DialogoAlerta(
            tituloMensaje: 'Navegar al sitio',
            mensaje:
                'Está a punto de visitar un sitio web fuera de la aplicación.'
                '\n¿Desea continuar?',
            acciones: [
              TextButton(
                  child: Text('OK',
                      style: TextStyle(
                          color: Colores().colorAzul,
                          fontFamily: 'Trueno',
                          fontSize: 11.0,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    lanzarLink(link);
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text('CANCELAR',
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
