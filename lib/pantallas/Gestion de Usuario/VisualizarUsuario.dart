import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
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

  const VisualizarUsuario({Key key, this.usuario, this.nombre, this.correo,
    this.departamento, this.esAdministrador, this.especialidad,
    this.statusUsuario, this.telefono}) : super(key: key);

  @override
  _VisualizarUsuarioState createState() => _VisualizarUsuarioState();
}

class _VisualizarUsuarioState extends State<VisualizarUsuario> {

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Usuario usuario = widget.usuario;
    String estadoUsuario = usuario.statusUsuario;
    bool estadoU;

    if(estadoUsuario == 'PENDIENTE' || estadoUsuario == 'INACTIVO'){
      print(estadoUsuario);
      estadoU = false;
      print(estadoU);
    }
    if(estadoUsuario == 'ACTIVO'){
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
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        // NOMBRE COMPLETO
                        TextFieldTexto(
                          nombre: 'NOMBRE COMPLETO',
                          icon: Icon(Icons.person),
                          controlador: TextEditingController(
                              text: usuario.nombreCompleto),
                        ),
                        //CORREO
                        TextFieldTexto(
                          nombre: 'CORREO',
                          icon: Icon(Icons.alternate_email_rounded),
                          controlador: TextEditingController(text: usuario.correo ),
                        ),
                        // CELULAR
                        TextFieldNumerico(
                            nombre: 'CELULAR',
                            icon: Icon(Icons.phone),
                            controlador: TextEditingController(text: usuario.telefono),
                            ),

                        // DEPARTAMENTO
                        TextFieldTexto(
                          nombre: 'DEPARTAMENTO',
                          icon: Icon(Icons.location_city_outlined),
                          controlador: TextEditingController(text: usuario.departamento),
                        ),

                        // ESPECIALIDAD
                        TextFieldTexto(
                            nombre: 'ESPECIALIDAD',
                            icon: Icon(Icons.military_tech_outlined),
                            controlador: TextEditingController(
                                text: usuario.especialidad),
                            ),
                        // USUARIO ADMINISTRADOR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Icon(Icons.group_add_rounded)
                            ),
                            Expanded(
                                child: Text('Administrador')
                            ),
                            Expanded(
                              child:Switch(
                                value: usuario.esAdministrador,
                                onChanged: (value) {
                                  setState(() {
                                    usuario.esAdministrador = value;
                                  });
                                },
                                activeTrackColor: Colores().colorAzul,
                                activeColor: Colores().colorCeleste,
                              ),
                            )
                          ],
                        ),
                        // ESTADO DE USUARIO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Icon(Icons.supervised_user_circle_outlined)
                            ),
                            Expanded(
                                child: Text('Activo')
                            ),
                            Expanded(
                              child: Switch(
                                value: estadoU,
                                onChanged: (value) {
                                  setState(() {
                                    estadoU = value;
                                    if(estadoU) {
                                      estadoUsuario = 'ACTIVO';
                                      usuario.statusUsuario = estadoUsuario;
                                    }
                                    else{
                                      estadoUsuario = 'INACTIVO';
                                      usuario.statusUsuario = estadoUsuario;
                                    }

                                  });
                                },
                                activeTrackColor: Colores().colorAzul,
                                activeColor: Colores().colorCeleste,
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 50.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Boton(
                              titulo: 'GUARDAR',
                              onTap: () {
                                Navigator.of(context).pop();

                                ControladorUsuario().administrarUsuario(usuario.correo, usuario.statusUsuario, usuario.esAdministrador);

                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        contentPadding: const EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0)),
                                        title: Text('El usuario ' + usuario.nombreCompleto + ', ha sido actualizado.'),
                                        actions: [
                                          TextButton(
                                            onPressed: (){

                                              Navigator.of(context).pop();
                                              Navegacion(context).navegarAPaginaGestionUsuarioDest();

                                            },
                                            child: Text('Ok',
                                                style: TextStyle(
                                                    color: Colores().colorAzul,
                                                    fontFamily: 'Trueno',
                                                    fontSize: 11.0,
                                                    decoration: TextDecoration.underline)),
                                          )
                                        ],
                                      );
                                    }
                                );

                              },
                            ),
                            usuario.statusUsuario == 'PENDIENTE'
                              ? Boton(
                              titulo: 'ELIMINAR USUARIO',
                              onTap: (){
                                ControladorUsuario().eliminarUsuarios(usuario.correo);

                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        contentPadding: const EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0)),
                                        title: Text('El usuario ' + usuario.nombreCompleto + ', ha sido actualizado.'),
                                        actions: [
                                          TextButton(
                                            onPressed: (){

                                              Navigator.of(context).pop();
                                              Navegacion(context).navegarAPaginaGestionUsuarioDest();

                                            },
                                            child: Text('Ok',
                                                style: TextStyle(
                                                    color: Colores().colorAzul,
                                                    fontFamily: 'Trueno',
                                                    fontSize: 11.0,
                                                    decoration: TextDecoration.underline)),
                                          )
                                        ],
                                      );
                                    }
                                );

                              },

                            )
                              : SizedBox(height: 1.0),
                            TextButton(
                              child: const Text('ATRAS'),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
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
}
