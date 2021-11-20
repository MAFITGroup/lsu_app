
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';

class ControladorUsuario {
  String _uid;
  String _correo;
  String _nombreCompleto;
  String _telefono;
  String _departamento;
  String _especialidad;
  bool _esAdministrador;
  String _statusUsuario;
  Usuario usuario = new Usuario();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  void crearUsuario(
    String uid,
    String email,
    String nombreCompleto,
    String telefono,
    String departamento,
    String especialidad,
    bool esAdministrador,
    String statusUsuario,
  ) async {
    await firestore.collection("usuarios").doc(uid).set({
      'usuarioUID': uid,
      'correo': email.trim(),
      'nombreCompleto': nombreCompleto,
      'telefono': telefono,
      'departamento': departamento,
      'especialidad': especialidad,
      'esAdministrador': esAdministrador,
      'statusUsuario': statusUsuario,
    });

/*    print('<---------- VERIFICACION DE MAIL');
     FirebaseAuth.instance.currentUser
        .sendEmailVerification()
        .whenComplete(() => print('email de verificacion envaido'));
*/
  }

  Future<Usuario> obtenerUsuarioLogueado(String usuarioActualUID) async {
    String usuarioActualUID = FirebaseAuth.instance.currentUser.uid;
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
        _departamento = documentSnapshot['departamento'];
        _especialidad = documentSnapshot['especialidad'];
        _esAdministrador = documentSnapshot['esAdministrador'];
        _statusUsuario = documentSnapshot['statusUsuario'];

        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        return usuario;
      }
    });

    return usuario;
  }

  Future<bool> isUsuarioAdministrador(String usuarioActualUID) async {
    usuario = await obtenerUsuarioLogueado(usuarioActualUID);
    if (usuario.esAdministrador == true) {
      return true;
    } else {
      return false;
    }
  }

  /*
  Se usa al iniciar sesion, si el usuario.
  Ver uso en AuthService/ signIn
   */
  Future<String> obtenerEstadoUsuario(String mail, BuildContext context) async {
    String usuarioEstado;
    await firestore
        .collection('usuarios')
        .where('correo', isEqualTo: mail)
        .get()
        .then((query) {
      query.docs.forEach((element) {
        usuarioEstado = element.get('statusUsuario').toString();
      });
    });
    return usuarioEstado;
  }

  Future<String> obtenerNombreUsuario(String usuarioActualUID) async {
    usuario = await obtenerUsuarioLogueado(usuarioActualUID);
    return usuario.nombreCompleto;
  }

  Future<List<Usuario>> obtenerTodosUsuarios() async {
    List<Usuario> listaUsuarios = [];

    await firestore
        .collection('usuarios')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _uid = doc['usuarioUID'];
        _correo = doc['correo'];
        _nombreCompleto = doc['nombreCompleto'];
        _telefono = doc['telefono'];
        _departamento = doc['departamento'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        listaUsuarios.add(usuario);
      });
    });
    listaUsuarios.sort((a, b) {
      return a.nombreCompleto.compareTo(b.nombreCompleto);
    });
    return listaUsuarios;
  }

  Future<List<Usuario>> obtenerUsuariosPendiente() async {
    List<Usuario> listaUsuariosPendientes = [];
    await firestore
        .collection('usuarios')
        .where('statusUsuario', isEqualTo: 'PENDIENTE')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _uid = doc['usuarioUID'];
        _correo = doc['correo'];
        _nombreCompleto = doc['nombreCompleto'];
        _telefono = doc['telefono'];
        _departamento = doc['departamento'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        listaUsuariosPendientes.add(usuario);
      });
    });
    listaUsuariosPendientes.sort((a, b) {
      return a.nombreCompleto.compareTo(b.nombreCompleto);
    });
    return listaUsuariosPendientes;
  }

  Future<List<Usuario>> obtenerUsuariosActivos() async {
    List<Usuario> listaUsuariosActivos = [];
    Usuario usuarioLogueado =
    await obtenerUsuarioLogueado(firebaseAuth.currentUser.uid);
    await firestore
        .collection('usuarios')
        .where('statusUsuario', isEqualTo: 'ACTIVO')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _uid = doc['usuarioUID'];
        _correo = doc['correo'];
        _nombreCompleto = doc['nombreCompleto'];
        _telefono = doc['telefono'];
        _departamento = doc['departamento'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        if (usuario.correo != usuarioLogueado.correo) {
          listaUsuariosActivos.add(usuario);
        }
      });
    });
    listaUsuariosActivos.sort((a, b) {
      return a.nombreCompleto.compareTo(b.nombreCompleto);
    });
    return listaUsuariosActivos;
  }

  Future<List<Usuario>> obtenerUsuariosInactivos() async {
    List<Usuario> listaUsuariosInactivos = [];
    await firestore
        .collection('usuarios')
        .where('statusUsuario', isEqualTo: 'INACTIVO')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _uid = doc['usuarioUID'];
        _correo = doc['correo'];
        _nombreCompleto = doc['nombreCompleto'];
        _telefono = doc['telefono'];
        _departamento = doc['departamento'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        listaUsuariosInactivos.add(usuario);
      });
    });
    listaUsuariosInactivos.sort((a, b) {
      return a.nombreCompleto.compareTo(b.nombreCompleto);
    });
    return listaUsuariosInactivos;
  }

  void editarPerfil(String correoAnterior,
      String nombreAnterior,
      String celularAnterior,
      String departamentoAnterior,
      String especialidadAnterior,
      String correoNuevo,
      String nombreNuevo,
      String celularNuevo,
      String departamentoNuevo,
      String especialidadNueva,) async {
    Usuario usuario = await obtenerUsuarioPerfil(correoAnterior);
    String usuarioId = usuario.uid;
    firestore.collection('usuarios').doc(usuarioId).update({
      'correo': correoNuevo,
      'nombreCompleto': nombreNuevo.trim(),
      'telefono': celularNuevo.trim(),
      'departamento': departamentoNuevo,
      'especialidad': especialidadNueva.trim(),
    }).then((value) => print('Usuario editado correctamente'));
  }

  Future<Usuario> obtenerUsuarioPerfil(String correo) async {
    await firestore
        .collection('usuarios')
        .where('correo', isEqualTo: correo)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _correo = doc['correo'];
        _nombreCompleto = doc['nombreCompleto'];
        _telefono = doc['telefono'];
        _departamento = doc['departamento'];
        _especialidad = doc['especialidad'];
        _uid = doc['usuarioUID'];

        usuario = new Usuario();
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.departamento = _departamento;
        usuario.especialidad = _especialidad;
        usuario.uid = _uid;
      });
    });
    return usuario;
  }

  void eliminarUsuarios(String correo) async {
    Usuario usuario = await obtenerUsuarioPerfil(correo);
    String docId = usuario.uid;
    await firestore
        .collection('usuarios')
        .doc(docId)
        .delete()
        .then((value) => print('Usuario elimiando correctamente'));
  }

  Future eliminarAuth() async {
    await firebaseAuth.currentUser.delete();
  }

  void inactivarUsuario(String correo) async {
    Usuario usuario = await obtenerUsuarioPerfil(correo);
    String docId = usuario.uid;

    // Pasa el usuario a estado inactivo
    await firestore
        .collection('usuarios')
        .doc(docId)
        .update({'statusUsuario': 'INACTIVO'}).then(
            (value) => print('Usuario modificado correctamente'));
  }

  void reactivarUsuario(String correo, context) async {
    Usuario usuario = await obtenerUsuarioPerfil(correo);
    String docId = usuario.uid;
    await firestore
        .collection('usuarios')
        .doc(docId)
        .update({'statusUsuario': 'PENDIENTE'}).then((value) =>
    {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogoAlerta(
              tituloMensaje: "Solicitud de reactivación de usuario",
              mensaje:
              "Su solicitud esta pendiente de aprobación del administrador",
              onPressed: Navegacion(context).navegarALoginDest,
            );
          })
    });
  }

  void administrarUsuario(String correo, String estado,
      bool esAdministrador) async {
    Usuario usuario = await obtenerUsuarioPerfil(correo);
    String docId = usuario.uid;
    await firestore.collection('usuarios').doc(docId).update({
      'statusUsuario': estado,
      'esAdministrador': esAdministrador,
    }).then((value) => print('Usuario actualizado correctamente'));
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    List<Usuario> listaUsuarios = [];
    await firestore
        .collection('usuarios')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombreCompleto = doc['nombreCompleto'];
        _correo = doc['correo'];
        _departamento = doc['departamento'];
        _esAdministrador = doc['esAdministrador'];
        _especialidad = doc['especialidad'];
        _statusUsuario = doc['statusUsuario'];
        _telefono = doc['telefono'];

        usuario = new Usuario();

        usuario.nombreCompleto = _nombreCompleto;
        usuario.correo = _correo;
        usuario.departamento = _departamento;
        usuario.esAdministrador = _esAdministrador;
        usuario.especialidad = _especialidad;
        usuario.statusUsuario = _statusUsuario;
        usuario.telefono = _telefono;

        listaUsuarios.add(usuario);
      });
    });
    listaUsuarios.sort((a, b) {
      return a.nombreCompleto.toString().compareTo(b.nombreCompleto.toString());
    });

    return listaUsuarios;
  }

  Future<int> obtenerCantidadUsuariosActivos() async {
    int cantidadUsuariosActivos;

    QuerySnapshot documentos = await firestore
        .collection('usuarios')
        .where('statusUsuario', isEqualTo: 'ACTIVO')
        .get();
    List<DocumentSnapshot> listaDeDocumentos = documentos.docs;
    cantidadUsuariosActivos = listaDeDocumentos.length;

    return cantidadUsuariosActivos;
  }

  Future<int> obtenerCantidadUsuariosRegistrados() async {
    int cantidadUsuariosRegistrados;

    QuerySnapshot documentos = await firestore.collection('usuarios').get();
    List<DocumentSnapshot> listaDeDocumentos = documentos.docs;
    cantidadUsuariosRegistrados = listaDeDocumentos.length;

    return cantidadUsuariosRegistrados;
  }
}
