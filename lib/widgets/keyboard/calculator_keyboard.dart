import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/historial.dart';
import '../../providers/calculator_notifier.dart';
import '../../utils/portapapeles.dart';
import '../../utils/snack_bar_helper.dart';
import 'key_button.dart';

class CalculatorKeyboard extends ConsumerWidget {
  const CalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.watch(calculatorProvider);

    void insertText(String text) =>
        ref.read(calculatorProvider.notifier).addInput(text);

    KeyButton keyButtonFuncion(String label) =>
        KeyButton.funcion(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonNumber(String label) =>
        KeyButton.number(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonOperator(String label) =>
        KeyButton.operator(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonCaracter(String label) =>
        KeyButton.caracter(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonConstante(String label) =>
        KeyButton.constante(onPressed: () => insertText(label), label: label);

    void funcionCopiar() async {
      try {
        if (calculator.result.isEmpty ||
            calculator.hasError == true ||
            calculator.expression.isEmpty) {
          throw Error();
        }

        Historial hist = Historial(
          input: calculator.expression,
          result: calculator.result,
        );
        //await Clipboard.setData(ClipboardData(text: jsonEncode(hist)));
        await Clipboard.setData(ClipboardData(text: calculator.expression));
        final SharedPrefs sharedPrefs = SharedPrefs();
        await sharedPrefs.init();
        sharedPrefs.saveHistory(hist);
        if (context.mounted) {
          SnackBarHelper.show(
            context: context,
            msg: 'Ecuacion copiada y guardada en Clipboard',
          );
        }
      } catch (e) {
        if (context.mounted) {
          SnackBarHelper.show(
            context: context,
            msg: 'Error al copiar al portapapeles',
            error: true,
          );
        }
      }
    }

    void funcionPegar() async {
      try {
        ClipboardData? data = await Clipboard.getData('text/plain');
        if (data == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Nada en el portapapeles')));
          }
          return;
        }
        String item = '${data.text}';
        item = item.replaceAll('×', '*'); // 2 × 2
        item = item.replaceAll('x', '*'); // 2 x 6
        item = item.replaceAll('÷', '/');
        item = item.replaceAll('√', 'sqrt'); // √(49) + 2
        item = item.replaceAll('π', math.pi.toString());
        item = item.replaceAll('e', math.e.toString());

        if (ref.read(calculatorProvider.notifier).isEq(item) == false) {
          throw Error();
        }
        ref.read(calculatorProvider.notifier).updateExpresion(item);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No se reconoce como una ecuación')),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: TextFieldTapRegion(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        keyButtonFuncion('AC'),
                        keyButtonFuncion('C'),
                        keyButtonFuncion('⌫'),
                        KeyButton.funcion(
                          onPressed: funcionCopiar,
                          label: 'copiar',
                        ),
                        KeyButton.funcion(
                          onPressed: funcionPegar,
                          label: 'pegar',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['7', '8', '9'])
                          keyButtonNumber(number),
                        keyButtonOperator('％'),
                        keyButtonOperator('mod'), //mod
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['4', '5', '6'])
                          keyButtonNumber(number),
                        keyButtonOperator('x²'),
                        keyButtonOperator('xⁿ'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['1', '2', '3'])
                          keyButtonNumber(number),
                        keyButtonOperator('√'),
                        keyButtonOperator('!'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        keyButtonCaracter('('),
                        keyButtonNumber('0'),
                        keyButtonCaracter(')'),
                        keyButtonOperator('÷'),
                        keyButtonOperator('×'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        keyButtonCaracter('{'),
                        keyButtonCaracter('.'),
                        keyButtonCaracter('}'),
                        keyButtonOperator('-'),
                        keyButtonOperator('+'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              keyButtonConstante('π'),
                              keyButtonConstante('e'),
                              keyButtonConstante('√²'),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              KeyButton.operator(
                                onPressed: () {
                                  ref
                                      .read(calculatorProvider.notifier)
                                      .calculate();
                                },
                                label: '=',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
