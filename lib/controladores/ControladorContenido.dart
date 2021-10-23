import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/modelo/Contenido.dart';

class ControladorContenido {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  String titulo;
  String categoria;
  String usuarioAlta;
  String descripcion;
  String urlarchivo;
  Contenido contenido;
  String documentID;

  /*
  Se usa para obtener el objeto Senia
  cuando entro a Visualizarla
   */
  Future<Contenido> obtenerContenido(String tituloContenido, String descripcionContenido,
      String categoriaContenido) async {
    await firestore
        .collection('biblioteca')
        .where('titulo', isEqualTo: tituloContenido)
        .where('descripcion', isEqualTo: descripcionContenido)
        .where('categoria', isEqualTo: categoriaContenido)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        titulo = doc['titulo'];
        descripcion = doc['descripcion'];
        usuarioAlta = doc['usuarioAlta'];
        categoria = doc['categoria'];
        urlarchivo = doc['archivoRef'];
        documentID = doc['documentID'];

        contenido = new Contenido();
        contenido.titulo = titulo;
        contenido.descripcion = descripcion;
        contenido.usuarioAlta = usuarioAlta;
        contenido.categoria = categoria;
        contenido.urlarchivo = urlarchivo;
        contenido.documentID = documentID;
      });
    });

    return contenido;
  }
  void editarContenido(
      String tituloAnterior,
      String descripcionAnterior,
      String categoriaAnterior,
      String tituloNuevo,
      String descripcionNueva,
      String categoriaNueva) async {
    Contenido contenido = await obtenerContenido(
        tituloAnterior, descripcionAnterior, categoriaAnterior);
    String docId = contenido.documentID;

    firestore.collection("biblioteca").doc(docId).update({
      'titulo': tituloNuevo,
      'descripcion': descripcionNueva,
      'categoria': categoriaNueva,
    }).then((value) => print("Contenido Editado correctamente"));
  }

  void eliminarContenido(
      String titulo,
      String descripcion,
      String categoria,
      ) async {
    Contenido contenido = await obtenerContenido(titulo, descripcion, categoria);
    String docId = contenido.documentID;

    // primero elimino la senia
    await firestore
        .collection("biblioteca")
        .doc(docId)
        .delete()
        .then((value) => print("Contenido eliminado correctamente"));

    // luego elimino el video

    await eliminarArchivoContenido(contenido.urlarchivo);
  }

  Future eliminarArchivoContenido(String archivoRef) async{
    await storage
        .refFromURL(archivoRef)
        .delete()
        .then((value) => print("Archivo eliminado correctamente"));
  }

  Future<UploadTask> crearYSubirContenido(
      String titulo,
      String descripcion,
      String categoria,
      String usuarioAlta,
      String destino,
      File archivo) async {
    /*
    Primero subo el archivo
     */
    UploadTask subida;
    String downloadLink;
    String docId = new UniqueKey().toString();
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putFile(archivo);
      downloadLink = await (await subida).ref.getDownloadURL();

      //TODO chequear que el documentID no se va a repetir en las colecciones
      /*
      Creo el contenido luego de obtener el link de la url
       */
      await firestore.collection("biblioteca").doc(docId).set({
        /*
        guardo el docId porque me sirve para luego
        al editar, matchear el documento con el id
        correspondiente a la coleccion para saber identificar
        el doc a editar.
         */
        'documentID': docId,
        'usuarioAlta': usuarioAlta,
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'archivoRef': downloadLink,

      });
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
  }

  /*
  Este metodo se usa para la subida de la seña
  desde la web, ya que el reproductor de video es null en la web
  por lo tanto se pasa como @param un tipo de dato Uint8List
   */
  Future<UploadTask> crearYSubirContenidoBytes(
      String titulo,
      String descripcion,
      String categoria,
      String usuarioAlta,
      String destino,
      Uint8List archivo) async {
    /*
    Primero subo el archivo
     */
    UploadTask subida;
    String downloadLink;
    String docId = new UniqueKey().toString();
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putData(archivo, SettableMetadata(contentType: 'pdf'));
      downloadLink = await (await subida).ref.getDownloadURL();
      /*
      Creo la senia luego de obtener el link de la url
       */
      await firestore.collection("biblioteca").doc(docId).set({
        'documentID': docId,
        'usuarioAlta': usuarioAlta,
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'ArchivoRef': downloadLink,

      });
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
  }

  String obtenerVideoDownloadLink(String url) {
    if (url.isNotEmpty) {
      urlarchivo = url;
    }
    return urlarchivo;
  }

  Future<List<Contenido>> obtenerTodosContenido() async {
    List<Contenido> lista = [];

    await firestore
        .collection('biblioteca')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        titulo = doc['titulo'];
        descripcion = doc['descripcion'];
        usuarioAlta = doc['usuarioAlta'];
        categoria = doc['categoria'];
        urlarchivo = doc['ArchivoRef'];

        contenido = new Contenido();

        contenido.titulo = titulo;
        contenido.descripcion = descripcion;
        contenido.usuarioAlta = usuarioAlta;
        contenido.categoria = categoria;
        contenido.urlarchivo = urlarchivo;

        lista.add(contenido);
      });
    });

    return lista;
  }


}