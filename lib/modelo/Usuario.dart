class Usuario {
  String _uid;
  String _correo;
  String _nombreCompleto;
  String _telefono;
  String _departamento;
  String _especialidad;
  bool _esAdministrador;
  String _statusUsuario;

  Usuario();

  String get uid => _uid;

  String get correo => _correo;

  String get nombreCompleto => _nombreCompleto;

  String get telefono => _telefono;

  String get departamento => _departamento;

  String get especialidad => _especialidad;

  bool get esAdministrador => _esAdministrador;

  String get statusUsuario => _statusUsuario;

  set esAdministrador(bool value) {
    _esAdministrador = value;
  }

  set especialidad(String value) {
    _especialidad = value;
  }

  set departamento(String value) {
    _departamento = value;
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

  set statusUsuario(String value) {
    _statusUsuario = value;
  }
}
