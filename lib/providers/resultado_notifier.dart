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
          .replaceAll('％', '/ 100 *')
          .replaceAll('mod', '%')
          .replaceAll('√', 'sqrt');

      ShuntingYardParser p = ShuntingYardParser();
      //ExpressionParser p = GrammarParser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      var eval = RealEvaluator(cm).evaluate(exp);

      //state = eval.toString();
      state = eval.toStringAsPrecision(16);
      state = Decimal.parse(state).toString();
      /*if (state.endsWith('.0')) {
        state = state.substring(0, state.length - 2);
      }*/
      if (state == 'NaN') {
        throw Error();
      }
    } catch (e) {
      state = 'Error';
    }
  }
}
