import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/display/calculator_display.dart';
import '../widgets/keyboard/calculator_keyboard.dart';
import 'help.dart';
import 'info.dart';
import 'memoria_screen.dart';

class Calculadora extends StatelessWidget {
  const Calculadora({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Calculadora'),
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const MemoriaScreen(),
                  ),
                );
              },
              icon: Icon(Icons.assignment),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const HelpScreen(),
                  ),
                );
              },
              icon: Icon(Icons.help_outline),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const InfoScreen(),
                  ),
                );
              },
              icon: Icon(Icons.info_outline),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SafeArea(
          // Container color: Color(0xff292D36),
          child: Container(
            color: Color(0xff292D36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: const CalculatorDisplay()),
                Expanded(flex: 3, child: const CalculatorKeyboard()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
