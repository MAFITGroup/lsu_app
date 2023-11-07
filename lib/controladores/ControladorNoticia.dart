import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/modelo/Noticia.dart';

class ControladorNoticia {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String ?_tipo;
  String ?_titulo;
  String ?_descripcion;
  String ?_link;
  String ?_uid;
  String ?_fechaSubida;
  String ?_usuarioAlta;

  Noticia ?noticia;

  Future<Noticia?> obtenerNoticia(String tipoNoticia, String tituloNoticia,
      String descripcionNoticia, String linkNoticia) async {
    await firestore
        .collection('noticias')
        .where('tipo', isEqualTo: tipoNoticia)
        .where('titulo', isEqualTo: tituloNoticia)
        .where('descripcion', isEqualTo: descripcionNoticia)
        .where('link', isEqualTo: linkNoticia)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _tipo = doc['tipo'];
        _titulo = doc['titulo'];
        _descripcion = doc['descripcion'];
        _link = doc['link'];
        _usuarioAlta = doc['usuarioAlta'];
        _uid = doc['documentID'];
        _fechaSubida = doc['fechaSubida'];

        noticia = new Noticia();
        noticia?.tipo = _tipo!;
        noticia?.titulo = _titulo!;
        noticia?.descripcion = _descripcion!;
        noticia?.link = _link!;
        noticia?.usuarioAlta = _usuarioAlta!;
        noticia?.documentID = _uid!;
        noticia?.fechaSubida = _fechaSubida!;
      });
    });
    return noticia;
  }

  void crearNoticia(String tipo, String titulo, String descripcion, String link) async{
    var fechaHoy = DateTime.now();
    String fechaSubida = '${fechaHoy.day}-${fechaHoy.month}-${fechaHoy.year}';
    String docId = new UniqueKey().toString();
    String usuarioAlta = await ControladorUsuario().obtenerNombreUsuario(firebaseAuth.currentUser!.uid);
    firestore.collection('noticias').doc(docId).set({
      'tipo': tipo,
      'titulo': titulo.trim(),
      'descripcion': descripcion,
      'link': link.trim().toLowerCase(),
      'usuarioAlta': usuarioAlta,
      'documentID': docId,
      'fechaSubida': fechaSubida,
    });
  }

  void editarNoticia(
      String tipoAnterior,
      String tituloAnterior,
      String descripcionAnterior,
      String linkAnterior,
      String tipoNuevo,
      String tituloNuevo,
      String descripcionNueva,
      String linkNuevo) async {
    Noticia? noticia = await obtenerNoticia(
        tipoAnterior, tituloAnterior, descripcionAnterior, linkAnterior);
    String? docId = noticia?.documentID;
    print('docID: $docId');

    firestore.collection("noticias").doc(docId).update({
      'titulo': tituloNuevo,
      'descripcion': descripcionNueva,
      'tipo': tipoNuevo,
      'link': linkNuevo.toLowerCase(),
    }).then((value) => print("Noticia Editado correctamente"));
  }

  void eliminarNoticia(
      String tipo, String titulo, String descripcion, String link) async {
    Noticia? noticia = await obtenerNoticia(tipo, titulo, descripcion, link);
    String? docId = noticia?.documentID;

    // primero elimino la senia
    await firestore
        .collection("noticias")
        .doc(docId)
        .delete()
        .then((value) => print("Noticia eliminado correctamente"));
  }

  Future<List<Noticia>> obtenerCharlas() async {
    List<Noticia> listaCharlas = [];

    await firestore
        .collection('noticias')
        .where('tipo', isEqualTo: 'CHARLAS')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _tipo = doc['tipo'];
        _titulo = doc['titulo'];
        _descripcion = doc['descripcion'];
        _link = doc['link'];
        _usuarioAlta = doc['usuarioAlta'];
        _fechaSubida = doc['fechaSubida'];

        noticia = new Noticia();

        noticia?.tipo = _tipo!;
        noticia?.titulo = _titulo!;
        noticia?.descripcion = _descripcion!;
        noticia?.link = _link!;
        noticia?.usuarioAlta = _usuarioAlta!;
        noticia?.fechaSubida = _fechaSubida!;

        listaCharlas.add(noticia!);
      });
    });
    listaCharlas.sort((a, b) {
      return b.fechaSubida.compareTo(a.fechaSubida);
    });

    return listaCharlas;
  }

  Future<List<Noticia>> obtenerLlamados() async {
    List<Noticia> listaLlamados = [];
    await firestore
        .collection('noticias')
        .where('tipo', isEqualTo: 'LLAMADOS')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _tipo = doc['tipo'];
        _titulo = doc['titulo'];
        _descripcion = doc['descripcion'];
        _link = doc['link'];
        _usuarioAlta = doc['usuarioAlta'];
        _fechaSubida = doc['fechaSubida'];

        noticia = new Noticia();

        noticia?.tipo = _tipo!;
        noticia?.titulo = _titulo!;
        noticia?.descripcion = _descripcion!;
        noticia?.link = _link!;
        noticia?.usuarioAlta = _usuarioAlta!;
        noticia?.fechaSubida = _fechaSubida!;

        listaLlamados.add(noticia!);
      });
    });
    listaLlamados.sort((a, b) {
      return b.fechaSubida.toString().compareTo(a.fechaSubida.toString());
    });

    return listaLlamados;
  }

  Future<List<Noticia>> obtenerNoticias() async {
    List<Noticia> listaNoticias = [];

    await firestore
        .collection('noticias')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _tipo = doc['tipo'];
        _titulo = doc['titulo'];
        _descripcion = doc['descripcion'];
        _link = doc['link'];
        _usuarioAlta = doc['usuarioAlta'];
        _fechaSubida = doc['fechaSubida'];

        noticia = new Noticia();

        noticia?.tipo = _tipo!;
        noticia?.titulo = _titulo!;
        noticia?.descripcion = _descripcion!;
        noticia?.link = _link!;
        noticia?.usuarioAlta = _usuarioAlta!;
        noticia?.fechaSubida = _fechaSubida!;

        listaNoticias.add(noticia!);
      });
    });
    listaNoticias.sort((a, b) {
      return b.fechaSubida.toString().compareTo(a.fechaSubida.toString());
    });

    return listaNoticias;
  }
}
