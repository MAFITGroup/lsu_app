import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldContrasenia.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:lsu_app/widgets/auth_background.dart';
import 'package:lsu_app/widgets/card_container.dart';

import 'PaginaInicial.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            CardContainer(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 30.0,
                        color: Colores().colorAzul),
                  ),
                  SizedBox(height: 30),
                  Form(key: formKey, child: loginForm()),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      )),
    );
  }

  loginForm() {
    return Container(
      child: Form(
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFieldTexto(
              nombre: 'CORREO',
              icon: Icon(Icons.alternate_email_rounded),
              valor: (value) {
                this._email = value;
              },
              validacion: (value) => value.isEmpty
                  ? 'El correo es requerido'
                  : Validar().validarCorreo(value),
            ),
            SizedBox(height: 30),
            TextFieldContrasenia(
              nombre: 'CONTRASEÑA',
              icon: Icon(Icons.lock_outline),
              valor: (value) {
                this._password = value;
              },
              validacion: (value) {
                if (value.isEmpty) {
                  return 'La contraseña es requerida';
                }
                if (value.length <= 6) {
                  return 'La contraseña debe contener mas de 6 caracteres';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 30),
            Boton(
                titulo: 'INGRESAR',
                onTap: () {
                    if (Validar().camposVacios(formKey)) {

                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Campos requeridos'),
                            content: Text('Los campos usuario y contraseña son obligatorios'),
                            actions: [
                              TextButton(
                                  child: Text('Ok',
                                    style: TextStyle(
                                      color: Colores().colorAzul,
                                      fontFamily: 'Trueno',
                                      fontSize: 11.0,
                                      decoration: TextDecoration.underline
                                    ),
                                  ),
                                onPressed: Navegacion(context).navegarALogin,
                              )
                            ],
                          );

                        }
                    );

                  }else {

                      AuthService().signIn(_email, _password, context);

                    }
                }),
            SizedBox(height: 10),
            GestureDetector(
                onTap: Navegacion(context).navegarAResetPassword,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(top: 15.0, left: 20.0),
                    child: InkWell(
                        child: Text('OLVIDE MI CONTRASEÑA',
                            style: TextStyle(
                                color: Colores().colorAzul,
                                fontFamily: 'Trueno',
                                fontSize: 11.0,
                                decoration: TextDecoration.underline))))),
          ],
        ),
      ),
    );
  }
}
