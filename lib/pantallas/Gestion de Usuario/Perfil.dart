
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/TextFieldNumerico.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class Perfil extends StatefulWidget {

  final Usuario usuario;
  const Perfil({Key key, this.usuario}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final formKey = new GlobalKey<FormState>();

  bool modoEditar;

  dynamic correoNuevo;
  dynamic nombreNuevo;
  dynamic celularNuevo;
  dynamic departamentoNuevo;
  dynamic especialidadNueva;

  ControladorUsuario _controladorUsuario = new ControladorUsuario();

  List departamentos = [
    'ARTIGAS',
    'CANELONES',
    'CERRO LARGO',
    'COLONIA',
    'DURAZNO',
    'FLORES',
    'FLORIDA',
    'LAVALLEJA',
    'MALDONADO',
    'MONTEVIDEO',
    'PAYSANDU',
    'RIO NEGRO',
    'RIVERA',
    'ROCHA',
    'SALTO',
    'SORIANO',
    'SAN JOSE',
    'TACUAREMBO',
    'TREINTA Y TRES'
  ];

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    setState(() {
      modoEditar = false;

    });
  }

  @override
  Widget build(BuildContext context) {

    Usuario usuario = widget.usuario;
    return Container(
      height: 600,
      width: 600,
      child: Center(
          child: Scaffold(
            body: SingleChildScrollView(
              child:
                Column(
                  children: [
                    BarraDeNavegacion(
                        titulo: Text("PERFIL",
                            style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
                        listaWidget: [
                          PopupMenuButton<int>(
                              onSelected: (item) => onSelected(context, item),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 0,
                                    child: ListTile(
                                      leading: Icon(!modoEditar ? Icons.edit : Icons.cancel_outlined),
                                    title: Text(!modoEditar ? 'Editar' : 'Cancelar'))),
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                      leading: Icon(Icons.delete_forever_outlined),
                                      title: Text('Eliminar')),

                                ),
                              ])
                        ]
                    ),
                    Padding (

                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: formKey,
                        child: Container(
                          child: Column(

                                    children: [

                                      SizedBox(height: 30.0),
                                      //CORREO
                                      TextFieldTexto(
                                          nombre: 'CORREO',
                                          icon: Icon(Icons.alternate_email_rounded),

                                          botonHabilitado: false,
                                          controlador: modoEditar
                                              ? null
                                              : TextEditingController(text: usuario.correo),

                                        /*
                                          valor: (value) {

                                            setState(() {
                                              correoNuevo = value.toLowerCase();
                                            });
                                          },

                                          validacion: (value) => value.isEmpty
                                              ? 'Campo obligatorio'
                                              : Validar().validarCorreo(value)
                                          */
                                      ),
                                      // NOMBRE COMPLETO
                                      TextFieldTexto(
                                          nombre: 'NOMBRE COMPLETO',
                                          icon: Icon(Icons.person),
                                          botonHabilitado: modoEditar,
                                          controlador: modoEditar
                                              ? null
                                              : TextEditingController(
                                              text: usuario.nombreCompleto),
                                          valor: (value) {
                                            setState(() {
                                              nombreNuevo = value.toUpperCase();
                                            });
                                          },
                                          validacion: ((value) => value.isEmpty
                                              ? 'Campo obligatorio'
                                              : null)),

                                      // CELULAR
                                      TextFieldNumerico(
                                          nombre: 'CELULAR',
                                          icon: Icon(Icons.phone),
                                          botonHabilitado: modoEditar,
                                          controlador: modoEditar
                                              ? null
                                              : TextEditingController(
                                              text: usuario.telefono),
                                          valor: (value) {
                                            setState(() {
                                              celularNuevo = value;
                                            });
                                          },
                                          validacion: (value) => value.isEmpty
                                              ? 'Campo obligatorio'
                                              : Validar().validarCelular(value)),

                                      // DEPARTAMENTO
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 25, right: 25),
                                        child: DropdownSearch(
                                          items: departamentos,
                                          enabled: modoEditar,
                                          selectedItem: usuario.localidad,
                                          onChanged: (value) {
                                            setState(() {
                                              departamentoNuevo = value.toUpperCase();
                                            });
                                          },
                                          validator: ((dynamic value) {
                                            if (value == null) {
                                              return "Campo obligatorio";
                                            } else {
                                              return null;
                                            }
                                          }),
                                          showSearchBox: true,
                                          clearButton: Icon(Icons.close,
                                              color: Colores().colorSombraBotones),
                                          dropDownButton: Icon(Icons.arrow_drop_down,
                                              color: Colores().colorSombraBotones),
                                          showClearButton: true,
                                          mode: Mode.DIALOG,
                                          dropdownSearchDecoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  fontFamily: 'Trueno',
                                                  fontSize: 12,
                                                  color: Colores().colorSombraBotones),
                                              hintText: "DEPARTAMENTO",
                                              prefixIcon:
                                              Icon(Icons.location_city_outlined),
                                              focusColor: Colores().colorSombraBotones,
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colores().colorSombraBotones),
                                              )),
                                          autoValidateMode: AutovalidateMode.always,
                                        ),
                                      ),

                                      // ESPECIALIDAD
                                      TextFieldTexto(
                                          nombre: 'ESPECIALIDAD',
                                          icon: Icon(Icons.military_tech_outlined),
                                          botonHabilitado: modoEditar,
                                          controlador: modoEditar
                                              ? null
                                              : TextEditingController(
                                              text: usuario.especialidad),
                                          valor: (value) {
                                            setState(() {
                                              especialidadNueva = value.toUpperCase();
                                            });
                                          },
                                          validacion: ((value) => value.isEmpty
                                              ? 'Campo obligatorio'
                                              : null)),
                                      SizedBox(height: 50.0),

                                      modoEditar
                                          ? Boton(
                                          titulo: 'Guardar',
                                          onTap: () {

                                            if (correoNuevo == null) {
                                              correoNuevo = usuario.correo;
                                            }
                                            if (nombreNuevo == null) {
                                              nombreNuevo = usuario.nombreCompleto;
                                            }
                                            if (celularNuevo == null) {
                                              celularNuevo = usuario.telefono;
                                            }
                                            if (departamentoNuevo == null) {
                                              departamentoNuevo = usuario.localidad;
                                            }
                                            if (especialidadNueva == null) {
                                              especialidadNueva =
                                                  usuario.especialidad;
                                            }
                                            if (Validar().camposVacios(formKey)) {
                                              guardarEdicionPerfil(
                                                  usuario.correo,
                                                  usuario.nombreCompleto,
                                                  usuario.telefono,
                                                  usuario.localidad,
                                                  usuario.especialidad,
                                                  correoNuevo,
                                                  nombreNuevo,
                                                  celularNuevo,
                                                  departamentoNuevo,
                                                  especialidadNueva)
                                                ..then((userCreds) {
                                                  showDialog(
                                                      useRootNavigator: false,
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Perfil actualzado'),
                                                          content: Text(
                                                              'Los datos han sido guardados correctamente'),
                                                          actions: [
                                                            TextButton(
                                                                child: Text('Ok',
                                                                    style: TextStyle(
                                                                        color: Colores()
                                                                            .colorAzul,
                                                                        fontFamily:
                                                                        'Trueno',
                                                                        fontSize:
                                                                        11.0,
                                                                        decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                                onPressed: () {


                                                                  Navigator.of(context).pop();
                                                                  Navegacion(context).navegarAPaginaInicialDest();
                                                                })
                                                          ],
                                                        );
                                                      });
                                                }

                                                );
                                            }

                                          })
                                          : Container(),
                                    ],
                                  )
                        ),
                      ),
                    )
                  ],
                ),

            ),
          )),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarPerfil() : canelarEditar();
        break;
      case 1:
        Navigator.of(context).pop();
        showDialog(
          barrierDismissible: true,
            context: context,
            builder: (context){
              return SimpleDialog(
                insetPadding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text('Eliminar o inactivar usuario'),

                    children: [
                      SizedBox(height: 10),
                      const ListTile(
                        leading: Icon(Icons.no_accounts),
                        title: Text('Inactivar usuario'),
                        subtitle: Text('Mediante esta opción el usuario pasa a modo inactivo, los datos se '
                            'conservan en la base de datos y se puede reactivar en cualquier momento.'),
                      ),
                      SizedBox(height: 10),
                      const ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Eliminar usuario'),
                        subtitle: Text('Mediante esta opción se eliminarán todos los datos del usuario'),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Boton(
                            titulo: 'Inactivar',
                            onTap: () {

                              Navegacion(context).navegarAPrincipalDest();
                              AuthService().signOut();
                              inactivarUsuario(widget.usuario.correo);

                            },
                          ),
                          SizedBox(height: 10),
                          Boton(
                            titulo: 'Eliminar',
                            onTap: () {
                              eliminarUsuario(widget.usuario.correo);
                              Navegacion(context).navegarAPrincipalDest();
                              AuthService().signOut();


                            },
                          )
                        ],
                      )

                    ],

              );
            });
        break;

    }
  }

  void editarPerfil() {
    setState(() {
      modoEditar = true;
    });
  }

  void canelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  Future guardarEdicionPerfil(
      String correoAnterior,
      String nombreAnterior,
      String celularAnterior,
      String departamentoAnterior,
      String especialidadAnterior,
      String correoNuevo,
      String nombreNuevo,
      String celularNuevo,
      String departamentoNuevo,
      String especialidadNueva,
      ) async {
    _controladorUsuario.editarPerfil(
        correoAnterior,
        nombreAnterior,
        celularAnterior,
        departamentoAnterior,
        especialidadAnterior,
        correoNuevo,
        nombreNuevo,
        celularNuevo,
        departamentoNuevo,
        especialidadNueva);
  }

  Future eliminarUsuario(String correo){
    _controladorUsuario.eliminarAuth();
    _controladorUsuario.eliminarUsuarios(correo);


  }

  Future inactivarUsuario(String correo){
    _controladorUsuario.inactivarUsuario(correo);
  }



}
