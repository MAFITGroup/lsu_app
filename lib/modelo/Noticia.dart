class Noticia {
  String _titulo;
  String _descripcion;
  String _tipo;
  String _usuarioAlta;
  String _link;
  String _documentID;

  Noticia();

  String get titulo      => _titulo;
  String get descripcion => _descripcion;
  String get tipo        => _tipo;
  String get usuarioAlta => _usuarioAlta;
  String get link        => _link;
  String get documentID  => _documentID;


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
}
