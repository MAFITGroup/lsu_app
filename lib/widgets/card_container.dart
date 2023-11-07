import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget ?child;

  const CardContainer({Key ?key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: _cardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 15, offset: Offset(0, 0))
          ]);
}
