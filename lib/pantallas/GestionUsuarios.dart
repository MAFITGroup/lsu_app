
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';


class GestionUsuarios extends StatefulWidget {
  const GestionUsuarios({Key key}) : super(key: key);

  @override
  _GestionUsuarios createState() => _GestionUsuarios();

}

class _GestionUsuarios extends State<GestionUsuarios> {

  List<String> _tabs = ['ACTIVOS', 'PENDIENTES', 'INACTIVOS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: _tabs.length, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: const Text('GESTION DE USUARIOS', style: TextStyle(fontFamily: 'Trueno', fontSize: 16)), // This is the title in the app bar.
                    backgroundColor: Colores().colorAzul,
                    pinned: true,
                    expandedHeight: 150.0,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: UsuarioLista()
            )
            ),
          );

  }

}

class UsuarioDetalles extends StatefulWidget {
  const UsuarioDetalles({Key key}) : super(key: key);

  @override
  _UsuarioDetallesState createState() => _UsuarioDetallesState();
}

class _UsuarioDetallesState extends State<UsuarioDetalles> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class UsuarioLista extends StatefulWidget {
  const UsuarioLista({Key key}) : super(key: key);

  @override
  _UsuarioListaState createState() => _UsuarioListaState();
}

class _UsuarioListaState extends State<UsuarioLista> {

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    
    QuerySnapshot qn = await firestore.collection('usuarios').get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPosts(),
        builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text('... Cargando'),
            );
          }else{
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){
                  return ListTile(
                      title: Text(snapshot.data[index].data['correo']),
                  );

                });
          }
        },
      ),
    );
  }
}
