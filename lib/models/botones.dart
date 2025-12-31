import 'package:flutter/material.dart';

enum BotonFuncion {
  limpiar(simbolo: 'AC'),
  deshacer(simbolo: '⌫'),
  //copiar(simbolo: '🗐'),
  copiar(simbolo: '⎘'),
  pegar(simbolo: '⎗'),
  redondeo(simbolo: '.00');

  final String simbolo;

  const BotonFuncion({required this.simbolo});

  Color get textColor => Color(0xff26E8C6);

  Color get botonColor => Colors.white10;
}

enum BotonOperacion {
  sumar(simbolo: '+'),
  restar(simbolo: '-'),
  multiplicar(simbolo: 'x'),
  dividir(simbolo: '÷'),
  porcentaje(simbolo: '％'),
  modulo(simbolo: 'mod'),
  raiz(simbolo: '√'),
  exponente(simbolo: '^'),
  cuadrado(simbolo: '^2'),
  factorial(simbolo: '!'),
  igual(simbolo: '=');

  final String simbolo;

  const BotonOperacion({required this.simbolo});

  Color get textColor => Color(0xffE78388);

  Color get botonColor => Colors.white10;
}

enum BotonCaracter {
  decimal(simbolo: '.'),
  parentesisOn(simbolo: '('),
  parentesisOff(simbolo: ')'),
  corcheteOn(simbolo: '{'),
  corcheteOff(simbolo: '}'),
  cambioSigno(simbolo: '±'),
  dobleCero(simbolo: '00');

  final String simbolo;

  const BotonCaracter({required this.simbolo});

  Color get textColor => Colors.white;

  Color get botonColor => Colors.white10;
}

enum BotonConstante {
  pi(simbolo: 'π'),
  e(simbolo: 'e'),
  sqrt2(simbolo: '√2');

  final String simbolo;

  const BotonConstante({required this.simbolo});

  Color get textColor => Colors.blueAccent;

  Color get botonColor => Colors.white24;
}
