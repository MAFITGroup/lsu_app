import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {String ?labelText, IconData ?prefixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(0, 65, 116, 1)),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(0, 65, 116, 1), width: 2)),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color.fromRGBO(0, 65, 116, 1))
            : null);
  }
}
