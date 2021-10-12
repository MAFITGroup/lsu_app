import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Biblioteca extends StatefulWidget {
  const Biblioteca({key}) : super(key: key);

  @override
  _BibliotecaState createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Form(key: formKey, child: enConstruccion(context)
            )
        )
    );
  }

  enConstruccion(context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'BIBLIOTECA',
            ),

            SizedBox(height: 30),

            Image(
              image: AssetImage('recursos/EnConstruccion.png'),
            )


          ],
        ),
      ),
    );
  }

}
