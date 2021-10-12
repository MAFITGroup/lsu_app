import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lsu_app/modelo/Categoria.dart';

class ControladorCategoria {
  String _nombreCategoria;
  final categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Categoria categoria;

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

  void crearCategoria(String nombre) {
    //creo mi categoria
    firestore.collection("categorias").doc(nombre).set({
      'nombre': nombre,
    });
  }
}
