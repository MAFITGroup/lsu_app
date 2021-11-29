import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldContrasenia.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:lsu_app/widgets/auth_background.dart';
import 'package:lsu_app/widgets/card_container.dart';

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
                  Form(key: formKey, child: loginForm(context)),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      )),
    );
  }

  loginForm(context) {
    return Container(
      child: Column(
        children: [
          TextFieldTexto(
            nombre: 'CORREO',
            icon: Icon(Icons.alternate_email_rounded),
            valor: (value) {
              this._email = value.toLowerCase().trim();
            },
            validacion: (value) => value.isEmpty
                ? 'Campo Obligatorio'
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
                return Validar().validarPassword(value);
              }
            },
          ),
          SizedBox(height: 30),
          Boton(
              titulo: 'INGRESAR',
              onTap: () {


                  if (Validar().camposVacios(formKey)) {
                    AuthService().signIn(_email, _password, context);
                  }

              }),
          SizedBox(height: 10),
          TextButton(
              onPressed: Navegacion(context).navegarAResetPassword,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                      child: Text('OLVIDÉ MI CONTRASEÑA',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline))))),
          TextButton(
              onPressed: Navegacion(context).navegarAPrincipal,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                      child: Text('ATRÁS',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline))))),
        ],
      ),
    );
  }
}
