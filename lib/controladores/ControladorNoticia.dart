
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/modelo/Noticia.dart';



class ControladorNoticia {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String _tipo;
  String _titulo;
  String _descripcion;
  String _link;
  String _uid;

  String _usuarioAlta;

  Noticia noticia;

  Future<Noticia> obtenerNoticia(String tipoNoticia, String tituloNoticia, String descripcionNoticia,
       String linkNoticia) async {
    await firestore
        .collection('noticias')
        .where('titulo', isEqualTo: tituloNoticia)
        .where('descripcion', isEqualTo: descripcionNoticia)
        .where('tipo', isEqualTo: tipoNoticia)
        .where('link', isEqualTo: linkNoticia)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _titulo      = doc['titulo'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _tipo        = doc['categoria'];
        _link        = doc['link'];
        _uid         = doc['documentID'];

        noticia             = new Noticia();
        noticia.titulo      = _titulo;
        noticia.descripcion = _descripcion;
        noticia.usuarioAlta = _usuarioAlta;
        noticia.tipo        = _tipo;
        noticia.link        = _link;
        noticia.documentID  = _uid;
      });
      return noticia;
    });

  }
  
  void crearNoticia(
      String tipo,
      String titulo,
      String descripcion,
      String link,
      String usuarioAlta
      ){
    String docId = new UniqueKey().toString();
    firestore.collection('noticias').doc(docId).set({
      'tipo'       : tipo,
      'titulo'     : titulo.trim(),
      'descripcion': descripcion,
      'link'       : link.trim(),
      'usuarioAlta': usuarioAlta,
      'documentID' : docId,
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
    Noticia noticia = await obtenerNoticia(
        tipoAnterior,
        tituloAnterior,
        descripcionAnterior,
        linkAnterior);
    String docId = noticia.documentID;
    print('docID: $docId');

    firestore.collection("noticias")
        .doc(docId)
        .update({
      'titulo': tituloNuevo,
      'descripcion': descripcionNueva,
      'tipo': tipoNuevo,
      'link': linkNuevo,
    }).then((value) => print("Noticia Editado correctamente"));
  }

  void eliminarNoticia(
      String titulo,
      String descripcion,
      String tipo,
      String link
      ) async {
    Noticia noticia = await obtenerNoticia(titulo, descripcion, tipo, link);
    String docId = noticia.documentID;

    // primero elimino la senia
    await firestore
        .collection("noticias")
        .doc(docId)
        .delete()
        .then((value) => print("Noticia eliminado correctamente"));
    
  }
  
  Future<List<Noticia>> obtenerNoticias() async {
    List<Noticia> listaNoticias = [];

    await firestore
        .collection('noticias')
        .where('tipo', isEqualTo: 'NOTICIAS')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _tipo = doc['tipo'];
        _titulo = doc['titulo'];
        _descripcion = doc['descripcion'];
        _link = doc['link'];
        _usuarioAlta = doc['usuarioAlta'];
        
        noticia = new Noticia();

        noticia.tipo = _tipo;
        noticia.titulo = _titulo;
        noticia.descripcion = _descripcion;
        noticia.link = _link;
        noticia.usuarioAlta = _usuarioAlta;


        listaNoticias.add(noticia);

      });

    });

    return listaNoticias;
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
        
        noticia = new Noticia();

        noticia.tipo = _tipo;
        noticia.titulo = _titulo;
        noticia.descripcion = _descripcion;
        noticia.link = _link;
        noticia.usuarioAlta = _usuarioAlta;
        
        listaLlamados.add(noticia);

      });

    });

    return listaLlamados;
  }
}