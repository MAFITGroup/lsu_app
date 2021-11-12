class Contenido {
  String _usuarioAlta;
  String _titulo;
  String _descripcion;
  String _categoria;
  String _autor;
  String _urlarchivo;
  String _documentID;

  Contenido();


  String get usuarioAlta => _usuarioAlta;

  String get titulo => _titulo;

  String get autor => _autor;

  String get descripcion => _descripcion;

  String get categoria => _categoria;

  String get urlarchivo => _urlarchivo;

  String get documentID => _documentID;



  set usuarioAlta(String value) {
    _usuarioAlta = value;
  }

  set titulo(String value) {
    _titulo = value;
  }

  set autor(String value) {
    _autor = value;
  }

  set descripcion(String value) {
    _descripcion = value;
  }

  set categoria(String value) {
    _categoria = value;
  }

  set urlarchivo(String value) {
    _urlarchivo = value;
  }

  set documentID(String value) {
    _documentID = value;
  }
}
