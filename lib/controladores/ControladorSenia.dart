import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:firebase_performance/firebase_performance.dart';




class ControladorSenia {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Trace myTrace = FirebasePerformance.instance.newTrace("Senias");


  String _nombre;
  String _categoria;
  String _subCategoria;
  String _usuarioAlta;
  String _descripcion;
  String _urlVideo;
  Senia senia;
  String _documentID;
  int _cantidadVisualizaciones;



  Future<UploadTask> crearYSubirSenia(
      String idSenia,
      String nombre,
      String descripcion,
      String categoria,
      String subCategoria,
      String usuarioAlta,
      String destino,
      File archivo,
      int cantidadVisualizaciones) async {


    /*
    Primero subo el archivo
     */
    UploadTask subida;
    String downloadLink;
    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putFile(archivo);
      downloadLink = await (await subida).ref.getDownloadURL();

      //TODO chequear que el documentID no se va a repetir en las colecciones
      /*
      Creo la senia luego de obtener el link de la url
       */
      await firestore.collection("senias").doc(idSenia).set({
        /*
        guardo el docId porque me sirve para luego
        al editar, matchear el documento con el id
        correspondiente a la coleccion para saber identificar
        el doc a editar.
         */
        'documentID': idSenia,
        'usuarioAlta': usuarioAlta,
        'nombre': nombre,
        'descripcion': descripcion,
        'categoria': categoria,
        'subCategoria': subCategoria,
        'videoRef': downloadLink,
        'cantidadVisualizaciones': cantidadVisualizaciones,
      });
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
    myTrace.stop();
  }


  /*
  Este metodo se usa para la subida de la seña
  desde la web, ya que el reproductor de video es null en la web
  por lo tanto se pasa como @param un tipo de dato Uint8List
   */
  Future<UploadTask> crearYSubirSeniaWeb(
      String idSenia,
      String nombre,
      String descripcion,
      String categoria,
      String subCategoria,
      String usuarioAlta,
      String destino,
      Uint8List archivo,
      int cantidadVisualizaciones) async {


    /*
    Primero subo el archivo
     */
    UploadTask subida;
    String downloadLink;

    try {
      final ref = FirebaseStorage.instance.ref(destino);
      subida = ref.putData(archivo, SettableMetadata(contentType: "video/mp4"));
      downloadLink = await (await subida).ref.getDownloadURL();

      //TODO chequear que el documentID no se va a repetir en las colecciones
      /*
      Creo la senia luego de obtener el link de la url
       */
      await firestore.collection("senias").doc(idSenia).set({
        'documentID': idSenia,
        'usuarioAlta': usuarioAlta,
        'nombre': nombre,
        'descripcion': descripcion,
        'categoria': categoria,
        'subCategoria': subCategoria,
        'videoRef': downloadLink,
        'cantidadVisualizaciones': cantidadVisualizaciones,
      });
    } on FirebaseException catch (e) {
      print('error al subir archivo ');
      return null;
    }
    myTrace.stop();
  }

