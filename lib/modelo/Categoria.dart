class Categoria {

  String _nombre;
  String _documentID;


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