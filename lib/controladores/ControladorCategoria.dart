import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/modelo/Categoria.dart';

class ControladorCategoria {
  String _nombreCategoria;
  String _documentID;

  final categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Categoria categoria;

  /*
  Crea la categoría
   */
  void crearCategoria(String nombre) {
    String docId = new UniqueKey().toString();
    //creo mi categoria
    firestore.collection("categorias").doc(docId).set({
      'documentID': docId,
      'nombre': nombre,
    });
  }

  /*
  Se usa para obtener el objeto categoria
  cuando entro a Visualizarla
   */
  Future<Categoria> obtenerCategoria(String nombreCategoria) async {
    await firestore
        .collection('categorias')
        .where('nombre', isEqualTo: nombreCategoria)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombreCategoria = doc['nombre'];
        _documentID = doc['documentID'];

        categoria = new Categoria();
        categoria.nombre = _nombreCategoria;
        categoria.documentID = _documentID;
      });
    });

    return categoria;
  }

  void editarCategoria(String nombreAnterior, String nombreNuevo) async {
    Categoria categoria = await obtenerCategoria(nombreAnterior);
    String docId = categoria.documentID;

    firestore.collection("categorias").doc(docId).update({
      'nombre': nombreNuevo,
    }).then((value) => print("Categoria Editada correctamente"));
  }

  void eliminarCategoria(String nombre) async {
    Categoria categoria = await obtenerCategoria(nombre);
    String docId = categoria.documentID;

    firestore
        .collection("categorias")
        .doc(docId)
        .delete()
        .then((value) => print("Categoria Eliminada correctamente"));
  }

  /*
  Retorna una Lista Categoria con sus propiedades
   */
  Future<List<Categoria>> obtenerTodasCategorias() async {
    List<Categoria> lista = [];

    await firestore
        .collection('categorias')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombreCategoria = doc['nombre'];

        categoria = new Categoria();
        categoria.nombre = _nombreCategoria;

        lista.add(categoria);
      });
    });

    return lista;
  }

  /*
  Retorna una lista de categorias solo con el nombre,
  en este caso, lo uso para listar categorias
  en el combo de categorias
   */
  Future<List> listarCategorias() async {
    List listaCategorias = [];
    QuerySnapshot querySnapshot = await categoriasRef.get();
    //obtengo solo el atributo del nombre para mostrar
    listaCategorias = querySnapshot.docs.map((doc) => doc["nombre"]).toList();
    return listaCategorias;
  }

  void obtenerSeniaModifCat(String nombreAnterior, String nombreNuevo) async {
    var batch = FirebaseFirestore.instance.batch();
    await firestore
        .collection('senias')
        .where('categoria', isEqualTo: nombreAnterior)
        .get()
        .then((response) =>
    {
      response.docs.forEach((doc) =>
      {
        firestore.collection('senias').doc(doc.id).update(
            { 'categoria': nombreNuevo})
      })
    });
  }

  /*obtenerCategoriaExistente(String nombreNuevo) async {
    List<Categoria> lista = [];

    await firestore
        .collection('categorias')
        .where('categoria', isEqualTo: nombreNuevo)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombreCategoria = doc['nombre'];

        categoria = new Categoria();
        categoria.nombre = _nombreCategoria;

        lista.add(categoria);
      });
    });

    return lista;
  }*/
}
