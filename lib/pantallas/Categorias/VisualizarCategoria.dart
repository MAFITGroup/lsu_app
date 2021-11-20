import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/controladores/ControladorCategoria.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/manejadores/Validar.dart';
import 'package:lsu_app/modelo/Categoria.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';
import 'package:lsu_app/widgets/Boton.dart';
import 'package:lsu_app/widgets/DialogoAlerta.dart';
import 'package:lsu_app/widgets/SubCategoriaDinamica.dart';
import 'package:lsu_app/widgets/TextFieldTexto.dart';

class VisualizarCategoria extends StatefulWidget {
  final Categoria categoria;

  const VisualizarCategoria({Key key, this.categoria}) : super(key: key);

  @override
  _VisualizarCategoriaState createState() => _VisualizarCategoriaState();
}

class _VisualizarCategoriaState extends State<VisualizarCategoria> {
  bool modoEditar;
  ControladorCategoria _controladorCategoria = new ControladorCategoria();
  final formKey = new GlobalKey<FormState>();
  bool isCategoriaExistente = false;
  bool isCategoriaEnSenia = false;
  List<dynamic> listaSubCategorias = [];
  List<dynamic> listaSubCategoriasNuevas = [];
  List<SubCategoriaDinamica> listaDinamicaWidgetSubCategoria = [];
  List<SubCategoriaDinamica> WidgetSubCategoria = [];
  SubCategoriaDinamica subWidget;
  List<TextEditingController> controllers = <TextEditingController>[];
  TextEditingController controller = new TextEditingController();
  bool existeSubCategoriaEnSenia = false;
  String nombreSubCategoriaNuevo;

  //usadas para editar
  dynamic nuevoNombreCategoria;

  @override
  void initState() {
    setState(() {
      listarSubCategorias(widget.categoria.nombre);
      modoEditar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Categoria categoria = widget.categoria;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BarraDeNavegacion(
              titulo: Text('CATEGORÍA' + " - " + categoria.nombre.toUpperCase(),
                  style: TextStyle(fontFamily: 'Trueno', fontSize: 14)),
              listaWidget: [
                PopupMenuButton<int>(
                  /*
              Agregar en el metodo on Selected
              las acciones
               */
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: ListTile(
                          leading: Icon(
                              !modoEditar ? Icons.edit : Icons.cancel_outlined),
                          title: Text(!modoEditar
                              ? "Editar Categoría"
                              : "Cancelar Editar")),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                          leading: Icon(Icons.delete_forever_outlined),
                          title: Text("Eliminar Categoría")),
                    ),
                  ],
                ),
              ],
            ),
            Form(
              key: formKey,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldTexto(
                                  nombre: 'NOMBRE CATEGORÍA',
                                  icon: Icon(Icons.account_tree_outlined),
                                  habilitado: modoEditar,
                                  controlador: modoEditar
                                      ? null
                                      : TextEditingController(
                                          text: categoria.nombre),
                                  valor: (value) {
                                    this.nuevoNombreCategoria = value;
                                    existeCategoria(nuevoNombreCategoria);
                                  },
                                  validacion: ((value) => value.isEmpty
                                      ? 'Campo Obligatorio'
                                      : null),
                                ),
                              ),
                              Container(
                                  child: modoEditar
                                      ? FloatingActionButton(
                                          heroTag: "btnAgregar",
                                          onPressed: agregarWidgetSubCategoria,
                                          child: Icon(Icons.add),
                                          backgroundColor: Colores().colorAzul,
                                          splashColor:
                                              Colores().colorSombraBotones,
                                        )
                                      : null),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 600,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*z
                          Se arma el future con la cantidad de subcategorias de la cat.
                           */
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 300, minHeight: 56.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: listaSubCategorias.length,
                              itemBuilder: (context, index) {
                                subWidget = new SubCategoriaDinamica(
                                  modoEditar: modoEditar,
                                  modoAlta: false,
                                  nombreSubCategoria: listaSubCategorias[index],
                                  listaSubcategorias: listaSubCategoriasNuevas,
                                  controller: controller =
                                      new TextEditingController(
                                          text: listaSubCategorias[index]),
                                  onPressed: () async {
                                    existeSubCategoriaEnSenia =
                                        await _controladorCategoria
                                            .existeSubCategoriaEnSenia(
                                                listaSubCategorias[index]);
                                    if (!existeSubCategoriaEnSenia) {
                                      eliminarWidgetSubCategoria(
                                          categoria.nombre,
                                          listaSubCategorias[index],
                                          listaSubCategorias,
                                          index);
                                    } else {
                                      showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return DialogoAlerta(
                                              tituloMensaje: "Advertencia",
                                              mensaje:
                                                  "No es posible eliminar la subcategoría. La misma está asociada a una o más señas.",
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          });
                                    }
                                  },
                                );

