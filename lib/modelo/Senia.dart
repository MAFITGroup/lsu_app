class Senia {
  String _usuarioAlta;
  String _nombre;
  String _descripcion;
  String _categoria;
  String _subCategoria;
  String _urlVideo;
  String _documentID;
  int _cantidadVisualizaciones;

  Senia();


  String get usuarioAlta => _usuarioAlta;

  String get nombre => _nombre;

  String get descripcion => _descripcion;

  String get categoria => _categoria;

  String get subCategoria => _subCategoria;

  String get urlVideo => _urlVideo;

  String get documentID => _documentID;

  int get cantidadVisualizaciones=> _cantidadVisualizaciones;

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

  set subCategoria(String value) {
    _subCategoria = value;
  }

  set urlVideo(String value) {
    _urlVideo = value;
  }

  set documentID(String value) {
    _documentID = value;
  }

  set cantidadVisualizaciones(int value) {
    _cantidadVisualizaciones = value;
  }
}
