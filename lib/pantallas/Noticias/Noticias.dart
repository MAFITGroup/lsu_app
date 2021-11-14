
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/buscadores/BuscadorNoticias.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Noticia.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/RedesBotones.dart';
import 'package:lsu_app/widgets/TextFieldDescripcion.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'VisualizarNoticia.dart';

enum RedesSociales {facebook, twitter, email, whatsapp}

class Noticias extends StatefulWidget {
  const Noticias({key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  List<Noticia> listaCharlas = [];
  List<Noticia> listaLlamados = [];
  List<Noticia> listaNoticias = [];

  final formKey = new GlobalKey<FormState>();

  bool isUsuarioAdmin;
  bool modoEditar;

  bool isSearching;

  int _selectedIndexForBottomNavigationBar = 0;
  int _selectedIndexForTabBar = 0;

  @override
  void initState() {
    obtenerUsuarioAdministrador();
    listaCharlas.clear();
    listaLlamados.clear();
    listCharlas();
    listLlamados();
    listNoticias();
    modoEditar = false;
    isSearching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTappedForTabBar(int index) {
      setState(() {
        _selectedIndexForTabBar = index + 1;
        _selectedIndexForBottomNavigationBar = 0;
      });
    }
    final tabBar = new TabBar(labelColor: Colores().colorBlanco,
      indicatorColor: Colores().colorBlanco,
      onTap: _onItemTappedForTabBar,
      tabs: <Widget>[
        new Tab(
          text: "CHARLAS",
        ),
        new Tab(
          text: "LLAMADOS",
        ),
      ],
    );

    return new DefaultTabController(length: 2, child: new Scaffold(
      appBar: AppBar(
          bottom:tabBar ,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light),
          backgroundColor: Colores().colorAzul,
          title: Text("NOTICIAS",style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: BuscadorNoticias(
                          listaNoticias, listaNoticias, isUsuarioAdmin));
                },
                icon: Icon(Icons.search)),
          ]
      ),
      body: TabBarView(
        children: [
          listCharlas(),
          listLlamados()
        ],
      ),

      floatingActionButton:
      isUsuarioAdmin == true
          ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colores().colorAzul,
        onPressed: Navegacion(context).navegarAltaNoticia,
      )
          : null,
    ),

    );
  }

  Widget listLlamados(){
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: obtenerLlamados(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child:  Image.asset('recursos/logo-carga.gif'),
              );
            }else {
              return ListView.builder(
                itemCount: listaLlamados.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colores().colorBlanco,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0,0)
                        )
                      ]
                    ),
                    child: ListTile(
                      title: Text('Titulo: ' + listaLlamados[index].titulo),
                      subtitle: Text(
                          'Descripción: ' + listaLlamados[index].descripcion +
                              '\nLink: ' + listaLlamados[index].link +
                              '\nFecha de Publicación: ' + listaLlamados[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaLlamados[index],
                                  tipo: listaLlamados[index].tipo,
                                  titulo: listaLlamados[index].titulo,
                                  descripcion: listaLlamados[index].descripcion,
                                  link: listaLlamados[index].link,
                                  isUsuarioAdmin: isUsuarioAdmin,
                                )));


                      },
                    ),
                  );
                }
              );
            }
          },
        ),
      ),
    );
  }

  Widget listCharlas(){
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: obtenerCharlas(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child:  Image.asset('recursos/logo-carga.gif'),
              );
            }else {
              return ListView.builder(
                itemCount: listaCharlas.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colores().colorBlanco,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0,0)
                        )
                      ]
                    ),
                    child: ListTile(

                      title: Text('Titulo: ' + listaCharlas[index].titulo),
                      subtitle: Text(
                          'Descripción: ' + listaCharlas[index].descripcion +
                        '\nLink: ' + listaCharlas[index].link +
                        '\nFecha de Publicación: ' + listaCharlas[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaCharlas[index],
                                  tipo: listaCharlas[index].tipo,
                                  titulo: listaCharlas[index].titulo,
                                  descripcion: listaCharlas[index].descripcion,
                                  link: listaCharlas[index].link,
                                  isUsuarioAdmin: isUsuarioAdmin,
                                )));

                      },

                    ),
                  );
                }
              );
            }
          },
        ),
      ),
    );
  }

  Widget listNoticias(){
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: listadoNoticias(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child:  Image.asset('recursos/logo-carga.gif'),
              );
            }else {
              return ListView.builder(
                itemCount: listaNoticias.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colores().colorBlanco,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0,0)
                        )
                      ]
                    ),
                    child: ListTile(

                      title: Text('Titulo: ' + listaNoticias[index].titulo),
                      subtitle: Text(
                          'Descripción: ' + listaNoticias[index].descripcion +
                        '\nLink: ' + listaNoticias[index].link +
                        '\nFecha de Publicación: ' + listaNoticias[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaNoticias[index],
                                  tipo: listaNoticias[index].tipo,
                                  titulo: listaNoticias[index].titulo,
                                  descripcion: listaNoticias[index].descripcion,
                                  link: listaNoticias[index].link,
                                  isUsuarioAdmin: isUsuarioAdmin,
                                )));

                      },

                    ),
                  );
                }
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> obtenerCharlas() async {
    listaCharlas = await ControladorNoticia().obtenerCharlas();
  }
  Future<void> obtenerLlamados() async {
    listaLlamados = await ControladorNoticia().obtenerLlamados();
  }

  Future<void> listadoNoticias() async {
    listaNoticias = await ControladorNoticia().obtenerNoticias();
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
