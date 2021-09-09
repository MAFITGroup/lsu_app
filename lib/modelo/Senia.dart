class Senia {
  String _usuarioAlta;
  String _nombre;
  String _categoria;

  Senia();


  String get usuarioAlta => _usuarioAlta;

  String get nombre => _nombre;

  String get categoria => _categoria;


  set usuarioAlta(String value) {
    _usuarioAlta = value;
  }

  set nombre(String value) {
    _nombre = value;
  }

  set categoria(String value) {
    _categoria = value;
  }

}
