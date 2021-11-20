
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/GoogleAuthApi.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldNumerico.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';


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
                                if(usuario.statusUsuario == 'ACTIVO'){
                                  String tipo = 'aceptada';
                                  disparadorEmail(usuario.correo, tipo);
                                }

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
                                String estado = 'DENEGADO';
                                String tipo = 'denagada';
                                disparadorEmail(usuario.correo, tipo);
                                ControladorUsuario().administrarUsuario(usuario.correo, estado, usuario.esAdministrador);

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
                              child: const Text('ATRÁS'),
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

  Future disparadorEmail (String correo, String tipo) async {

    GoogleAuthApi.signOut();
    final user = await GoogleAuthApi.singIn();

    if (user == null ) return;
    final email = user.email;
    final auth = await user.authentication;
    String token = auth.accessToken;
    
    final smtpServer = gmailSaslXoauth2(email, token);

    final message = Message()
        ..from = Address(email, 'Plataforma LSU')
        ..recipients = [correo]
        ..subject = 'Solicitud de Acceso $tipo'
        ..text = 'Su solicitud de acceso a la Plataforma ha sido $tipo por el usuario administrador' +
            '\n Plataforma LSU';

    try {
      await send(message, smtpServer);
      print('mail envidado');
    } on MailerException catch (e){
      print(e);
    }

  }
}
