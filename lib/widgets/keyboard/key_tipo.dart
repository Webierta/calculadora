import 'package:flutter/material.dart';

enum KeyTipo {
  number(backgroundColor: Colors.white24, textColor: Colors.white),
  operator(backgroundColor: Colors.white10, textColor: Color(0xffE78388)),
  funcion(backgroundColor: Colors.white10, textColor: Color(0xff26E8C6)),
  caracter(backgroundColor: Colors.white10, textColor: Colors.white),
  constante(backgroundColor: Colors.white24, textColor: Colors.blueAccent);

  final Color backgroundColor;
  final Color textColor;

  const KeyTipo({required this.backgroundColor, required this.textColor});
}
