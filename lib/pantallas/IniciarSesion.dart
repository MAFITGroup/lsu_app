import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/servicios/ErrorHandler.dart';
import 'package:lsu_app/servicios/database.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = new GlobalKey<FormState>();

  Usuario _usuarioActual;

  Database database = Database();

  String uid;
  String email;
  String password;
  String nombreCompleto;
  String telefono;
  String localidad;
  String especialidad;

  Color colorAzul = Colors.blue;

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
            child: Form(key: formKey, child: FormularioRegistro())));
  }

  FormularioRegistro() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: ListView(children: [
          SizedBox(height: 95.0),
          SizedBox(height: 25.0),

          //COREO
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'CORREO',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              onChanged: (value) {
                this.email = value;
              },
              validator: (value) => value.isEmpty
                  ? 'El correo es requerido'
                  : validarCorreo(value)),

          // CONTRASEÑA
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'CONTRASEÑA',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              obscureText: true,
              onChanged: (value) {
                this.password = value;
              },
              // VALIDACIONES PARA CONTRASEÑA
              validator: (value) {
                if (value.isEmpty) {
                  return 'La contraseña es requerida';
                }
                if (value.length <= 6) {
                  return 'La contraseña debe contener mas de 6 caracteres';
                } else {
                  return null;
                }
              }),

          // NOMBRE COMPLETO
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'NOMBRE COMPLETO',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              onChanged: (value) {
                this.nombreCompleto = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'El nombre completo es requerido' : null),

          // TELEFONO
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'TELEFONO',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              // SOLO NUMEROS
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                this.telefono = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'El telefono es requerido' : null),

          // LOCALIDAD
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'LOCALIDAD',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              onChanged: (value) {
                this.localidad = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'La localidad es requerida' : null),

          // ESPECIALIDAD
          TextFormField(
              decoration: InputDecoration(
                  labelText: 'ESPECIALIDAD',
                  labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorAzul),
                  )),
              onChanged: (value) {
                this.especialidad = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'La especialidad es requerida' : null),
          SizedBox(height: 50.0),
          TextButton(
            onPressed: () {
              if (checkFields()) {
                AuthService()
                    .signUp(email, password, nombreCompleto, telefono,
                        localidad, especialidad, false)
                    .then((userCreds) {
                  Navigator.of(context).pop();
                }).catchError((e) {
                  ErrorHandler().errorDialog(context, e);
                });
              }
            },
            child: Container(
                height: 50.0,
                child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    shadowColor: Colors.greenAccent,
                    color: colorAzul,
                    elevation: 7.0,
                    child: Center(
                        child: Text('REGISTRARSE',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Trueno'))))),
          ),
          SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                onTap: () {
                  // guardo datos del usuario

                  // lo
                  Navigator.of(context).pop();
                },
                child: Text('Atras',
                    style: TextStyle(
                        color: colorAzul,
                        fontFamily: 'Trueno',
                        decoration: TextDecoration.underline)))
          ])
        ]));
  }
}
