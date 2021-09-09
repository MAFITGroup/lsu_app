class Usuario {
  String _uid;
  String _correo;
  String _nombreCompleto;
  String _telefono;
  String _localidad;
  String _especialidad;
  bool _esAdministrador;
  String _statusUsuario;

  Usuario();

  /* Usuario(this._uid, this._correo, this._nombreCompleto, this._telefono,
      this._localidad, this._especialidad, this._esAdministrador);
   */

  String get uid => _uid;

  String get correo => _correo;

  String get nombreCompleto => _nombreCompleto;

  String get telefono => _telefono;

  String get localidad => _localidad;

  String get especialidad => _especialidad;

  bool get esAdministrador => _esAdministrador;

  String get statusUsuario => _statusUsuario;

  set esAdministrador(bool value) {
    _esAdministrador = value;
  }

  set especialidad(String value) {
    _especialidad = value;
  }

  set localidad(String value) {
    _localidad = value;
  }

  set telefono(String value) {
    _telefono = value;
  }

  set nombreCompleto(String value) {
    _nombreCompleto = value;
  }

  set correo(String value) {
    _correo = value;
  }

  set uid(String value) {
    _uid = value;
  }

  set statusUsuario(String value){
    _statusUsuario = value;
  }
}
