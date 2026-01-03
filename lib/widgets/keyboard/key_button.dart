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

  const KeyButton.number({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo = KeyTipo.number,
  });

  const KeyButton.operator({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo = KeyTipo.operator,
  });

  const KeyButton.funcion({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo = KeyTipo.funcion,
  });

  const KeyButton.caracter({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo = KeyTipo.caracter,
  });

  const KeyButton.constante({
    super.key,
    required this.onPressed,
    required this.label,
    this.tipo = KeyTipo.constante,
  });

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    if (label == 'copiar') {
      icon = Icons.content_copy;
    }
    if (label == 'pegar') {
      icon = Icons.content_paste;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.black),
            ),
            backgroundColor: tipo?.backgroundColor,
          ),
          onPressed: onPressed,
          child: icon != null
              ? Icon(icon, size: 30, color: tipo?.textColor)
              : Text(
                  label,
                  style: TextStyle(fontSize: 24, color: tipo?.textColor),
                ),
        ),
      ),
    );
  }
}
