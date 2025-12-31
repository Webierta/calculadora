import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/pantalla.dart';
import '../widgets/teclado.dart';
import 'help.dart';
import 'historial.dart';
import 'info.dart';

class Calculadora extends StatelessWidget {
  const Calculadora({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.calculate, size: 40),
        title: Text('Calculadora'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const Historial(),
                ),
              );
            },
            icon: Icon(Icons.paste),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const HelpScreen(),
                ),
              );
            },
            icon: Icon(Icons.help),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const InfoScreen(),
                ),
              );
            },
            icon: Icon(Icons.info),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xff292D36),
          //padding: .all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: const Pantalla()),
              //const SizedBox(height: 20),
              FittedBox(child: const Teclado()),
            ],
          ),
        ),
      ),
    );
  }
}
