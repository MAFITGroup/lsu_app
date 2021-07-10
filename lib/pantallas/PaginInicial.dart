import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/servicios/AuthService.dart';


class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('You are logged in'),
          ElevatedButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: Center(child: Text('LOG OUT')))
        ]));
  }
}
