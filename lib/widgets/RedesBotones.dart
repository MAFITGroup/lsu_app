import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lsu_app/manejadores/Colores.dart';

class RedesBotones extends StatefulWidget {
  final VoidCallback ?onTap;
  final IconData ?icon;

  const RedesBotones({Key ?key, this.onTap, this.icon}) : super(key: key);

  @override
  _RedesBotonesState createState() => _RedesBotonesState();
}

class _RedesBotonesState extends State<RedesBotones> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 50,
        height: 50,
        child: Center(
          child: FaIcon(widget.icon, color: Colores().colorAzul, size: 40),
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
