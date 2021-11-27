import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
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
  final formKey = new GlobalKey<FormState>();

  List _tipo = ['CHARLAS', 'LLAMADOS'];

  dynamic _tipoSeleccionado;

  String _tituloNoticia;
  String _descripcionNoticia;
  String _linkNoticia;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel id', 'channel notifications',
      description: 'channel description',
      importance: Importance.max,
      playSound: true);

  @override
  void initState() {
    super.initState();


    /// funciona en backgroubd
    FirebaseMessaging.onMessage.listen((RemoteMessage mensaje) {
      RemoteNotification notification = mensaje.notification;
      AndroidNotification android = mensaje.notification.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    color: Colors.white,
                    playSound: true,
                    icon: '@mipmap/ic_launcher'
                )
            ));
      }
    });


    /// funciona con la app en background y abierta
    /// y el usuario presiona la notificacion
    FirebaseMessaging.onMessageOpenedApp.listen((mensaje) {
      print(' Una nueva notificacion a sido generada');
      RemoteNotification notification = mensaje.notification;
      AndroidNotification android = mensaje.notification.android;
      if (notification != null && android != null) {
        showDialog(context: context, builder: (_) {
          return DialogoAlerta(
            tituloMensaje: notification.title,
            mensaje: notification.body,
          );
        });
      }
      Navegacion(context).navegarANoticias();
    });


  }

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
                            value == null ? 'Campo Obligatorio' : null),
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
                          valor: (value) {
                            this._tituloNoticia = value;
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'Campo Obligatorio' : null),
                        ),
                        SizedBox(height: 15.0),
                        TextFieldDescripcion(
                          nombre: 'DESCRIPCIÓN',
                          icon: Icon(Icons.format_align_left_outlined),
                          valor: (value) {
                            this._descripcionNoticia = value;
                          },
                          /*
                          validacion: ((value) => value.isEmpty
                              ? 'Campo Obligatorio'
                              : null),

                           */
                        ),
                        SizedBox(height: 15.0),
                        TextFieldTexto(
                          nombre: 'LINK',
                          icon: Icon(Icons.link),
                          valor: (value) {
                            if (value.contains('https')) {
                              this._linkNoticia = value;
                            } else {
                              this._linkNoticia = 'https://$value';
                            }
                          },
                          validacion: ((value) =>
                          value.isEmpty ? 'Campo Obligatorio' : null),
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
                                )
                                    .then(
                                      (value) =>
                                      showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogoAlerta(
                                              tituloMensaje: "Alta de Noticia",
                                              mensaje:
                                              "La noticia ha sido creada correctamente",
                                              acciones: [
                                                TextButton(
                                                  child: Text('OK',
                                                      style: TextStyle(
                                                          color:
                                                          Colores().colorAzul,
                                                          fontFamily: 'Trueno',
                                                          fontSize: 11.0,
                                                          decoration: TextDecoration
                                                              .underline)),
                                                  onPressed: () {
                                                    //cierro dialogo
                                                    Navigator.of(context).pop();
                                                    // cierro ventana de alta
                                                    Navigator.of(context).pop();
                                                    // cierro ventana de noticias
                                                    Navigator.of(context).pop();

                                                  },
                                                )
                                              ],
                                            );
                                          }),
                                )
                                    .catchError((e) {
                                  ErrorHandler().errorDialog(e, context);
                                });
                              }
                              mostrarNotificacion();
                            }),
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

  Future crearNoticia(String tipo, String titulo, String descripcion,
      String link) async {
    ControladorNoticia().crearNoticia(tipo, titulo, descripcion, link);
  }

  void mostrarNotificacion() {
    flutterLocalNotificationsPlugin.show(0, 'Plataforma LSU',
        'Una nueva noticia ha sido publicada. No te la pierdas!',
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                priority: Priority.high,
                color: Colors.white,
                playSound: true,
                icon: '@mipmap/ic_launcher'
            )
        ));
  }

  subscribeToTopic(String topic) async{
  }
}
