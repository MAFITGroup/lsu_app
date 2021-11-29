import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  List<String> listaCorreos = [];

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String validarCorreo(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Por favor, ingrese un correo válido';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: formResetarPassword())));
  }

  formResetarPassword() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: ListView(children: [
          SizedBox(height: 150.0),
          TextFieldTexto(
            nombre: 'EMAIL',
            icon: Icon(Icons.alternate_email_rounded),
            valor: (value) {
              this._email = value;
            },
            validacion: (value) => value.isEmpty
                ? 'El email es requerido'
                : Validar().validarCorreo(value),
          ),
          SizedBox(height: 50.0),
          Boton(
            titulo: 'CONFIRMAR',
            onTap: () {
              if (checkFields()) {
                AuthService().resetPasswordLink(_email, context);
              } // if(checkField)
            }, // onTap
          ),
          SizedBox(height: 20.0),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                child: Text('ATRÁS',
                    style: TextStyle(
                        color: Colores().colorAzul,
                        fontFamily: 'Trueno',
                        fontSize: 11.0,
                        decoration: TextDecoration.underline)),
              ))
        ]));
  }
}
