import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Categorias extends StatelessWidget {
  CollectionReference categoriasRef =
      FirebaseFirestore.instance.collection('categorias');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: 'BUSQUEDA DE CATEGORIAS',
              // TODO Implementar busqueda de categorias
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: categoriasRef.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  return new ListView(children: getExpenseItems(snapshot));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colores().colorAzul,
          onPressed: Navegacion(context).navegarAAltaCategoria),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => Card(
                child: new ListTile(
              title: new Text(doc["nombre"]),
              onTap: () {},//TODO agregar accion al presionar cat
            )))
        .toList();
  }
}
