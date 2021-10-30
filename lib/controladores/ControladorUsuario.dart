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
        'correo': email.trim(),
        'nombreCompleto': nombreCompleto,
        'telefono': telefono,
        'localidad': localidad,
        'especialidad': especialidad,
        'esAdministrador': esAdministrador,
        'statusUsuario' : statusUsuario,
      });
    }

    Future<Usuario> obtenerUsuarioLogueado(String usuarioActualUID) async{
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

  /*
  Se usa al iniciar sesion, si el usuario.
  Ver uso en AuthService/ signIn
   */
  Future<String> obtenerEstadoUsuario(String mail) async {
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
        _localidad = doc['localidad'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.localidad = _localidad;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

              listaUsuariosPendientes.add(usuario);

            });
      });

      return listaUsuariosPendientes;
   }

   Future<List<Usuario>> obtenerUsuariosActivos() async {
    List<Usuario> listaUsuariosActivos = [];

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
        _localidad = doc['localidad'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.localidad = _localidad;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        listaUsuariosActivos.add(usuario);

            });
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
        _localidad = doc['localidad'];
        _especialidad = doc['especialidad'];
        _esAdministrador = doc['esAdministrador'];
        _statusUsuario = doc['statusUsuario'];

        usuario = new Usuario();
        usuario.uid = _uid;
        usuario.correo = _correo;
        usuario.nombreCompleto = _nombreCompleto;
        usuario.telefono = _telefono;
        usuario.localidad = _localidad;
        usuario.especialidad = _especialidad;
        usuario.esAdministrador = _esAdministrador;
        usuario.statusUsuario = _statusUsuario;

        listaUsuariosInactivos.add(usuario);

            });
      });

      return listaUsuariosInactivos;
   }

   void editarPerfil(
       String correoAnterior,
       String nombreAnterior,
       String celularAnterior,
       String departamentoAnterior,
       String especialidadAnterior,
       String correoNuevo,
       String nombreNuevo,
       String celularNuevo,
       String departamentoNuevo,
       String especialidadNueva,
       ) async {
      Usuario usuario = await obtenerUsuarioPerfil(
          correoAnterior);

      String usuarioId = usuario.uid;
      print(usuarioId);

      firestore.collection('usuarios')
      .doc(usuarioId)
      .update({
        'correo' : correoNuevo,
        'nombreCompleto' : nombreNuevo,
        'telefono' : celularNuevo,
        'localidad' : departamentoNuevo,
        'especialidad' : especialidadNueva,

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
              _localidad = doc['localidad'];
              _especialidad = doc['especialidad'];
              _uid = doc['usuarioUID'];

              usuario = new Usuario();
              usuario.correo = _correo;
              usuario.nombreCompleto = _nombreCompleto;
              usuario.telefono = _telefono;
              usuario.localidad = _localidad;
              usuario.especialidad = _especialidad;
              usuario.uid = _uid;
            });
      });

      return usuario;
   }

   void eliminarUsuarios( String correo) async {
        Usuario usuario = await obtenerUsuarioPerfil(correo);
        String docId = usuario.uid;

        // Elimina documento
        await firestore
            .collection('usuarios')
            .doc(docId)
            .delete()
            .then((value) => print('Usuario elimiando correctamente'));

        // Elimina del Authentication
        await firebaseAuth.currentUser.delete();

}

    void inactivarUsuario(
        String correo
        ) async {
      Usuario usuario = await obtenerUsuarioPerfil(correo);
      String docId = usuario.uid;

      // Pasa el usuario a estado inactivo
      await firestore
          .collection('usuarios')
          .doc(docId)
          .update({
        'statusUsuario': 'INACTIVO'
      })
          .then((value) => print('Usuario elimiando correctamente'));
    }

    void administrarUsuario(String correo, String estado, bool esAdministrador) async {

      Usuario usuario = await obtenerUsuarioPerfil(correo);
      String docId = usuario.uid;

      // Pasa el usuario a estado inactivo
      await firestore
          .collection('usuarios')
          .doc(docId)
          .update({
      'statusUsuario': estado,
      'esAdministrador': esAdministrador,
      })
          .then((value) => print('Usuario actualizado correctamente'));
    }


}



