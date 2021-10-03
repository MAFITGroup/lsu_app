import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lsu_app/modelo/Senia.dart';

class ControladorSenia {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nombre;
  String categoria;
  String usuarioAlta;
  String descripcion;
  String urlVideo;
  Senia senia;

  void crearSenia(String usuarioAlta, String nombre, String descripcion,
      String categoria, String linkRefVideo) {
    String docId = nombre.trim() + categoria.trim();
    //creo mi senia
    firestore.collection("senias").doc(docId).set({
      'usuarioAlta': usuarioAlta,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'videoRef': linkRefVideo,
    });
  }

  Future<UploadTask> subirSeniaArchivo(String destino, File archivo) async {
    UploadTask subida;
    String downloadLink;
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putFile(archivo);
      downloadLink = await (await subida).ref.getDownloadURL();
      obtenerVideoDownloadLink(downloadLink);
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
  }

  Future<UploadTask> subirSeniaBytes(String destino, Uint8List archivo) async {
    UploadTask subida;
    String downloadLink;
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putData(archivo, SettableMetadata(contentType: 'video/mp4'));
      downloadLink = await (await subida).ref.getDownloadURL();
      obtenerVideoDownloadLink(downloadLink);
    } on FirebaseException catch (e) {
      print('error al subir bytes');
      return null;
    }
  }

  String obtenerVideoDownloadLink(String url) {
    if (url.isNotEmpty) {
      urlVideo = url;
    }
    return urlVideo;
  }

  Future<List<Senia>> obtenerTodasSenias() async {
    List<Senia> lista = [];

    await firestore
        .collection('senias')
        .get()
        .then((QuerySnapshot querySnapshot) {

      querySnapshot.docs.forEach((doc) {
        nombre = doc['nombre'];
        descripcion = doc['descripcion'];
        usuarioAlta = doc['usuarioAlta'];
        categoria = doc['categoria'];
        urlVideo = doc['videoRef'];

        senia = new Senia();

        senia.nombre = nombre;
        senia.descripcion = descripcion;
        senia.usuarioAlta = usuarioAlta;
        senia.categoria = categoria;
        senia.urlVideo = urlVideo;

        lista.add(senia);
      });

    });

    return lista;
  }
}