  /*
  Se usa para obtener el objeto Senia
  cuando entro a Visualizarla
   */
  Future<Senia> obtenerSenia(String nombreSenia, String descripcionSenia,
      String categoriaSenia, String subCategoriaSenia) async {
    await firestore
        .collection('senias')
        .where('nombre', isEqualTo: nombreSenia)
        .where('descripcion', isEqualTo: descripcionSenia)
        .where('categoria', isEqualTo: categoriaSenia)
        .where('subCategoria', isEqualTo: subCategoriaSenia)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();
        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;
      });
    });

    return senia;
  }

  /*
  Se usa para obtener el objeto Senia
  cuando entro a Visualizarla
   */
  Future<Senia> obtenerSeniaPorNombre(String nombreSenia) async {
    await firestore
        .collection('senias')
        .where('nombre', isEqualTo: nombreSenia)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();
        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;
      });
    });

    return senia;
  }

  void editarSenia(
      String nombreAnterior,
      String descripcionAnterior,
      String categoriaAnterior,
      String subCategoriaAnterior,
      String nombreNuevo,
      String descripcionNueva,
      String categoriaNueva,
      String subCategoriaNueva) async {
    Senia senia = await obtenerSenia(nombreAnterior, descripcionAnterior,
        categoriaAnterior, subCategoriaAnterior);
    String docId = senia.documentID;

    firestore.collection("senias").doc(docId).update({
      'nombre': nombreNuevo,
      'descripcion': descripcionNueva,
      'categoria': categoriaNueva,
      'subCategoria': subCategoriaNueva,
    }).then((value) => print("Seña Editada correctamente"));
  }

  void eliminarSenia(
    String nombre,
    String descripcion,
    String categoria,
    String subCategoria,
  ) async {
    Senia senia =
        await obtenerSenia(nombre, descripcion, categoria, subCategoria);
    String docId = senia.documentID;

    // primero elimino la senia
    await firestore
        .collection("senias")
        .doc(docId)
        .delete()
        .then((value) => print("Seña Eliminada correctamente"));

    // luego elimino el video
    await eliminarVideoSenia(docId);
  }

  Future eliminarVideoSenia(String docId) async {
    await storage
        .ref("Videos/$docId")
        .delete()
        .then((value) => print("Archivo eliminado correctamente"));
  }

  Future<List<Senia>> obtenerTodasSenias() async {
    List<Senia> lista = [];

    await firestore
        .collection('senias')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();

        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;

        lista.add(senia);
      });
    });

    /*
    Ordeno por nombre
     */
    lista.sort((a, b) {
      return a.nombre.toString().compareTo(b.nombre.toString());
    });

    return lista;
  }

  Future<List<Senia>> obtenerSeniasXCategoria(String nombreCategoria) async {
    List<Senia> lista = [];

    await firestore
        .collection('senias')
        .where('categoria', isEqualTo: nombreCategoria)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();

        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;

        lista.add(senia);
      });
    });

    /*
    Ordeno por nombre
     */
    lista.sort((a, b) {
      return a.nombre.toString().compareTo(b.nombre.toString());
    });

    return lista;
  }

  Future<List<Senia>> obtenerSeniasPorSubCategoria(
      String nombreSubCategoria) async {
    List<Senia> lista = [];

    await firestore
        .collection('senias')
        .where('subCategoria', isEqualTo: nombreSubCategoria)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();

        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;

        lista.add(senia);
      });
    });

    /*
    Ordeno por nombre
     */
    lista.sort((a, b) {
      return a.nombre.toString().compareTo(b.nombre.toString());
    });

    return lista;
  }

  Future<void> incrementarVisualizacionSenia(String nombreSenia) async {
    Senia senia = await obtenerSeniaPorNombre(nombreSenia);
    String docId = senia.documentID;
    // Pasa el usuario a estado inactivo
    await firestore
        .collection('senias')
        .doc(docId)
        .update({'cantidadVisualizaciones': FieldValue.increment(1)});
  }

  Future<List<Senia>> obtenerVisualizacionesSenia() async {
    List<Senia> lista = [];

    await firestore
        .collection('senias')
        .orderBy('cantidadVisualizaciones',descending: true)
        .limit(5)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombre = doc['nombre'];
        _descripcion = doc['descripcion'];
        _usuarioAlta = doc['usuarioAlta'];
        _categoria = doc['categoria'];
        _subCategoria = doc['subCategoria'];
        _urlVideo = doc['videoRef'];
        _documentID = doc['documentID'];
        _cantidadVisualizaciones = doc['cantidadVisualizaciones'];

        senia = new Senia();

        senia.nombre = _nombre;
        senia.descripcion = _descripcion;
        senia.usuarioAlta = _usuarioAlta;
        senia.categoria = _categoria;
        senia.subCategoria = _subCategoria;
        senia.urlVideo = _urlVideo;
        senia.documentID = _documentID;
        senia.cantidadVisualizaciones = _cantidadVisualizaciones;

        lista.add(senia);
      });
    });


    return lista;
  }
}
