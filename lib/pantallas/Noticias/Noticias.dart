
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

enum RedesSociales {facebook, twitter, email, whatsapp}

class Noticias extends StatefulWidget {
  const Noticias({key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  List<Noticia> listaCharlas = [];
  List<Noticia> listaLlamados = [];
  List<Noticia> listaNoticiasFiltradas = [];
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
/*          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.search)),
          ]
*/      ),
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

  Future<void> obtenerNoticias() async {
    listaNoticias = listaNoticiasFiltradas = await ControladorNoticia().obtenerNoticias();
  }

  void _filtroNoticias(String titulo){
    setState(() {
      listaNoticiasFiltradas = listaNoticias
          .where((noticia) =>
      noticia.toString()
          .startsWith(titulo))
          .toList();
    });

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

                        String link = listaLlamados[index].link;

                        if(link != null){
                          navegarALink(link, context);
                        }else{
                          DialogoAlerta(
                            tituloMensaje: 'Navegacion',
                            mensaje: 'La noticia no tiene un link asociado.',
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                      onLongPress: (){

                        String tipo = listaLlamados[index].tipo;
                        String tit = listaLlamados[index].titulo;
                        String desc = listaLlamados[index].descripcion;
                        String link = listaLlamados[index].link;

                        accionNoticia(tipo, tit, desc, link, context);

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

                        String link = listaCharlas[index].link;

                        if(link != null){
                          navegarALink(link, context);
                        }else{
                          DialogoAlerta(
                            tituloMensaje: 'Navegacion',
                            mensaje: 'La charla no tiene un link asociado.',
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                      onLongPress: (){
                        String tipo = listaCharlas[index].tipo;
                        String tit = listaCharlas[index].titulo;
                        String desc = listaCharlas[index].descripcion;
                        String link = listaCharlas[index].link;

                        accionNoticia(tipo, tit, desc, link, context);
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

  Widget navegarALink(String link, BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            insetPadding: EdgeInsets.all(2.0),
            title: const Text('Navegar al link'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Uds esta a punto de visitar un sitio web fuera de la app,'),
                  SizedBox(height: 10.0),
                  Text('¿Desea continuar?'),
                ],
              ),
            ),
            actions: <Widget> [
              Column(
                children: <Widget>[
                  Boton(
                    titulo: 'Confirmar',
                    onTap: (){

                      lanzarLink(link);
                      Navigator.of(context).pop();

                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text('ATRAS')
                  )

                ],
              )
            ],
          );
        }
    );
  }

  Widget accionNoticia(String tipo, String titulo, String descripcion, String link, BuildContext context){

    List _tipo = [ 'CHARLAS', 'LLAMADOS' ];

    dynamic tipoSeleccionadoNuevo;
    String tituloNoticiaNuevo;
    String descripcionNoticiaNueva;
    String linkNoticiaNueva;
    modoEditar = false;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                insetPadding: EdgeInsets.all(2.0),
                title: Text('Visualizar Noticia'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: DropdownSearch(
                          enabled: modoEditar,
                          selectedItem: tipo,
                          items: _tipo,
                          onChanged: (value) {
                            setState(() {
                              tipoSeleccionadoNuevo = value;
                            });
                          },
                          validator: ((dynamic value) {
                            if( value == null){
                              return 'Campo obligatorio';
                            }else{
                              return null;
                            }
                          }),
                          showSearchBox: true,
                          clearButton: Icon(Icons.close,
                              color: Colores().colorSombraBotones),
                          dropDownButton: Icon(Icons.arrow_drop_down,
                              color: Colores().colorSombraBotones),
                          showClearButton: true,
                          mode: Mode.DIALOG,
                          dropdownSearchDecoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'Trueno',
                                  fontSize: 12,
                                  color: Colores().colorSombraBotones),
                              hintText: "TIPO",
                              prefixIcon: Icon(Icons.account_tree_outlined),
                              focusColor: Colores().colorSombraBotones,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colores().colorSombraBotones),
                              )),
                        ),
                      ),
                      TextFieldTexto(
                        nombre: 'TITULO',
                        icon: Icon(Icons.title),
                        botonHabilitado: modoEditar,
                        controlador: TextEditingController(
                            text: titulo
                        ),
                        valor: (value) {
                          tituloNoticiaNuevo = value;
                        },
                        validacion: ((value) =>
                        value.isEmpty
                            ? 'El título es requerido'
                            : null
                        ),
                      ),
                      TextFieldTexto(
                        nombre: 'Link',
                        icon: Icon(Icons.link),
                        botonHabilitado: modoEditar,
                        controlador: TextEditingController(
                            text: link
                        ),
                        valor: (value) {
                          if(value.contains('https')){
                            linkNoticiaNueva = value;
                          }else{
                            linkNoticiaNueva = 'https://$value';
                          }
                        },
                        validacion: ((value) =>
                        value.isEmpty ? 'El link es requerido' : null),
                      ),
                      TextFieldDescripcion(
                        nombre: 'DESCRIPCION',
                        icon: Icon(Icons.description),
                        botonHabilitado: modoEditar,
                        controlador: TextEditingController(
                            text: descripcion
                        ),
                        valor: (value) {
                          descripcionNoticiaNueva = value;
                        },
                        validacion: ((value) =>
                        value.isEmpty
                            ? 'La descripción es requerida'
                            : null
                        ),
                      ),
/*                      !modoEditar
                          ? Boton(
                        titulo: 'EDITAR',
                        onTap: (){
                          setState(() {
                            modoEditar = true;
                          });
                        },
                      )
                          :Boton(
                        titulo: 'GUARDAR',
                        onTap: (){

                          if(tipoSeleccionadoNuevo == null){
                            tipoSeleccionadoNuevo = tipo;
                          }
                          if(tituloNoticiaNuevo == null){
                            tituloNoticiaNuevo = titulo;
                          }
                          if(descripcionNoticiaNueva == null){
                            descripcionNoticiaNueva = descripcion;
                          }
                          if(linkNoticiaNueva == null){
                            linkNoticiaNueva = link;
                          }

                          guardarEdicionNoticia(
                              tipo,
                              titulo,
                              descripcion,
                              link,
                              tipoSeleccionadoNuevo,
                              tituloNoticiaNuevo,
                              descripcionNoticiaNueva,
                              linkNoticiaNueva
                          )..then((userCreds) {
                            showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Editar Noticia'),
                                    content: Text('Los datos han sido guardados correctamente'),

                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                          Navegacion(context).navegarANoticiasDest();

                                        },
                                      )
                                    ],
                                  );
                                }
                            );
                          });

                        },

                      ),
                      modoEditar
                          ? Boton(
                        titulo: 'CANCELAR',
                        onTap: (){
                          setState(() {
                            modoEditar = false;
                          });
                        },
                      )
                          : Boton(
                        titulo: 'ELIMINAR',
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('Eliminar noticia'),
                                  content: Text('¿Desea eliminar la noticia $titulo?'),
                                  actions: [
                                    Boton(
                                      titulo: 'CONFIRMAR',
                                      onTap: (){
                                        eliminarNoticia(tipo, titulo, descripcion, link);
                                        Navigator.of(context).pop();
                                        Navegacion(context).navegarANoticiasDest();
                                      },
                                    )
                                  ],
                                );
                              }
                          );
                        },
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Text('ATRAS')
                      ),
*/                     !modoEditar
                          ? SocialMediaBotones()
                          : Container(),

                    // Eliminar este boton al activar los botones de arriba
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('ATRAS'))
                    ],
                  ),
                ),

              );
            },

          );
        }
    );
  }
  Widget SocialMediaBotones(){
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RedesBotones(
            icon: FontAwesomeIcons.facebook,
            onTap: () => compartir(RedesSociales.facebook),
          ),
          RedesBotones(
            icon: FontAwesomeIcons.twitter,
            onTap: () => compartir(RedesSociales.twitter),
          ),
          RedesBotones(
            icon: FontAwesomeIcons.whatsapp,
            onTap: () => compartir(RedesSociales.whatsapp),
          ),
          RedesBotones(
            icon: Icons.email,
            onTap: () => compartir(RedesSociales.email),
          ),
        ],
      ),

    );
  }

  Future compartir(RedesSociales redes) async {

    final asunto = 'Plataforma LSU';
    final texto = 'Nuevas noticias publicadas en Plataforma LSU, no te las pierdas!';
    final urlCompartir = Uri.encodeComponent('https://prueba.com');

    final urls = {
      RedesSociales.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlCompartir&t=$texto',
      RedesSociales.twitter:
          'https://twitter.com/intent/tweet?url=$urlCompartir&text=$texto',
      RedesSociales.whatsapp:
          'https://api.whatsapp.com/send?text=$texto$urlCompartir',
      RedesSociales.email:
          'mailto:?subject=$asunto&body=$texto\n\n$urlCompartir',
    };

    final url = urls[redes];

    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw AlertDialog().title;
    }

  }

  lanzarLink(String link) async {
    String url = link;
      if(await canLaunch(url)){
        await launch(
            url,
            forceWebView: true,
            webOnlyWindowName: '_blank'
        );
      }else{
        throw AlertDialog().title;

    }

  }

  Future<void> obtenerCharlas() async {
    listaCharlas = await ControladorNoticia().obtenerCharlas();
  }
  Future<void> obtenerLlamados() async {
    listaLlamados = await ControladorNoticia().obtenerLlamados();
  }

  Future guardarEdicionNoticia(
      String tipoAnterior,
      String tituloAnterior,
      String descripcionAnterior,
      String linkAnterior,
      String tipoNuevo,
      String tituloNuevo,
      String descripcionNueva,
      String linkNuevo
      ) async {
    ControladorNoticia().editarNoticia(
        tipoAnterior,
        tituloAnterior,
        descripcionAnterior,
        linkAnterior,
        tipoNuevo,
        tituloNuevo,
        descripcionNueva,
        linkNuevo);
  }

  Future eliminarNoticia(
      String tipo,
      String titulo,
      String descripcion,
      String link
      ) async{
      ControladorNoticia().eliminarNoticia(tipo, titulo, descripcion, link);
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
