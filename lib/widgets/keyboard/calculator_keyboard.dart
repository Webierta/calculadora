import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ecuacion.dart';
import '../../providers/calculator_notifier.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/snack_bar_helper.dart';
import 'key_button.dart';
import 'key_tipo.dart';

class CalculatorKeyboard extends ConsumerWidget {
  const CalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.watch(calculatorProvider);

    KeyButton keyButton(String label, KeyTipo tipo) => KeyButton(
      onPressed: () => ref.read(calculatorProvider.notifier).addInput(label),
      label: label,
      tipo: tipo,
    );

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
        //ref.read(calculatorProvider.notifier).updateExpresion(item);
        ref.read(calculatorProvider.notifier).pasteToExpression(item);
        //ref.read(calculatorProvider.notifier).updateCursor(item.length);
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
                        keyButton('AC', KeyTipo.funcion),
                        keyButton('C', KeyTipo.funcion),
                        keyButton('⌫', KeyTipo.funcion),
                        KeyButton(
                          onPressed: memoryStore,
                          label: 'MS',
                          tipo: KeyTipo.funcion,
                        ),
                        KeyButton(
                          onPressed: clipboardPaste,
                          label: 'MR',
                          tipo: KeyTipo.funcion,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['7', '8', '9'])
                          keyButton(number, KeyTipo.number),
                        keyButton('％', KeyTipo.operator),
                        keyButton('mod', KeyTipo.operator), //mod
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['4', '5', '6'])
                          keyButton(number, KeyTipo.number),
                        keyButton('x²', KeyTipo.operator),
                        keyButton('xⁿ', KeyTipo.operator),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['1', '2', '3'])
                          keyButton(number, KeyTipo.number),
                        keyButton('√', KeyTipo.operator),
                        keyButton('!', KeyTipo.operator),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        keyButton('(', KeyTipo.caracter),
                        keyButton('0', KeyTipo.number),
                        keyButton(')', KeyTipo.caracter),
                        keyButton('÷', KeyTipo.operator),
                        keyButton('×', KeyTipo.operator),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        keyButton('↤', KeyTipo.caracter),
                        keyButton('.', KeyTipo.caracter),
                        keyButton('↦', KeyTipo.caracter),
                        keyButton('-', KeyTipo.operator),
                        keyButton('+', KeyTipo.operator),
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
                              keyButton('π', KeyTipo.constante),
                              keyButton('e', KeyTipo.constante),
                              keyButton('√²', KeyTipo.constante),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [keyButton('=', KeyTipo.operator)],
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
