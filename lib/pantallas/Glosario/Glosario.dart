import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';

import 'VisualizarSeniaPorCategoria.dart';

class Glosario extends StatefulWidget {
  @override
  _GlosarioState createState() => _GlosarioState();
}

class _GlosarioState extends State<Glosario> {
  List<Categoria> listaCategorias = [];
  bool isUsuarioAdmin;
  bool isSearching = false;


  @override
  void initState() {
    obtenerUsuarioAdministrador();
  }

  /*
  Req. del Cliente
 El glosario se muestra categorizado.

 Se mostraran las categorias existentes,
 dentro se muestran las senias que pertenecen a esa
 categoria
   */
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              BarraDeNavegacion(
                titulo: Text("GLOSARIO",
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              ),
              Text("Categorias"),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: listarCategorias(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Cargando...");
                      } else {
                        return ListView.builder(
                            itemCount: listaCategorias.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VisualizarSeniaPorCategoria(
                                                categoria: listaCategorias[index],
                                              )));
                                },
                                title: Text(listaCategorias[index].nombre),
                              ));
                            });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          /*
          Si es usuario administrador muestro el boton
           */
          floatingActionButton: isUsuarioAdmin == true
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colores().colorAzul,
                  onPressed: Navegacion(context).navegarAltaSenia,
                )
              : null,
        ),
      ),
    );
  }

  Future<void> listarCategorias() async {
    listaCategorias =  await ControladorCategoria().obtenerTodasCategorias();
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
