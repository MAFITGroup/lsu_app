import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsu_app/manejadores/Colores.dart';
import 'package:lsu_app/widgets/BarraDeNavegacion.dart';


class Perfil extends StatefulWidget {
  const Perfil({Key key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BarraDeNavegacion(
            titulo: 'GESTIÓN DE USUARIOS',
          ),
              _manejoUsuarios(context),

        ],
      ),
    );
  }

  Widget _manejoUsuarios(context){

    int _selectedValue = 1;

    final Map<int, Widget> opciones = <int, Widget>{
      0:  _textStyle('ACTIVOS'),
      1:  _textStyle('PENDIENTES'),
      2:  _textStyle('INACTIVOS'),
    };

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children:<Widget> [

              CupertinoSegmentedControl<int>(

                borderColor: Colores().colorAzul,
                selectedColor: Colores().colorAzul,
                unselectedColor: Colores().colorBlanco,
                padding: EdgeInsets.all(10),
                children: opciones,

                groupValue: _selectedValue,
                onValueChanged: (val){
                  print(val);
                  setState((){
                    _selectedValue = val;
                  });
                },

              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _textStyle(String text) => Container(
    padding: EdgeInsets.all(12),
    child: Text(
      text,
      style: TextStyle(
          fontFamily: 'Trueno',
          fontSize: 10
      ),
    ),
  );



}