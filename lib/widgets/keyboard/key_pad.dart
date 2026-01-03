import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/ecuacion_notifier.dart';
import '../../providers/historial_notifier.dart';
import '../../providers/resultado_notifier.dart';
import '../../utils/parse_eq.dart';
import '../../utils/portapapeles.dart';
import '../display/historial.dart';
import 'key_button.dart';

class KeyPad extends ConsumerWidget {
  const KeyPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantallaEcuacion = ref.watch(ecuacionProvider);
    final pantallaResultado = ref.watch(resultadoProvider);

    void insertText(String text) {
      ref.read(ecuacionProvider.notifier).add(text);
    }

    KeyButton keyButtonNumber(String label) =>
        KeyButton.number(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonOperator(String label) =>
        KeyButton.operator(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonCaracter(String label) =>
        KeyButton.caracter(onPressed: () => insertText(label), label: label);

    KeyButton keyButtonConstante(String label) {
      String constante = '';
      if (label == 'π') {
        constante = math.pi.toString();
      } else if (label == 'e') {
        constante = math.e.toString();
      } else if (label == '√2') {
        constante = math.sqrt2.toString();
      }
      return KeyButton.constante(
        onPressed: () => insertText(constante),
        label: label,
      );
    }

    void funcionCopiar() async {
      try {
        if (pantallaResultado.isEmpty ||
            pantallaResultado == 'Error' ||
            pantallaEcuacion.isEmpty) {
          throw Error();
        }

        Historial hist = Historial(
          input: pantallaEcuacion,
          result: pantallaResultado,
        );
        //await Clipboard.setData(ClipboardData(text: jsonEncode(hist)));
        await Clipboard.setData(ClipboardData(text: pantallaEcuacion));
        final SharedPrefs sharedPrefs = SharedPrefs();
        await sharedPrefs.init();
        sharedPrefs.saveHistory(hist);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ecuacion y resultado copiados al portapapeles'),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al copiar al portapapeles')),
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
        //var json = jsonDecode(item);
        //var hist = Historial.fromJson(json);
        //String ecuacion = hist.input;
        if (ParseEq.isEcuacion(item)) {
          ref.read(ecuacionProvider.notifier).add(item);
        } else {
          throw Error();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: El contenido del portapapeles no se reconoce como una ecuación',
              ),
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
                        KeyButton.funcion(
                          onPressed: () {
                            ref.read(ecuacionProvider.notifier).clear();
                            ref.read(resultadoProvider.notifier).clear();
                            ref.read(historialProvider.notifier).clear();
                          },
                          label: 'AC',
                        ),
                        KeyButton.funcion(
                          onPressed: () {
                            ref.read(ecuacionProvider.notifier).clear();
                            ref.read(resultadoProvider.notifier).clear();
                          },

                          label: 'C',
                        ),
                        KeyButton.funcion(
                          onPressed: () =>
                              ref.read(ecuacionProvider.notifier).remove(),
                          label: '⌫',
                        ),
                        KeyButton.funcion(
                          onPressed: funcionCopiar,
                          label: 'copiar',
                        ),
                        KeyButton.funcion(
                          onPressed: funcionPegar,
                          label: 'pegar',
                        ),
                        /*KeyButton.funcion(
                          onPressed: () =>
                              ref.read(resultadoProvider.notifier).redondeo(),
                          label: '.00',
                        ),*/
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
                        keyButtonOperator('mod'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final number in ['4', '5', '6'])
                          keyButtonNumber(number),
                        keyButtonOperator('^2'),
                        keyButtonOperator('^'),
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
                        keyButtonOperator('x'),
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
                              keyButtonConstante('√2'),
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
                                      .read(resultadoProvider.notifier)
                                      .calcular(pantallaEcuacion);
                                  var resultado = ref.watch(resultadoProvider);
                                  ref
                                      .read(historialProvider.notifier)
                                      .add(
                                        Historial(
                                          input: pantallaEcuacion,
                                          result: resultado,
                                        ),
                                      );
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
