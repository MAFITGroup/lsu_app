import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';

class InicioPage extends StatelessWidget {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

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
//        color: Color.fromRGBO(159, 206, 255, 0.5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            _imageInicio(),
            SizedBox(height: 10),
            _infoInicio(),
            SizedBox(height: 10),
            Boton(titulo: 'LOGIN', onTap: Navegacion(context).navegarALogin),
            SizedBox(height: 10),
            Boton(
                titulo: 'REGISTRARSE',
                onTap: Navegacion(context).navegarARegistrarse),
          ],
        ),
      ),
    );
  }

  Widget _imageInicio() {
    final card = Container(
      child: Column(
        children: [
          Image(
            image: AssetImage('recursos/LSU-logo.jpeg'),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black12, blurRadius: 15, offset: Offset(0, 0))
          ]),
      child: ClipRRect(
        child: card,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _infoInicio() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          ListTile(
              subtitle: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                  textAlign: TextAlign.justify)),
        ],
      ),
    );
  }
}
