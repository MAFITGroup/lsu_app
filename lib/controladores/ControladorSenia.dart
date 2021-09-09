import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ControladorSenia {
  String _usuarioAlta;
  String _nombre;
  String _categoria;
  String _idVideoAsociado;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void crearSenia(String usuarioAlta, String nombre, String categoria) {
    //creo mi senia
    firestore.collection("senias").doc(nombre.trim() + categoria).set({
      'usuarioAlta': usuarioAlta,
      'nombre': nombre,
      'categoria': categoria,
    });
  }

  void subirSeniaArchivo(String destino, File archivo) {
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      ref.putFile(archivo);
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
  }

  void subirSeniaBytes(String destino, Uint8List archivo) {
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      ref.putData(archivo, SettableMetadata(contentType: 'video/mp4'));
    } on FirebaseException catch (e) {
      print('error al subir bytes');
      return null;
    }
  }
}
