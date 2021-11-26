import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
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
  String _departamento;
  String _especialidad;
  String _statusUsuario;
  List departamentos = [
    'ARTIGAS',
    'CANELONES',
    'CERRO LARGO',
    'COLONIA',
    'DURAZNO',
    'FLORES',
    'FLORIDA',
    'LAVALLEJA',
    'MALDONADO',
    'MONTEVIDEO',
    'PAYSANDÚ',
    'RÍO NEGRO',
    'RIVERA',
    'ROCHA',
    'SALTO',
    'SORIANO',
    'SAN JOSÉ',
    'TACUAREMBÓ',
    'TREINTA Y TRES'
  ];

  bool isCheckedTerminosyCondiciones = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: formularioRegistro(context))));
  }

  formularioRegistro(context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          BarraDeNavegacion(
            titulo: Text("REGISTRARSE",
                style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          ),

          SizedBox(height: 30.0),

          //CORREO
          TextFieldTexto(
              nombre: 'CORREO',
              icon: Icon(Icons.alternate_email_rounded),
              valor: (value) {
                this._email = value.toLowerCase();
              },
              validacion: (value) => value.isEmpty
                  ? 'Campo Obligatorio'
                  : Validar().validarCorreo(value)),

          // CONTRASEÑA
          TextFieldContrasenia(
              nombre: 'CONTRASEÑA',
              icon: Icon(Icons.lock_outline),
              iconInfo: Tooltip(
                message: 'La contraseña debe contener al menos 8 caracteres,\n1 Mayúscula, 1 número y 1 carácter especial ( !@#\$&*~. )',
                child: InkWell(
                  child: Icon(FontAwesomeIcons.infoCircle, color: Colores().colorAzul),
                ),
              ),
              valor: (value) {
                this._password = value;
              },
              validacion: (value) {
                if (value.isEmpty) {
                  return Validar().validarPassword(value);
                }
              }),

          // NOMBRE COMPLETO
          TextFieldTexto(
              nombre: 'NOMBRE COMPLETO',
              icon: Icon(Icons.person),
              valor: (value) {
                this._nombreCompleto = value.toUpperCase();
              },
              validacion: ((value) =>
                  value.isEmpty ? 'Campo Obligatorio' : null)),

          // CELULAR
          TextFieldNumerico(
              nombre: 'CELULAR',
              icon: Icon(Icons.phone),
              iconInfo: Tooltip(
                message: 'El número de celular debe comenzar con 09 \ny tener un largo de 9 caracteres',
                child: InkWell(
                  child: Icon(FontAwesomeIcons.infoCircle, color: Colores().colorAzul),
                ),
              ),
              valor: (value) {
                this._telefono = value;
              },
              validacion: (value) => value.isEmpty
                  ? 'Campo Obligatorio'
                  : Validar().validarCelular(value)),

          // DEPARTAMENTO
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: DropdownSearch(
              items: departamentos,
              onChanged: (value) {
                setState(() {
                  this._departamento = value;
                });
              },
              validator: ((dynamic value) {
                if (value == null) {
                  return "Campo Obligatorio";
                } else {
                  return null;
                }
              }),
              showSearchBox: true,
              clearButton:
                  Icon(Icons.close, color: Colores().colorSombraBotones),
              dropDownButton: Icon(Icons.arrow_drop_down,
                  color: Colores().colorSombraBotones),
              showClearButton: true,
              mode: Mode.DIALOG,
              dropdownSearchDecoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12,
                      color: Colores().colorSombraBotones),
                  hintText: "DEPARTAMENTO",
                  prefixIcon: Icon(Icons.location_city_outlined),
                  focusColor: Colores().colorSombraBotones,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colores().colorSombraBotones),
                  )),
            ),
          ),

          // ESPECIALIDAD
          TextFieldTexto(
              nombre: 'ESPECIALIDAD',
              icon: Icon(Icons.military_tech_outlined),
              valor: (value) {
                this._especialidad = value.toUpperCase();
              },
              validacion: ((value) =>
                  value.isEmpty ? 'Campo Obligatorio' : null)),

          Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isCheckedTerminosyCondiciones,
                    onChanged: (value) {
                      setState(() {
                        isCheckedTerminosyCondiciones = value;
                      });
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navegacion(context).navegarTerminosCondiciones();
                      },
                      child: Text('TÉRMINOS Y CONDICIONES DE USO',
                          style: TextStyle(
                            color: Colores().colorAzul,
                            fontFamily: 'Trueno',
                            fontSize: 11.0,
                          )))
                ],
              )),
          SizedBox(height: 50.0),

          Boton(
              titulo: 'REGISTRARSE',
              onTap: () {
                _statusUsuario = 'PENDIENTE';
                if (Validar().camposVacios(formKey)) {
                  if (isCheckedTerminosyCondiciones) {
                    AuthService().signUp(
                        _email,
                        _password,
                        _nombreCompleto,
                        _telefono,
                        _departamento,
                        _especialidad,
                        false,
                        _statusUsuario,
                        context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogoAlerta(
                            tituloMensaje: 'Términos y Condiciones de Uso',
                            mensaje:
                                'Para completar el registro es necesario aceptar los Términos y Condiciones de uso',
                            acciones: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK',
                                      style: TextStyle(
                                          color: Colores().colorAzul,
                                          fontFamily: 'Trueno',
                                          fontSize: 11.0,
                                          decoration:
                                              TextDecoration.underline))),
                            ],
                          );
                        });
                  }
                }
              }),

          SizedBox(height: 20.0),
        ]),
      ),
    );
  }
}