                                if (!modoEditar) {
                                  controllers.add(controller);
                                  WidgetSubCategoria.add(subWidget);
                                }
                                return subWidget;
                              },
                            ),
                          ),
                          /*
                          Al presionar el boton para agregar mas sub categorias,
                          se agregan nuevos campos.
                           */
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 300, minHeight: 56.0),
                            child: ListView.builder(
                                itemCount:
                                    listaDinamicaWidgetSubCategoria.length,
                                itemBuilder: (context, index) =>
                                    listaDinamicaWidgetSubCategoria[index]),
                          ),
                        ],
                      ),
                    ),
                    modoEditar
                        ? Boton(
                            titulo: 'GUARDAR',
                            onTap: () {
                              if (nuevoNombreCategoria == null) {
                                nuevoNombreCategoria = categoria.nombre;
                              }
                              if (Validar().camposVacios(formKey)) {
                                if (listaSubCategorias.length == 0 &&
                                    listaSubCategoriasNuevas.length == 0) {
                                  return showCupertinoDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return DialogoAlerta(
                                          tituloMensaje: "Advertencia",
                                          mensaje:
                                              "Debe ingresar al menos una subcategoría.",
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                }
                                if (!isCategoriaExistente) {
                                  if (!existeSubCategoria(
                                      listaSubCategoriasNuevas)) {
                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Edicion de Categoría'),
                                            content: Text(
                                                '¿Confirma que desea modificar la Categoría Seleccionada?'),
                                            actions: [
                                              TextButton(
                                                  child: Text('Ok',
                                                      style: TextStyle(
                                                          color: Colores()
                                                              .colorAzul,
                                                          fontFamily: 'Trueno',
                                                          fontSize: 11.0,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline)),
                                                  onPressed: () {
                                                    guardarEdicion(
                                                        categoria.nombre,
                                                        nuevoNombreCategoria,
                                                        listaSubCategorias,
                                                        listaSubCategoriasNuevas)
                                                      ..then((userCreds) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showCupertinoDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder: (context) {
                                                              return DialogoAlerta(
                                                                tituloMensaje:
                                                                    'Edición Realizada',
                                                                mensaje:
                                                                    'La categoría se ha editado correctamente',
                                                                onPressed: () {
                                                                  /*
                                                                  dialogo alerta
                                                                   */
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  /*
                                                                  ventana visualizar
                                                                   */
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              );
                                                            });
                                                      });
                                                  }),
                                              TextButton(
                                                  child: Text('Cancelar',
                                                      style: TextStyle(
                                                          color: Colores()
                                                              .colorAzul,
                                                          fontFamily: 'Trueno',
                                                          fontSize: 11.0,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline)),
                                                  onPressed: () {
                                                    /*Al presionar Cancelar, cierro el dialogo y me quedo en la misma pag*/
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          );
                                        });
                                  } else {
                                    listaSubCategoriasNuevas.clear();
                                    return showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return DialogoAlerta(
                                            tituloMensaje: "Advertencia",
                                            mensaje:
                                                "Una de las subcategorías ingresadas esta repetida.",
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        });
                                  }
                                } else {
                                  showCupertinoDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return DialogoAlerta(
                                          tituloMensaje: "Advertencia",
                                          mensaje:
                                              "La categoría ingresada ya existe.",
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                }
                              }
                            })
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editarCategoria() {
    setState(() {
      modoEditar = true;
    });
  }

  void cancelarEditar() {
    setState(() {
      modoEditar = false;
    });
  }

  Future eliminarCategoria(String nombre) async {
    _controladorCategoria.eliminarCategoria(nombre);
  }

  Future<bool> existeCategoria(String nombre) async {
    isCategoriaExistente = await ControladorCategoria().existeCategoria(nombre);
  }

  Future<bool> existeCategoriaenSenia(String nombre) async {
    isCategoriaEnSenia =
        await ControladorCategoria().existeCategoriaenSenia(nombre);
  }

  Future<void> listarSubCategorias(String nombreCategoria) async {
    listaSubCategorias = await ControladorCategoria()
        .listarSubCategoriasPorCategoriaList(nombreCategoria);
    setState(() {});
  }

  agregarWidgetSubCategoria() {
    setState(() {
      listaDinamicaWidgetSubCategoria.add(new SubCategoriaDinamica(
        modoAlta: false,
        modoEditar: true,
        listaSubcategorias: listaSubCategoriasNuevas,
        onPressed: eliminarWidgetSubCategoriaAgregado,
      ));
    });
  }

  eliminarWidgetSubCategoriaAgregado() {
    setState(() {
      if (listaDinamicaWidgetSubCategoria.length > 0) {
        listaDinamicaWidgetSubCategoria
            .removeAt(listaDinamicaWidgetSubCategoria.length - 1);
      }
    });
  }

  void eliminarWidgetSubCategoria(String nombreCategoria,
      String nombreSubCategoria, List<dynamic> listaSubCate, int index) {
    /*
      Elimino esa categoria de la base
       */
    _controladorCategoria.eliminarSubCategoria(
        widget.categoria.nombre, listaSubCate[index], listaSubCategorias);

    setState(() {
      if (listaSubCategorias.length > 0) {
        listaSubCategorias.removeAt(index);
      }
      if (listaSubCategoriasNuevas.length > 0) {
        listaSubCategoriasNuevas.removeAt(index);
      }
      if (controllers.length > 0) {
        controllers.removeAt(index);
      }
      if (WidgetSubCategoria.length > 0) {
        WidgetSubCategoria.removeAt(index);
      }
    });
  }

  bool existeSubCategoria(List lista) {
    for (int i = 0; i < lista.length; i++) {
      if (lista.skip(i + 1).contains(lista[i])) {
        return true;
      }
    }
    return false;
  }

  /*
  Se pasan los params de nombre anterior
  para que el controlador los obtenga y pueda obtener
  el identificador del documento ya existente
  y setear los nuevos valores.
   */
  Future guardarEdicion(
      String nombreAnterior,
      String nombreNuevo,
      List<dynamic> listaDeSubsAnterior,
      List<dynamic> listaDeSubsNuevas) async {
    _controladorCategoria.editarCategoria(
        nombreAnterior, nombreNuevo, listaDeSubsAnterior, listaDeSubsNuevas);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        !modoEditar ? editarCategoria() : cancelarEditar();
        break;
      case 1:
        String nombreCategoria = widget.categoria.nombre;
        existeCategoriaenSenia(nombreCategoria);
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminacion de Categoría'),
                content: Text(
                    '¿Confirma que desea eliminar la Categoría Seleccionada?'),
                actions: [
                  TextButton(
                      child: Text('Ok',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (isCategoriaEnSenia == false) {
                          eliminarCategoria(widget.categoria.nombre);
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return DialogoAlerta(
                                  tituloMensaje: "Categoría Eliminada",
                                  mensaje:
                                      "La categoría ha sido eliminada correctamente.",
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                );
                              });
                        } else {
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return DialogoAlerta(
                                  tituloMensaje: "Advertencia",
                                  mensaje:
                                      "No es posible eliminar la categoría. La misma está asociada a una o más señas.",
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              });
                        }
                      }),
                  TextButton(
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: Colores().colorAzul,
                              fontFamily: 'Trueno',
                              fontSize: 11.0,
                              decoration: TextDecoration.underline)),
                      onPressed: () {
                        /*Al presionar Cancelar, cierro el dialogo y cierro la
                                                   ventana de visualizacion categoria
                                                     */
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
        break;
    }
  }
}
