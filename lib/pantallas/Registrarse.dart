import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldContrasenia.dart';
import 'package:lsu_app/widgets/TextFieldNumerico.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class Registrarse extends StatefulWidget {
  @override
  _RegistrarseState createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _nombreCompleto;
  String _telefono;
  String _localidad;
  String _especialidad;

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
            icon: Icon(Icons.alternate_email_rounded),
            valor: (value) {
              this._email = value;
            },
            validacion: (value) => value.isEmpty
                ? 'El correo es requerido'
                : Validar().validarCorreo(value)),

        // CONTRASEÑA
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

        // NOMBRE COMPLETO
        TextFieldTexto(
            nombre: 'NOMBRE COMPLETO',
            icon: Icon(Icons.person),
            valor: (value) {
              this._nombreCompleto = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'El nombre completo es requerido' : null)),

        // TELEFONO
        TextFieldNumerico(
            nombre: 'TELEFONO',
            icon: Icon(Icons.phone),
            valor: (value) {
              this._telefono = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'El telefono es requerido' : null)),

        // LOCALIDAD
        TextFieldTexto(
            nombre: 'LOCALIDAD',
            icon: Icon(Icons.location_city_outlined),
            valor: (value) {
              this._localidad = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'La localidad es requerida' : null)),

        // ESPECIALIDAD
        TextFieldTexto(
            nombre: 'ESPECIALIDAD',
            icon: Icon(Icons.military_tech_outlined),
            valor: (value) {
              this._especialidad = value;
            },
            validacion: ((value) =>
                value.isEmpty ? 'La especialidad es requerida' : null)),
        SizedBox(height: 50.0),
        Boton(
          titulo: 'REGISTRARSE',
          onTap: () {
            if (Validar().camposVacios(formKey)) {
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
