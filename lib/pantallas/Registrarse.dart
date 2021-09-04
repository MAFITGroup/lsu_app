import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldContrasenia.dart';
import 'package:lsu_app/widgets/TextFieldNumerico.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _nombreCompleto;
  String _telefono;
  String _localidad;
  String _especialidad;

  //To check fields during submit
  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //Valido el correo y su formato
  String validarCorreo(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingresa un correo valido';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: formularioRegistro())));
  }

  formularioRegistro() {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        BarraDeNavegacion(
          titulo: 'REGISTRARSE',
          iconoBtnUno: null,
          onPressedBtnUno: null,
        ),
        SizedBox(height: 30.0),
        //CORREO
        TextFieldTexto(
            nombre: 'CORREO',
            valor: (value) {
              this._email = value;
            },
            validacion: (value) => value.isEmpty
                ? 'El correo es requerido'
                : validarCorreo(value)),

        // CONTRASEÑA
        TextFieldContrasenia(
          nombre: 'CONTRASEÑA',
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

        // NOMBRE COMPLETO
        TextFieldTexto(
            nombre: 'NOMBRE COMPLETO',
            valor: (value) {
              this._nombreCompleto = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'El nombre completo es requerido' : null)),

        // TELEFONO
        TextFieldNumerico(
            nombre: 'TELEFONO',
            valor: (value) {
              this._telefono = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'El telefono es requerido' : null)),

        // LOCALIDAD
        TextFieldTexto(
            nombre: 'LOCALIDAD',
            valor: (value) {
              this._localidad = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'La localidad es requerida' : null)),

        // ESPECIALIDAD
        TextFieldTexto(
            nombre: 'ESPECIALIDAD',
            valor: (value) {
              this._especialidad = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'La especialidad es requerida' : null)),
        SizedBox(height: 50.0),
        Boton(
          titulo: 'REGISTRARSE',
          onTap: () {
            if (checkFields()) {
              AuthService()
                  //dejo mi UID vacia ya que la obtengo en mi manejador luego de hacer el create user.
                  .signUp('', _email, _password, _nombreCompleto, _telefono,
                      _localidad, _especialidad, false)
                  .then((userCreds) {
                Navigator.of(context).pop();
              }).catchError((e) {
                ErrorHandler().errorDialog(context, e);
              });
            }
          },
        ),
        SizedBox(height: 20.0),
      ]),
    ));
  }
}
