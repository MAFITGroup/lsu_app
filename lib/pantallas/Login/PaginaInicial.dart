import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/controladores/ControladorUsuario.dart';
import 'package:lsu_app/manejadores/Navegacion.dart';
import 'package:lsu_app/modelo/Usuario.dart';
import 'package:lsu_app/servicios/AuthService.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  bool isUsuarioAdmin = false;
  ControladorUsuario controladorUsuario = new ControladorUsuario();

  Usuario usuario = new Usuario();
  int activoUsuarios;

  List<_ChartData> data;
  TooltipBehavior _tooltip;

  get onClickedNotification => null;

  @override
  void initState() {
    usuariosActivos();
    obtenerUsuarioAdministrador();
    datosUsuario();
    data = [
      _ChartData('MONTEVIDEO', 12),
      _ChartData('CANELONES', 15),
      _ChartData('MALDONADO', 30),
      _ChartData('LAVALLEJA', 6.4),
      _ChartData('PAYSANDÚ', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        BarraDeNavegacion(
          titulo: Text("MENU",
              style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
          listaWidget: [
            PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Cerrar Sesión'),
                    )),
                PopupMenuItem(
                    value: 1,
                    child: ListTile(
                        leading: Icon(Icons.account_circle_outlined),
                        title: Text("Perfil"))),
                PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf_outlined),
                      title: Text("Ayuda"),
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
                            titulo: 'CATEGORIAS'),
                        Boton(
                            onTap: Navegacion(context)
                                .navegarAPaginaGestionUsuario,
                            titulo: 'GESTIÓN DE USUARIOS'),
                      ],
                    )),
        ),
        Center(
            child: Container(
                height: 100,
                width: 600,
                child: Column(children: [
                  Card(
                      child: ListTile(
                    title: Text(
                      "USUARIOS REGISTRADOS: " +  activoUsuarios.toString(),
                      textAlign: TextAlign.center,

                    ),
                  ))
                ]))),
        Center(
            child: Container(
                height: 500,
                width: 600,
                child: Column(children: [
                  //Initialize the chart widget
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis:
                          NumericAxis(minimum: 0, maximum: 40, interval: 10),
                      title: ChartTitle(
                          text: 'USUARIOS DISTRIBUIDOS EN NUESTRO PAÍS',
                          textStyle: TextStyle(
                              fontFamily: 'Trueno',
                              fontSize: 14,
                              color: Color.fromRGBO(0, 65, 116, 1))),
                      tooltipBehavior: _tooltip,
                      series: <ChartSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Color.fromRGBO(0, 65, 116, 1))
                      ]),
                ])))
      ]),
    ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        AuthService().signOut();
        Navegacion(context).navegarAPrincipalDest();
        break;
      case 1:
        Navegacion(context).navegarAPerfil(usuario);
        break;
      case 2:
        Navegacion(context).navegarManualDeUsuario();
        break;
    }
  }

  Future<void> obtenerUsuarioAdministrador() async {
    isUsuarioAdmin = await ControladorUsuario()
        .isUsuarioAdministrador(FirebaseAuth.instance.currentUser.uid);
    /*
    setState para que la pagina se actualize sola si el usuario es administrador.
     */
    setState(() {
      isUsuarioAdmin;
    });
  }

  Future<void> datosUsuario() async {
    usuario = await controladorUsuario
        .obtenerUsuarioLogueado(FirebaseAuth.instance.currentUser.uid);

    if (usuario.statusUsuario == 'INACTIVO' ||
        usuario.statusUsuario == 'PENDIENTE') {
      AuthService().signOut();
    }
  }

  Future<void> usuariosActivos() async {
    activoUsuarios =
        await ControladorUsuario().obtenerCantidadUsuariosActivos();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
