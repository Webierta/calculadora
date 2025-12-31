import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';

import '../models/botones.dart';
import '../providers/ecuacion_notifier.dart';
import '../providers/resultado_notifier.dart';
import '../utils/portapapeles.dart';
import 'boton.dart';

class Teclado extends ConsumerWidget {
  const Teclado({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantallaEcuacion = ref.watch(ecuacionProvider);
    final pantallaResultado = ref.watch(resultadoProvider);

    bool isEcuacion(String eq) {
      try {
        String input = eq
            .replaceAll('x', '*')
            .replaceAll('÷', '/')
            .replaceAll('%', '/ 100 *')
            .replaceAll('√', 'sqrt');
        ShuntingYardParser p = ShuntingYardParser();
        //ExpressionParser p = GrammarParser();
        Expression exp = p.parse(input);
        ContextModel cm = ContextModel();
        var eval = RealEvaluator(cm).evaluate(exp);
        var resultado = eval.toStringAsPrecision(15);
        resultado = Decimal.parse(resultado).toString();
        if (resultado == 'NaN') {
          throw Error();
        }
        return true;
      } catch (e) {
        return false;
      }
    }

    Boton buildBotonOperacion(BotonOperacion bOp) {
      return Boton(
        botonText: bOp.simbolo,
        textColor: bOp.textColor,
        botonColor: bOp.botonColor,
        botonTap: () {
          ref.read(ecuacionProvider.notifier).add(bOp.simbolo);
        },
      );
    }

    Boton buildBotonFuncion(BotonFuncion bF) {
      var funcion = switch (bF) {
        BotonFuncion.limpiar => () {
          ref.read(ecuacionProvider.notifier).clear();
          ref.read(resultadoProvider.notifier).clear();
        },
        BotonFuncion.deshacer => () {
          ref.read(ecuacionProvider.notifier).remove();
        },
        BotonFuncion.copiar => () async {
          try {
            if (pantallaResultado.isEmpty ||
                pantallaResultado == 'Error' ||
                pantallaEcuacion.isEmpty) {
              throw Error();
            }
            String item = '$pantallaEcuacion=$pantallaResultado';
            await Clipboard.setData(ClipboardData(text: item));
            final SharedPrefs sharedPrefs = SharedPrefs();
            await sharedPrefs.init();
            sharedPrefs.addItem(item);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ecuacion y resultado copiados al portapapeles',
                  ),
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
        },
        BotonFuncion.pegar => () async {
          try {
            ClipboardData? data = await Clipboard.getData('text/plain');
            if (data != null) {
              var item = '${data.text}';
              if (!item.contains('=')) {
                throw Error();
              }
              //String resultado = item.substring(item.indexOf('=') + 1);
              String ecuacion = item.substring(0, item.indexOf('='));
              if (isEcuacion(ecuacion)) {
                ref.read(ecuacionProvider.notifier).add(ecuacion);
              } else {
                throw Error();
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nada en el portapapeles')),
                );
              }
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
        },
        BotonFuncion.redondeo => () {
          //var resultado = ref.read(resultadoProvider.notifier);
          //resultado = resultado.redondeo();
          ref.read(resultadoProvider.notifier).redondeo();
          //state = Decimal.parse(state).toString();
        },
      };
      return Boton(
        botonText: bF.simbolo,
        textColor: bF.textColor,
        botonColor: bF.botonColor,
        botonTap: () => funcion(),
      );
    }

    Boton buildBotonCaracter(BotonCaracter bCa) {
      return Boton(
        botonText: bCa.simbolo,
        textColor: bCa.textColor,
        botonColor: bCa.botonColor,
        botonTap: () => ref.read(ecuacionProvider.notifier).add(bCa.simbolo),
      );
    }

    List<Widget> buildBotonesNumber(int n, [int length = 3]) {
      List<Widget> listWidgets = List.generate(length, (index) {
        var texto = (index + n).toString();
        return Boton(
          botonText: texto,
          textColor: Colors.white,
          botonColor: Colors.white24,
          botonTap: () => ref.read(ecuacionProvider.notifier).add(texto),
        );
      });
      if (length == 3) {
        listWidgets.insert(1, const SizedBox(width: 10));
        listWidgets.insert(3, const SizedBox(width: 10));
      }
      return listWidgets;
    }

    Boton buildBotonConstante(BotonConstante bCo) {
      var funcion = switch (bCo) {
        BotonConstante.pi => () {
          ref.read(ecuacionProvider.notifier).add(math.pi.toString());
        },
        BotonConstante.e => () {
          ref.read(ecuacionProvider.notifier).add(math.e.toString());
        },
        BotonConstante.sqrt2 => () {
          ref.read(ecuacionProvider.notifier).add(math.sqrt2.toString());
        },
      };
      return Boton(
        botonText: bCo.simbolo,
        textColor: bCo.textColor,
        botonColor: bCo.botonColor,
        botonTap: () => funcion(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildBotonFuncion(BotonFuncion.limpiar),
              const SizedBox(width: 10),
              buildBotonFuncion(BotonFuncion.deshacer),
              const SizedBox(width: 10),
              buildBotonFuncion(BotonFuncion.copiar),
              const SizedBox(width: 10),
              buildBotonFuncion(BotonFuncion.pegar),
              const SizedBox(width: 10),
              buildBotonFuncion(BotonFuncion.redondeo),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...buildBotonesNumber(7),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.porcentaje),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.factorial),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...buildBotonesNumber(4),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.raiz),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.exponente),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...buildBotonesNumber(1),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.dividir),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.multiplicar),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildBotonCaracter(BotonCaracter.parentesisOn),
              const SizedBox(width: 10),
              ...buildBotonesNumber(0, 1),
              const SizedBox(width: 10),
              buildBotonCaracter(BotonCaracter.parentesisOff),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.restar),
              const SizedBox(width: 10),
              buildBotonOperacion(BotonOperacion.sumar),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildBotonCaracter(BotonCaracter.corcheteOn),
                      const SizedBox(width: 10),
                      buildBotonCaracter(BotonCaracter.decimal),
                      const SizedBox(width: 10),
                      buildBotonCaracter(BotonCaracter.corcheteOff),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildBotonConstante(BotonConstante.pi),
                      const SizedBox(width: 10),
                      buildBotonConstante(BotonConstante.e),
                      const SizedBox(width: 10),
                      buildBotonConstante(BotonConstante.sqrt2),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Boton(
                botonText: BotonOperacion.igual.simbolo,
                textColor: Colors.white,
                botonColor: Color(0xffE78388),
                botonTap: () {
                  ref
                      .read(resultadoProvider.notifier)
                      .calcular(pantallaEcuacion);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
