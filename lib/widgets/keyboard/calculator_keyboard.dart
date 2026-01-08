import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ecuacion.dart';
import '../../providers/calculator_notifier.dart';
import '../../utils/shared_prefs.dart';
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
        KeyButtonFuncion(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonNumber(String label) =>
        KeyButtonNumber(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonOperator(String label) =>
        KeyButtonOperator(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonCaracter(String label) =>
        KeyButtonCaracter(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonConstante(String label) =>
        KeyButtonConstante(onPressed: () => insertText(label), label: label);

    void memoryStore() async {
      try {
        if (calculator.result.isEmpty ||
            calculator.hasError == true ||
            calculator.expression.isEmpty) {
          throw Exception();
        }
        Ecuacion hist = Ecuacion(
          input: calculator.expression,
          result: calculator.result,
        );
        await Clipboard.setData(ClipboardData(text: calculator.expression));
        final SharedPrefs sharedPrefs = SharedPrefs();
        await sharedPrefs.init();
        sharedPrefs.memoryStore(hist);
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          SnackBarHelper.show(
            context: context,
            msg: 'Ecuacion copiada y guardada en Memoria',
          );
        }
      } on Exception catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          SnackBarHelper.show(
            context: context,
            msg: 'Requeridos expresion y resultado sin error.',
            error: true,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          SnackBarHelper.show(
            context: context,
            msg: 'Error durante el proceso de copia y almacén en Memoria',
            error: true,
          );
        }
      }
    }

    void clipboardPaste() async {
      try {
        ClipboardData? data = await Clipboard.getData('text/plain');
        if (data == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
        ref.read(calculatorProvider.notifier).updateCursor(item.length);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: No se reconoce como una ecuación válida'),
            ),
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
                        KeyButtonFuncion(onPressed: memoryStore, label: 'MS'),
                        KeyButtonFuncion(
                          onPressed: clipboardPaste,
                          label: 'MR',
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
                              KeyButtonOperator(
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
