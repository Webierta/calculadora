import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

extension StringNumber on String {
  String spaceSeparateDecimals() {
    if (!contains('.')) {
      return this;
    }
    try {
      int indexDecimal = indexOf('.');
      String decimales = substring(indexDecimal + 1);
      List<String> decimalesSeparados = [];
      for (var i = 0; i < decimales.length; i++) {
        if (i % 3 == 0 && i != 0) {
          decimalesSeparados.add('\u{202F}');
        }
        decimalesSeparados.add(decimales[i]);
      }
      var enteros = substring(0, indexDecimal + 1);
      return (enteros + decimalesSeparados.join());
    } catch (e) {
      return this;
    }
  }

  /*String spaceSeparateInt() {
    int indexDecimal = length;
    if (contains('.')) {
      indexDecimal = indexOf('.');
    }
    String enteros = substring(0, indexDecimal);
    List<String> enterosSeparados = [];
    for (var i = 0; i < enteros.length; i++) {
      if (i % 3 == 0 && i != 0) {
        enterosSeparados.add('\u{202F}');
      }
      enterosSeparados.add(enteros[i]);
    }
    var decimales = substring(indexDecimal);
    print(decimales);
    return (enterosSeparados.join() + decimales);
  }*/
}

/*extension StringNumberExtension on String {
  String spaceSeparateNumbers() {
    final result = replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}\u{202F}',
    );
    return result;
  }
}*/

class ParseEq {
  const ParseEq();

  static String _replaceSymbols(String input) => input
      .replaceAll('x', '*')
      .replaceAll('÷', '/')
      .replaceAll('％', '/ 100 *')
      .replaceAll('mod', '%')
      .replaceAll('√', 'sqrt');

  /*static String parseDecimal(String input) {
    var doubleRE = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");
    try {
      var numbers = doubleRE
          .allMatches(input)
          .map((m) => double.parse(m[0]!))
          .toList();
      */ /*print(
        Decimal.parse(numbers[0].toString()) +
            Decimal.parse(numbers[1].toString()),
       );*/ /*
      for (var i = 0; i < numbers.length; i++) {
        input.replaceAll(
          numbers[i].toString(),
          '${Decimal.parse(numbers[i].toString())}',
        );
      }
      return (input);
    } catch (e) {
      print(e);
      return input;
    }
  }*/

  static String evaluar(String ecuacion) {
    String output = _replaceSymbols(ecuacion);

    try {
      ShuntingYardParser p = ShuntingYardParser();
      //ExpressionParser p = GrammarParser();
      Expression exp = p.parse(output);
      ContextModel cm = ContextModel();
      var eval = RealEvaluator(cm).evaluate(exp);

      final NumberFormat pattern = NumberFormat.decimalPattern();
      pattern.maximumFractionDigits = 8; // decimales
      String resultado = pattern
          .format(eval)
          .spaceSeparateDecimals()
          .replaceAll(',', '\u{202F}');

      /*String resultRounded = eval.toStringAsFixed(5);
      resultRounded = Decimal.parse(resultRounded).toString();
      double resultRoundedAsDouble = double.parse(resultRounded);
      String resultado = resultRoundedAsDouble.toString();
      resultado = Decimal.parse(resultado).toString();*/

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
