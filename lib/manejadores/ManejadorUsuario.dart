import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ManejadorUsuario {
  void obtenerUsuarioLogueado(String usuarioActualUID) {
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (usuarioActualUID == firebaseAuth.currentUser.uid.toString()) {
      FutureBuilder<DocumentSnapshot>(
        // Como mi DOCID es igual a mi UID de mi usuario, lo obtengo a travez de mi UID
        future: usuarios.doc(usuarioActualUID).get(),
      );
    }

  }
}
