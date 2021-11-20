import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorSenia.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Senia.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  bool isUsuarioAdmin = false;
  ControladorUsuario controladorUsuario = new ControladorUsuario();
  ControladorSenia controladorSenia = new ControladorSenia();
  Usuario usuario = new Usuario();
  int cantidadUsuariosActivos;
  int cantidadUsuariosRegistrados;

  List<Usuario> listaUsuarios = [];
  List<Senia> listaSenias = [];

  get onClickedNotification => null;

  @override
  void initState() {
    obtenerCantidadUsuariosActivos();
    obtenerCantidadUsuariosRegistrados();
    obtenerUsuarioAdministrador();
    obtenerDatosUsuarioLogueado();
    obtenerCantidadUsuarios();
    obtenerVisualizacionesSenia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        BarraDeNavegacion(
          titulo: Text("MENÚ",
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          listaWidget: [
            PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf_outlined,
                          color: Colores().colorAzul),
                      title: Text("Ayuda",
                          style: TextStyle(
                              fontFamily: 'Trueno',
                              fontSize: 14,
                              color: Colores().colorSombraBotones)),
                    )),
                PopupMenuItem(
                    value: 2,
                    child: ListTile(
                        leading: Icon(Icons.account_circle_outlined,
                            color: Colores().colorAzul),
                        title: Text("Perfil",
                            style: TextStyle(
                                fontFamily: 'Trueno',
                                fontSize: 14,
                                color: Colores().colorSombraBotones)))),
                PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colores().colorAzul),
                      title: Text('Cerrar Sesión',
                          style: TextStyle(
                              fontFamily: 'Trueno',
                              fontSize: 14,
                              color: Colores().colorSombraBotones)),
                    )),
              ],
            ),
          ],
        ),
        Center(
          child: Container(
              height: 420,
              width: 600,
              // Menu de dos columnas
              child: !isUsuarioAdmin
                  ? Column(
                      children: [
                        SizedBox(height: 50),
                        Boton(
                            onTap: Navegacion(context).navegarAGlosario,
                            titulo: 'GLOSARIO'),
                        Boton(
                            onTap: Navegacion(context).navegarABiblioteca,
                            titulo: 'BIBLIOTECA'),
                        Boton(
                            onTap: Navegacion(context).navegarANoticias,
                            titulo: 'NOTICIAS'),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: 50),
                        Boton(
                            onTap: Navegacion(context).navegarAGlosario,
                            titulo: 'GLOSARIO'),
                        Boton(
                            onTap: Navegacion(context).navegarABiblioteca,
                            titulo: 'BIBLIOTECA'),
                        Boton(
                            onTap: Navegacion(context).navegarANoticias,
                            titulo: 'NOTICIAS'),
                        Boton(
                            onTap: Navegacion(context).navegarACategorias,
                            titulo: 'CATEGORÍAS'),
                        Boton(
                            onTap: Navegacion(context)
                                .navegarAPaginaGestionUsuario,
                            titulo: 'GESTIÓN DE USUARIOS'),
                        SizedBox(height: 30),
                      ],
                    )),
        ),
        Center(
            child: Container(
                height: 600,
                width: 600,
                child: Column(children: [
                  Card(
                      child: ListTile(
                    title: Text(
                      "USUARIOS REGISTRADOS: $cantidadUsuariosRegistrados",
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Card(
                      child: ListTile(
                    title: Text(
                      "USUARIOS ACTIVOS: $cantidadUsuariosActivos",
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Card(
                      child: Column(
                    children: [
                      Text('SEÑAS MAS VISUALIZADAS',
                          style: TextStyle(
                              fontFamily: 'Trueno',
                              fontSize: 16,
                              color: Colores().colorAzul)),
                      Container(
                        height: 130,
                        alignment: Alignment.center,
                        child: ListView.builder(
                            itemCount: listaSenias.length,
                            itemBuilder: (context, index) {
                              return Text(
                                  listaSenias[index].nombre +
                                      ": " +
                                      listaSenias[index]
                                          .cantidadVisualizaciones
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Trueno', fontSize: 16));
                            }),
                      ),
                    ],
                  )),
                  Card(
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis:
                            NumericAxis(minimum: 0, maximum: 70, interval: 10),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        title: ChartTitle(
                            text: 'USUARIOS DISTRIBUIDOS EN NUESTRO PAÍS',
                            textStyle: TextStyle(
                                fontFamily: 'Trueno',
                                fontSize: 14,
                                color: Colores().colorAzul)),
                        series: <ChartSeries<Usuario, String>>[
                          ColumnSeries<Usuario, String>(
                              dataSource: listaUsuarios,
                              xValueMapper: (Usuario usuario, _) =>
                                  usuario.departamento,
                              yValueMapper: (Usuario usuario, _) =>
                                  obtenerCantidadUsuariosPorDepartamento(
                                      usuario.departamento),
                              name: usuario.departamento,
                              color: Colores().colorAzul)
                        ]),
                  )
                ]))),
      ]),
    ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 1:
        Navegacion(context).navegarManualDeUsuario();
        break;
      case 2:
        Navegacion(context).navegarAPerfil(usuario);
        break;
      case 0:
        AuthService().signOut();
        Navegacion(context).navegarAPrincipal();
        break;
    }
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await controladorUsuario
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }

  Future<void> obtenerDatosUsuarioLogueado() async {
    usuario = await controladorUsuario
        .obtenerUsuarioLogueado(FirebaseAuth.instance.currentUser.uid);

    if (usuario.statusUsuario == 'INACTIVO' ||
        usuario.statusUsuario == 'PENDIENTE') {
      AuthService().signOut();
    }
  }

  void obtenerCantidadUsuariosActivos() async {
    cantidadUsuariosActivos =
        await controladorUsuario.obtenerCantidadUsuariosActivos();
  }

  void obtenerCantidadUsuariosRegistrados() async {
    cantidadUsuariosRegistrados =
        await controladorUsuario.obtenerCantidadUsuariosRegistrados();
  }

  /*
  Para Grafica de Usuarios por Departamento
   */
  void obtenerCantidadUsuarios() async {
    listaUsuarios = await controladorUsuario.obtenerTodosUsuarios();
  }

  int obtenerCantidadUsuariosPorDepartamento(String nombreDepartamento) {
    int cantidadUsuariosPorDepartamento = 0;

    for (Usuario usuario in listaUsuarios) {
      if (usuario.departamento == nombreDepartamento) {
        cantidadUsuariosPorDepartamento++;
      }
    }
    return cantidadUsuariosPorDepartamento;
  }

  void obtenerVisualizacionesSenia() async {
    listaSenias = await controladorSenia.obtenerVisualizacionesSenia();
  }
}
