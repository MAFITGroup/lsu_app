import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/EnvioMail.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/TextFieldNumerico.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';


class VisualizarUsuario extends StatefulWidget {
  final Usuario usuario;
  final String nombre;
  final String correo;
  final String departamento;
  final bool esAdministrador;
  final String especialidad;
  final String statusUsuario;
  final String telefono;

  const VisualizarUsuario(
      {Key key,
      this.usuario,
      this.nombre,
      this.correo,
      this.departamento,
      this.esAdministrador,
      this.especialidad,
      this.statusUsuario,
      this.telefono})
      : super(key: key);

  @override
  _VisualizarUsuarioState createState() => _VisualizarUsuarioState();
}

class _VisualizarUsuarioState extends State<VisualizarUsuario> {
  final formKey = new GlobalKey<FormState>();
  List listaCorreos = [];
  ControladorUsuario controladorUsuario = ControladorUsuario();
  bool modoEditar;

  @override
  void initState() {
    obtenerCorreosUsuariosAdministrador();
    setState(() {
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = widget.usuario;
    String estadoUsuario = usuario.statusUsuario;
    bool estadoU;

    if (estadoUsuario == 'PENDIENTE' || estadoUsuario == 'INACTIVO') {
      print(estadoUsuario);
      estadoU = false;
      print(estadoU);
    }
    if (estadoUsuario == 'ACTIVO') {
      print(estadoUsuario);
      estadoU = true;
      print(estadoU);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
                titulo: Text('VISUALIZAR USUARIO',
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
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
                        child: ListTile(
                            leading: Icon(
                                !modoEditar
                                    ? Icons.edit
                                    : Icons.cancel_outlined,
                                color: Colores().colorAzul),
                            title: Text(
                                !modoEditar
                                    ? "Editar Usuario"
                                    : "Cancelar Editar",
                                style: TextStyle(
                                    fontFamily: 'Trueno',
                                    fontSize: 14,
                                    color: Colores().colorSombraBotones))),
                      ),
                      usuario.statusUsuario == 'PENDIENTE'
                          ? PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                  leading: Icon(Icons.delete_forever_outlined,
                                      color: Colores().colorAzul),
                                  title: Text("Eliminar Usuario",
                                      style: TextStyle(
                                          fontFamily: 'Trueno',
                                          fontSize: 14,
                                          color:
                                              Colores().colorSombraBotones))),
                            )
                          : null,
                    ],
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      //CORREO
                      TextFieldTexto(
                        nombre: 'CORREO',
                        icon: Icon(Icons.alternate_email_rounded),
                        habilitado: false,
                        controlador:
                            TextEditingController(text: usuario.correo),
                      ),
                      // NOMBRE COMPLETO
                      TextFieldTexto(
                        nombre: 'NOMBRE COMPLETO',
                        icon: Icon(Icons.person),
                        habilitado: false,
                        controlador:
                            TextEditingController(text: usuario.nombreCompleto),
                      ),
                      // CELULAR
                      TextFieldNumerico(
                        nombre: 'CELULAR',
                        icon: Icon(Icons.phone),
                        habilitado: false,
                        controlador:
                            TextEditingController(text: usuario.telefono),
                      ),
                      // DEPARTAMENTO
                      TextFieldTexto(
                        nombre: 'DEPARTAMENTO',
                        icon: Icon(Icons.location_city_outlined),
                        habilitado: false,
                        controlador:
                            TextEditingController(text: usuario.departamento),
                      ),

                      // ESPECIALIDAD
                      TextFieldTexto(
                        nombre: 'ESPECIALIDAD',
                        icon: Icon(Icons.military_tech_outlined),
                        habilitado: false,
                        controlador:
                            TextEditingController(text: usuario.especialidad),
                      ),
                      modoEditar
                          ? Column(
                              children: [
                                Table(
                                  columnWidths: {3: FlexColumnWidth(0.2)},
                                  children: [
                                    TableRow(children: [
                                      Icon(Icons.group_add_rounded),
                                      Text('ADMINISTRADOR',
                                          style: TextStyle(
                                              fontFamily: 'Trueno',
                                              fontSize: 14,
                                              color: Colores().colorAzul)),
                                      Switch(
                                        value: usuario.esAdministrador,
                                        onChanged: (value) {
                                          setState(() {
                                            usuario.esAdministrador = value;
                                          });
                                        },
                                        activeTrackColor: Colores().colorAzul,
                                        activeColor: Colores().colorCeleste,
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Icon(Icons
                                          .supervised_user_circle_outlined),
                                      Text('ACTIVO',
                                          style: TextStyle(
                                              fontFamily: 'Trueno',
                                              fontSize: 14,
                                              color: Colores().colorAzul)),
                                      Switch(
                                        value: estadoU,
                                        onChanged: (value) {
                                          setState(() {
                                            estadoU = value;
                                            if (estadoU) {
                                              estadoUsuario = 'ACTIVO';
                                              usuario.statusUsuario =
                                                  estadoUsuario;
                                            } else {
                                              estadoUsuario = 'INACTIVO';
                                              usuario.statusUsuario =
                                                  estadoUsuario;
                                            }
                                          });
                                        },
                                        activeTrackColor: Colores().colorAzul,
                                        activeColor: Colores().colorCeleste,
                                      ),
                                    ]),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 50.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          modoEditar
                              ? Boton(
                                  titulo: 'GUARDAR',
                                  onTap: () {
                                    if (usuario.statusUsuario == 'ACTIVO') {
                                      String estadoSolicitud = 'Aceptada';
                                      EnvioMail().enviarMail(usuario.nombreCompleto, usuario.correo, estadoSolicitud);
                                    }
                                    controladorUsuario.administrarUsuario(
                                        usuario.correo,
                                        usuario.statusUsuario,
                                        usuario.esAdministrador);

                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (context) {
                                          return DialogoAlerta(
                                            tituloMensaje: 'Edición de Usuario',
                                            mensaje: 'El usuario ' +
                                                usuario.nombreCompleto +
                                                ', ha sido actualizado.',
                                            acciones: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navegacion(context)
                                                      .navegarAPaginaGestionUsuarioDest();
                                                },
                                                child: Text('OK',
                                                    style: TextStyle(
                                                        color:
                                                            Colores().colorAzul,
                                                        fontFamily: 'Trueno',
                                                        fontSize: 11.0,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void modoEditarUsuario() {
    setState(() {
      modoEditar = true;
    });
  }

  void cancelarModoEditarUsuario() {
    setState(() {
      modoEditar = false;
    });
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? modoEditarUsuario() : cancelarModoEditarUsuario();
        break;
      case 1:
        String estadoSolicitud = 'Denegada';
        EnvioMail().enviarMail(widget.usuario.nombreCompleto, widget.usuario.correo, estadoSolicitud);
        controladorUsuario.administrarUsuario(
            widget.usuario.correo, estadoSolicitud, widget.usuario.esAdministrador);

        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return DialogoAlerta(
                tituloMensaje: 'Edición de Usuario',
                mensaje: 'El usuario ' +
                    widget.usuario.nombreCompleto +
                    ', ha sido actualizado.',
                acciones: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navegacion(context).navegarAPaginaGestionUsuarioDest();
                    },
                    child: Text('OK',
                        style: TextStyle(
                            color: Colores().colorAzul,
                            fontFamily: 'Trueno',
                            fontSize: 11.0,
                            decoration: TextDecoration.underline)),
                  )
                ],
              );
            });
    }
  }

  Future<void> obtenerCorreosUsuariosAdministrador() async {
    listaCorreos =
        await controladorUsuario.obtenerCorreosUsuariosAdministrador();
    return listaCorreos;
  }


}
