class Noticia {
  late String _titulo;
  late String _descripcion;
  late String _tipo;
  late String _usuarioAlta;
  late String _link;
  late String _documentID;
  late String _fechaSubida;

  Noticia();

  String get titulo => _titulo;

  String get descripcion => _descripcion;

  String get tipo => _tipo;

  String get usuarioAlta => _usuarioAlta;

  String get link => _link;

  String get documentID => _documentID;

  String get fechaSubida => _fechaSubida;

  set titulo(String value) {
    _titulo = value;
  }

  set descripcion(String value) {
    _descripcion = value;
  }

  set usuarioAlta(String value) {
    _usuarioAlta = value;
  }

  set link(String value) {
    _link = value;
  }

  set tipo(String value) {
    _tipo = value;
  }

  set documentID(String value) {
    _documentID = value;
  }

  set fechaSubida(String value) {
    _fechaSubida = value;
  }
}
