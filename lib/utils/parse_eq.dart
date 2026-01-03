import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class ParseEq {
  const ParseEq();

  static String _replaceSymbols(String input) {
    return input
        .replaceAll('x', '*')
        .replaceAll('÷', '/')
        .replaceAll('％', '/ 100 *')
        .replaceAll('mod', '%')
        .replaceAll('√', 'sqrt');
  }

  static String evaluar(String ecuacion) {
    String output = _replaceSymbols(ecuacion);
    try {
      ShuntingYardParser p = ShuntingYardParser();
      //ExpressionParser p = GrammarParser();
      Expression exp = p.parse(output);
      ContextModel cm = ContextModel();
      var eval = RealEvaluator(cm).evaluate(exp);

      //state = eval.toString();
      //String resultado = eval.toStringAsPrecision(16);
      //resultado = Decimal.parse(resultado).toString();

      final NumberFormat pattern = NumberFormat.decimalPattern();
      pattern.maximumFractionDigits = 10; // 10 decimales
      String resultado = pattern.format(eval);

      /*String resultRounded = eval.toStringAsFixed(5);
      resultRounded = Decimal.parse(resultRounded).toString();
      double resultRoundedAsDouble = double.parse(resultRounded);
      String resultado = resultRoundedAsDouble.toString();
      resultado = Decimal.parse(resultado).toString();*/
      /*if (state.endsWith('.0')) {
        state = state.substring(0, state.length - 2);
      }*/
      if (resultado == 'NaN') {
        throw Error();
      }
      return resultado;
    } catch (e) {
      return 'Error';
    }
  }

  static bool isEcuacion(String input) {
    String output = _replaceSymbols(input);
    if (evaluar(output) == 'Error') {
      return false;
    }
    return true;
  }
}
