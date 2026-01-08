import 'package:flutter/material.dart';

import 'key_tipo.dart';

class KeyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final KeyTipo? tipo;

  const KeyButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.black),
            ),
            backgroundColor: label == '='
                ? Color(0xffE78388)
                : tipo?.backgroundColor,
          ),
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontSize: label == '=' ? 42 : 24,
                color: label == '=' ? Colors.white : tipo?.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyButtonNumber extends KeyButton {
  const KeyButtonNumber({
    super.key,
    required super.onPressed,
    required super.label,
    super.tipo = KeyTipo.number,
  });
}

class KeyButtonOperator extends KeyButton {
  const KeyButtonOperator({
    super.key,
    required super.onPressed,
    required super.label,
    super.tipo = KeyTipo.operator,
  });
}

class KeyButtonFuncion extends KeyButton {
  const KeyButtonFuncion({
    super.key,
    required super.onPressed,
    required super.label,
    super.tipo = KeyTipo.funcion,
  });
}

class KeyButtonCaracter extends KeyButton {
  const KeyButtonCaracter({
    super.key,
    required super.onPressed,
    required super.label,
    super.tipo = KeyTipo.caracter,
  });
}

class KeyButtonConstante extends KeyButton {
  const KeyButtonConstante({
    super.key,
    required super.onPressed,
    required super.label,
    super.tipo = KeyTipo.constante,
  });
}
