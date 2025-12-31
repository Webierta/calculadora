import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final String botonText;
  final Color textColor;
  final Color botonColor;
  final Function() botonTap;

  const Boton({
    super.key,
    required this.botonText,
    required this.textColor,
    required this.botonColor,
    required this.botonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: botonText == '=' ? 190 : 90,
      height: botonText == '=' ? 150 : 70,
      //width: botonText == '=' ? 100 : 45,
      //height: botonText == '=' ? 75 : 35,
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: () => botonTap(),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: Colors.black),
          ),
          backgroundColor: botonColor,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            botonText,
            style: TextStyle(
              fontSize: botonText == '=' ? 80 : 24,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
