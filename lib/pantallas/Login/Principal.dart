import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
//        color: Color.fromRGBO(159, 206, 255, 0.5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: EdgeInsets.all(10),
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
              subtitle: Center(
                child: Text(
                    'Única plataforma Uruguaya para intérpretes de Lengua de Señas donde encontrarás, con un solo clic, la información que requieras para tu cotidianidad',
                    ),
              )),
        ],
      ),
    );
  }
}
