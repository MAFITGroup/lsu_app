
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lsu_app/modelo/Usuario.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> crearUsuario(Usuario usuario) async {
    String error = "error";

    try {
      await _firestore.collection("usuarios").doc(usuario.uid).set({
        'correo': usuario.correo,
        'nombreCompleto': usuario.nombreCompleto,
        'telefono': usuario.telefono,
        'localidad': usuario.localidad,
        'especialidad': usuario.especialidad,
        'esAdministrador': usuario.esAdministrador,
      });
    } catch (e) {
      print(e);
    }
    return error;
  }
}
