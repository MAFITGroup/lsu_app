import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

class Noticias extends StatefulWidget {
  const Noticias({key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  final formKey = new GlobalKey<FormState>();

  bool isUsuarioAdmin;

  List<String> _tabs = ['NOTICIAS', 'LLAMADOS'];

  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: _tabs.length, // This is the number of tabs.
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        title: const Text('NOTICIAS',
                            style:
                            TextStyle(fontFamily: 'Trueno', fontSize: 16)),
                        // This is the title in the app bar.
                        backgroundColor: Colores().colorAzul,
                        pinned: false,
                        expandedHeight: 150.0,
                        forceElevated: innerBoxIsScrolled,
                        bottom: TabBar(
                          tabs: _tabs
                              .map((String name) => Tab(text: name))
                              .toList(),
                          indicatorColor: Colores().colorBlanco,
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [

                  ],
                )

              // TabBarView

            )));
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await ControladorUsuario()
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }

}
