import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/modelo/SubCategoria.dart';

class ControladorCategoria {
  String _nombreCategoria;
  final categoriasRef = FirebaseFirestore.instance.collection('categorias');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Categoria categoria;
  SubCategoria subCategoria;
  String _documentID;

  /*
  Crea la categoría
   */
  void crearCategoria(String nombre, List<String> listaDeSubs) {
    /*
    Pido al menos una subCategoria, sino tengo no dejo guardar.
     */
    if (listaDeSubs == null || listaDeSubs.isEmpty) {
      return;
    }

    String docId = new UniqueKey().toString(); //Clase que genera un id unico
    int index = 0;
    Map<String, String> subCategorias =
        new Map<String, String>(); //map para armar las subCategorias

    for (String nombre in listaDeSubs) {
      index++;
      subCategorias.putIfAbsent("nombreSub_$index",
          () => nombre.toUpperCase().trimLeft().trimRight());
    }

    //creo mi categoria
    firestore.collection("categorias").doc(docId).set({
      'documentID': docId,
      'nombre': nombre.toUpperCase().trimLeft().trimRight(),
      'subCategorias': subCategorias,
    });
  }

  void editarCategoria(String nombreAnterior, String nombreNuevo) async {
    Categoria categoria = await obtenerCategoriaPorNombre(nombreAnterior);
    String docId = categoria.documentID;

    firestore.collection("categorias").doc(docId).update({
      'nombre': nombreNuevo,
    }).then((value) => print("Categoria Editada correctamente"));
  }

  void eliminarCategoria(String nombre) async {
    Categoria categoria = await obtenerCategoriaPorNombre(nombre);
    String docId = categoria.documentID;

    firestore
        .collection("categorias")
        .doc(docId)
        .delete()
        .then((value) => print("Categoria Eliminada correctamente"));
  }

  /*
  Se usa para obtener el objeto categoria
  cuando entro a Visualizarla
   */
  Future<Categoria> obtenerCategoriaPorNombre(String nombreCategoria) async {
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



  /*
  Retorna una Lista Categoria con sus propiedades
   */
  Future<List<Categoria>> obtenerTodasCategorias() async {
    List<Categoria> lista = [];

    await categoriasRef.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _nombreCategoria = doc['nombre'];
        _documentID = doc['documentID'];

        categoria = new Categoria();
        categoria.nombre = _nombreCategoria;
        categoria.documentID = _documentID;

        lista.add(categoria);
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

    /*
    Ordeno por nombre
     */
    listaCategorias.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });

    return listaCategorias;
  }

  /*
  Retorna una lista de sub categorias solo con el nombre,
   */
  Future<List> listarSubCategorias() async {
    List subCategorias = [];
    List dataSubCat;
    QuerySnapshot querySnapshot = await categoriasRef.get();
    dataSubCat = querySnapshot.docs.map((doc) => doc["subCategorias"]).toList();

    Map<String, dynamic> mapSubCategorias =
        new Map<String, dynamic>(); //map para armar las subCategorias
    for (mapSubCategorias in dataSubCat) {
      for (String valor in mapSubCategorias.values) {
        if (valor != null && valor.isNotEmpty) {
          subCategorias.add(valor);
        }
      }
    }

    /*
    Ordeno por nombre
     */
    subCategorias.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });
    return subCategorias;
  }

  /*
  Retorna una lista de subCategorias
   segun la categoria principal
   */
  Future<List> listarSubCategoriasPorCategoria(String nombreCategoria) async {
    List subCategorias = [];
    List dataSubCat;
    QuerySnapshot querySnapshot =
        await categoriasRef.where('nombre', isEqualTo: nombreCategoria).get();
    dataSubCat = querySnapshot.docs.map((doc) => doc["subCategorias"]).toList();

    Map<String, dynamic> mapSubCategorias =
        new Map<String, dynamic>(); //map para armar las subCategorias
    for (mapSubCategorias in dataSubCat) {
      for (String keys in mapSubCategorias.values) {
        if (keys != null && keys.isNotEmpty) {
          subCategorias.add(keys);
        }
      }
    }

    /*
    Ordeno por nombre
     */
    subCategorias.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });
    return subCategorias;
  }

  void obtenerSeniaModifCat(String nombreAnterior, String nombreNuevo) async {
    await firestore
        .collection('senias')
        .where('categoria', isEqualTo: nombreAnterior)
        .get()
        .then((response) => {
              response.docs.forEach((doc) => {
                    firestore
                        .collection('senias')
                        .doc(doc.id)
                        .update({'categoria': nombreNuevo})
                  })
            });
  }

  Future<bool> existeCategoria(String nombre) async {
    bool existeCategoria = false;
    String nombreCat;

    if (nombre != null) {
      await categoriasRef
          .where('nombre',
              isEqualTo: nombre.toUpperCase().trimLeft().trimRight())
          .get()
          .then((query) {
        query.docs.forEach((element) {
          nombreCat = element.get('nombre').toString();
          if (nombreCat != null) {
            existeCategoria = true;
          }
        });
      });
    }
    return existeCategoria;
  }

  Future<bool> existeCategoriaenSenia(String nombre) async {
    bool existeCategoriaEnSenia = false;
    String nombreCat;

    if (nombre != null) {
      await firestore
          .collection('senias')
          .where('categoria', isEqualTo: nombre)
          .get()
          .then((query) {
        query.docs.forEach((element) {
          nombreCat = element.get('categoria').toString();
          if (nombreCat != null) {
            existeCategoriaEnSenia = true;
          }
        });
      });
    }
    return existeCategoriaEnSenia;
  }

  Future<bool> existeSubCategoria(String nombreSubCategoria) async {
    List subCategorias = await ControladorCategoria().listarSubCategorias();
    for (String subCat in subCategorias) {
      if (subCat == nombreSubCategoria) {
        return true;
      } else {
        return false;
      }
    }
  }
}
