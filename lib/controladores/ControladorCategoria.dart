import 'package:cloud_firestore/cloud_firestore.dart';

class ControladorCategoria {
  String _nombreCategoria;
  final categoriasRef = FirebaseFirestore.instance.collection('categorias');
  List _listaCategorias;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List> listarCategorias() async {
    QuerySnapshot querySnapshot = await categoriasRef.get();
    //obtengo solo el atributo del nombre para mostrar
    _listaCategorias = querySnapshot.docs.map((doc) => doc["nombre"]).toList();
    return _listaCategorias;
  }

  void crearCategoria(String nombre) {
    //creo mi categoria
    firestore.collection("categorias").doc(nombre).set({
      'nombre': nombre,
    });
  }
}
