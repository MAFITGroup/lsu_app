class Categoria {
  late String _nombre;
  late String _documentID;
  late List<Categoria> subCategorias;

  Categoria();

  String get nombre => _nombre;

  String get documentID => _documentID;

  set nombre(String value) {
    _nombre = value;
  }

  set documentID(String value) {
    _documentID = value;
  }
}
