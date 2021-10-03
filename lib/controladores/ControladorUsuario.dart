import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lsu_app/modelo/Usuario.dart';

class ControladorUsuario {
  String _uid;
  String _correo;
  String _nombreCompleto;
  String _telefono;
  String _localidad;
  String _especialidad;
  bool _esAdministrador;
  String _statusUsuario;
  Usuario usuario = new Usuario();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void crearUsuario(
      String uid,
      String email,
      String nombreCompleto,
      String telefono,
      String localidad,
      String especialidad,
      bool esAdministrador,
      String statusUsuario){
    //creo mi nuevo usuario
    firestore.collection("usuarios").doc(firebaseAuth.currentUser.uid).set({
      'usuarioUID': uid,
      'correo': email,
      'nombreCompleto': nombreCompleto,
      'telefono': telefono,
      'localidad': localidad,
      'especialidad': especialidad,
      'esAdministrador': esAdministrador,
      'statusUsuario' : statusUsuario,
    });
  }

  Future<Usuario> obtenerUsuarioLogueado(String usuarioActualUID) async{
   await firestore
        .collection('usuarios')
        .doc(usuarioActualUID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _uid = documentSnapshot['usuarioUID'];
        _correo = documentSnapshot['correo'];
        _nombreCompleto = documentSnapshot['nombreCompleto'];
        _telefono = documentSnapshot['telefono'];
        _localidad = documentSnapshot['localidad'];
        _especialidad = documentSnapshot['especialidad'];
        _esAdministrador = documentSnapshot['esAdministrador'];
        _statusUsuario = documentSnapshot['statusUsuario'];

        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.localidad = _localidad;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        return usuario;
      }else{
        print('usuario null');
      }
    });

    return usuario;
  }

  Future<bool> isUsuarioAdministrador(String usuarioActualUID) async {
    usuario = await obtenerUsuarioLogueado(usuarioActualUID);
    if (usuario.esAdministrador == true) {
      print('Obtuve usuario administrador');
      return true;
    } else {
      print('NO obbtuve usuario administrador');
      return false;
    }
  }

  Future<Usuario> obtenerUsuarios(String stadoUsuario) async{

     var resultado = await firestore
        .collection('usuarios')
        .where('statusUsuario', isEqualTo: stadoUsuario )
        .get();
        resultado.docs.forEach((result) {
            result.get(_nombreCompleto);
            print(result.data());
          });
    }
    
    Future<bool> existeUsuario(String email) async{
      bool q = false;
      var resultado = await firestore
          .collection('usuarios')
          .where('correo', isEqualTo: email)
          .get();
          resultado.docs.forEach((result) {
            result.get(_correo);
            print(result.data());
            if(result != null){
              q = true;
              return q;
            }
          });
    }

    Future<String> obtenerNombreUsuario(String usuarioActualUID) async {
      usuario = await obtenerUsuarioLogueado(usuarioActualUID);
      return usuario.nombreCompleto;
    }


  }



