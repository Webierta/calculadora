import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';

final resultadoProvider = NotifierProvider<ResultadoNotifier, String>(
  ResultadoNotifier.new,
);

class ResultadoNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void clear() {
    state = '';
  }

  void redondeo() {
    var resultado = double.tryParse(state);
    String decimals = '';
    if (state.isNotEmpty && state.contains('.')) {
      decimals = state.split('.')[1];
    }

    if (resultado != null && decimals.length > 2) {
      state = resultado.toStringAsFixed(2);
      state = Decimal.parse(state).toString();
    }
  }

  void calcular(String pantallaEcuacion) {
    if (pantallaEcuacion.isEmpty) {
      state = '';
      return;
    }
    try {
      String input = pantallaEcuacion
          .replaceAll('x', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/ 100 *')
          .replaceAll('√', 'sqrt');

      /*String input = pantallaEcuacion
          .replaceAll('x', '*')
          .replaceAll('√', 'Root.sqrt');*/

      //input = input.replaceAll('√', '*sqrt');

      /*if (input.contains('√')) {
        var sub1 = input.substring(1);
        int? end;
        for (MapEntry e in sub1.split('').asMap().entries) {
          if (int.tryParse(e.value) == null) {
            end = e.key;
            break;
          }
        }
        if (end != null) {
          sub1 = sub1.substring(0, end);
        }
        print(sub1);
        var x = Variable(sub1);
        input = Sqrt(x).toString();
      }*/

      ShuntingYardParser p = ShuntingYardParser();
      //ExpressionParser p = GrammarParser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      var eval = RealEvaluator(cm).evaluate(exp);

      //print(eval);

      //state = eval.toString();
      state = eval.toStringAsPrecision(15);
      state = Decimal.parse(state).toString();
      /*if (state.endsWith('.0')) {
        state = state.substring(0, state.length - 2);
      }*/
      //print(state);
      if (state == 'NaN') {
        throw Error();
      }
    } catch (e) {
      state = 'Error';
    }
  }
}
