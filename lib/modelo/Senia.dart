class Senia {
  String _usuarioAlta;
  String _nombre;
  String _descripcion;
  String _categoria;
  String _urlVideo;

  Senia();


  String get usuarioAlta => _usuarioAlta;

  String get nombre => _nombre;

  String get descripcion => _descripcion;

  String get categoria => _categoria;

  String get urlVideo => _urlVideo;


  set usuarioAlta(String value) {
    _usuarioAlta = value;
  }

  set nombre(String value) {
    _nombre = value;
  }

  set descripcion(String value) {
    _descripcion = value;
  }

  set categoria(String value) {
    _categoria = value;
  }

  set urlVideo(String value) {
    _urlVideo = value;
  }

}
