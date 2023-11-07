import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget ?child;

  const AuthBackground({
    Key ?key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _ContainerBox(),

          SafeArea(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only( top: 30 ),
                child: Icon( Icons.person_pin, color: Color.fromRGBO(255, 255, 255, 1), size: 100),
              ),
          ),

          this.child!,

          
        ],
      ),
    );
  }
}


class _ContainerBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _boxDecoration(),
      child: Stack(
        children: [
          Positioned(child: _Bubbles(), top: 90, left: 30),
          Positioned(child: _Bubbles(), top: -40, left: -30),
          Positioned(child: _Bubbles(), bottom: -50, left: -20),
          Positioned(child: _Bubbles(), bottom: -10, left: 110),
          Positioned(child: _Bubbles(), bottom: 120, right: 20),
          Positioned(child: _Bubbles(), bottom: 60, right: 140),
          Positioned(child: _Bubbles(), bottom: 10, right: 40),

        ],
      ),
    );
  }

  BoxDecoration _boxDecoration () => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(	0, 65, 116, 1),
        Color.fromRGBO( 74, 121, 178, 1)
      ]
    )
  );
}

class _Bubbles extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.1)
      ),
    );
  }
}

