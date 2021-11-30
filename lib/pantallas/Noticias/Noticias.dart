
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsu_app/buscadores/BuscadorNoticias.dart';
import 'package:lsu_app/controladores/ControladorNoticia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Noticia.dart';

import 'VisualizarNoticia.dart';

enum RedesSociales { facebook, twitter, email, whatsapp }

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

    final tabBar = new TabBar(
      labelColor: Colores().colorBlanco,
      indicatorColor: Colores().colorBlanco,
      labelStyle: TextStyle(fontFamily: 'Trueno', fontSize: 14),
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

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: AppBar(
            bottom: tabBar,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light),
            backgroundColor: Colores().colorAzul,
            title: Text("NOTICIAS",
                style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: BuscadorNoticias(
                            listaNoticias, listaNoticias, isUsuarioAdmin));
                  },
                  icon: Icon(Icons.search)),
            ]),
        body: TabBarView(
          children: [listCharlas(), listLlamados()],
        ),
        floatingActionButton: isUsuarioAdmin == true
            ? FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colores().colorAzul,
                onPressed: Navegacion(context).navegarAltaNoticia,
              )
            : null,
      ),
    );
  }

  Widget listLlamados() {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: obtenerLlamados(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('recursos/logo-carga.gif'),
              );
            } else if (listaCharlas.length <= 0) {
              return Center(
                child: Image.asset('recursos/VuelvePronto.png'),
              );
            } else {
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
                      title: Text('TÍTULO: ' + listaLlamados[index].titulo),
                      subtitle: Text('LINK: ' + listaLlamados[index].link +
                              '\nFECHA DE PUBLICACIÓN: ' + listaLlamados[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaLlamados[index],
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

  Widget listCharlas() {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: obtenerCharlas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('recursos/logo-carga.gif'),
              );
            } else if (listaCharlas.length <= 0) {
              return Center(
                child: Image.asset('recursos/VuelvePronto.png'),
              );
            } else {
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

                      title: Text('TÍTULO: ' + listaCharlas[index].titulo),
                      subtitle: Text('LINK: ' + listaCharlas[index].link +
                        '\nFECHA DE PUBLICACIÓN: ' + listaCharlas[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaCharlas[index],
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

  Widget listNoticias() {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: listadoNoticias(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('recursos/logo-carga.gif'),
              );
            } else if (listaNoticias.length <= 0) {
              return Center(
                child: Image.asset('recursos/VuelvePronto.png'),
              );
            } else {
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

                      title: Text('TÍTULO: ' + listaNoticias[index].titulo),
                      subtitle: Text('LINK: ' + listaNoticias[index].link +
                        '\nFECHA DE PUBLICACIÓN: ' + listaNoticias[index].fechaSubida
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizarNoticia(
                                  noticia: listaNoticias[index],
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
