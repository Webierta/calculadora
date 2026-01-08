import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../models/calculator.dart';
import '../models/ecuacion.dart';
import '../utils/string_number.dart';
import 'ecuaciones_notifier.dart';

final calculatorProvider = NotifierProvider<CalculatorNotifier, Calculator>(
  CalculatorNotifier.new,
);

class CalculatorNotifier extends Notifier<Calculator> {
  final Calculator defaultCalculator = Calculator(
    expression: '',
    preview: '',
    result: '',
    hasError: false,
    cursorPosition: 0,
  );

  @override
  Calculator build() {
    return defaultCalculator;
  }

  void copyWith({
    String? newExpression,
    String? newPreview,
    String? newResult,
    bool? newHasError,
    int? newCursorPosition,
  }) => state = Calculator(
    expression: newExpression ?? state.expression,
    preview: newPreview ?? state.preview,
    result: newResult ?? state.result,
    hasError: newHasError ?? state.hasError,
    cursorPosition: newCursorPosition ?? state.cursorPosition,
  );

  void copyAll(Calculator calculator) {
    copyWith(
      newExpression: calculator.expression,
      newPreview: calculator.preview,
      newResult: calculator.result,
      newHasError: calculator.hasError,
      newCursorPosition: calculator.cursorPosition,
    );
  }

  void updateExpresion(String expression) => state = Calculator(
    expression: expression,
    preview: state.preview,
    result: state.result,
    hasError: state.hasError,
    cursorPosition: state.cursorPosition,
  );

  void updatePreview(String preview) => state = Calculator(
    expression: state.expression,
    preview: preview,
    result: state.result,
    hasError: state.hasError,
    cursorPosition: state.cursorPosition,
  );

  void updateResult(String result) => state = Calculator(
    expression: state.expression,
    preview: state.preview,
    result: result,
    hasError: state.hasError,
    cursorPosition: state.cursorPosition,
  );

  void updateError(bool hasError) => state = Calculator(
    expression: state.expression,
    preview: state.preview,
    result: state.result,
    hasError: hasError,
    cursorPosition: state.cursorPosition,
  );

  void updateCursor(int cursorPosition) => state = Calculator(
    expression: state.expression,
    preview: state.preview,
    result: state.result,
    hasError: state.hasError,
    cursorPosition: cursorPosition,
  );

  void addInput(String input) {
    state.hasError = false;
    copyWith(newHasError: false);
    if (input == 'AC') {
      ref.read(ecuacionesProvider.notifier).clear();
      clear();
      return;
    }
    if (input == 'C') {
      clear();
      return;
    }
    if (input == '⌫') {
      backspace();
      return;
    }

    /*if (input == '=') {
      calculate();
      return;
    }*/

    updateResult('');
    _updatePreview();

    // Handle scientific functions - add proper format
    String processedInput = input;
    if (input == '√') {
      processedInput = '$input(';
    }
    if (input == 'x²') {
      processedInput = '^2';
      //processedInput = '²';
    }
    if (input == 'xⁿ') {
      processedInput = '^';
    }
    if (input == 'mod') {
      processedInput = '%';
    }
    if (input == '％') {
      processedInput = '/100*';
    }

    // Insert the input at cursor position
    state.expression =
        state.expression.substring(0, state.cursorPosition) +
        processedInput +
        state.expression.substring(state.cursorPosition);
    state.cursorPosition += processedInput.length;

    copyWith(
      newExpression: state.expression,
      newCursorPosition: state.cursorPosition,
    );
    _updatePreview();
  }

  /*void setCursorPosition(int position) {
    state.cursorPosition = position.clamp(0, state.expression.length);
    copyWith(newCursorPosition: state.cursorPosition);
  }

  void moveCursorLeft() {
    if (state.cursorPosition > 0) {
      state.cursorPosition--;
      copyWith(newCursorPosition: state.cursorPosition);
    }
  }

  void moveCursorRight() {
    if (state.cursorPosition < state.expression.length) {
      state.cursorPosition++;
      copyWith(newCursorPosition: state.cursorPosition);
    }
  }*/

  void _updatePreview() {
    if (state.expression.isEmpty) {
      state.preview = '';
      copyWith(newPreview: state.preview);
      return;
    }

    try {
      String processedExpression = _preprocessExpression(state.expression);
      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(processedExpression);
      ContextModel cm = ContextModel();

      // Add mathematical constants
      cm.bindVariable(Variable('π'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));
      cm.bindVariable(Variable('√²'), Number(math.sqrt2));

      double evalResult = RealEvaluator(cm).evaluate(exp).toDouble();

      if (evalResult.isNaN) {
        state.preview = 'isNaN';
        copyWith(newPreview: state.preview);
      } else if (evalResult.isInfinite) {
        state.preview = 'isInfinite';
        copyWith(newPreview: state.preview);
      } else {
        bool isLong =
            (evalResult.abs() < math.pow(10, -6) ||
            evalResult.abs() >= math.pow(10, 21));
        String formattedResult = _formatNumber(evalResult);
        if (isLong && evalResult != 0) {
          formattedResult = evalResult.toStringAsExponential();
        }
        state.preview = formattedResult;
        copyWith(newPreview: state.preview);
      }
    } catch (e) {
      // Instead of showing blank, show a helpful preview
      String expr = state.expression.toLowerCase();

      // Check for common incomplete expressions
      if (expr.startsWith('^')) {
        state.preview = 'Error expression';
        copyWith(newPreview: state.preview);
      } else if (expr.endsWith('√(')) {
        state.preview = 'Enter non-negative number';
        copyWith(newPreview: state.preview);
      } else if (expr.contains('(') && !expr.contains(')') ||
          expr.endsWith('^')) {
        state.preview = 'Incomplete expression';
        copyWith(newPreview: state.preview);
      } else if (expr.endsWith('+') ||
          expr.endsWith('-') ||
          expr.endsWith('×') ||
          expr.endsWith('÷') ||
          expr.endsWith('*') ||
          expr.endsWith('/') ||
          expr.endsWith('%')) {
        state.preview = 'Enter next number';
        copyWith(newPreview: state.preview);
      } else {
        // For other syntax errors, try to show partial evaluation if possible
        state.preview = _tryPartialEvaluation(state.expression);
        copyWith(newPreview: state.preview);
      }
    }
  }

  /// Try to evaluate parts of the expression that are valid
  String _tryPartialEvaluation(String expr) {
    // Try to evaluate sub-expressions that might be complete
    try {
      // Look for complete numbers or simple operations
      String simplified = expr.replaceAll(RegExp(r'[+\-*/÷×()^]'), ' ');
      List<String> parts = simplified
          .split(' ')
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        String lastPart = parts.last;
        if (double.tryParse(lastPart) != null) {
          return lastPart; // Show the last valid number
        }
      }
      return '?'; //'Check syntax';
    } catch (e) {
      return '?'; //'Check syntax';
    }
  }

  void calculate() {
    if (state.expression.isEmpty) return;

    try {
      // Store original for history
      String originalExpression = state.expression;
      String processedExpression = _preprocessExpression(state.expression);

      // Validate expression before parsing
      if (processedExpression.isEmpty) {
        state.result = 'Error';
        state.hasError = true;
        state.preview = '';
        copyWith(
          newResult: state.result,
          newHasError: state.hasError,
          newPreview: state.preview,
        );
        return;
      }

      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(processedExpression);
      ContextModel cm = ContextModel();

      // Add mathematical constants
      cm.bindVariable(Variable('π'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));
      cm.bindVariable(Variable('√²'), Number(math.sqrt2));

      //double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      double evalResult = RealEvaluator(cm).evaluate(exp).toDouble();

      // Check for invalid results
      if (evalResult.isInfinite) {
        state.result = 'Error';
        state.hasError = true;
        state.preview = '';
        copyWith(
          newResult: state.result,
          newHasError: state.hasError,
          newPreview: state.preview,
        );
      } else if (evalResult.isNaN) {
        state.result = 'Invalid';
        state.hasError = true;
        state.preview = '';
        copyWith(
          newResult: state.result,
          newHasError: state.hasError,
          newPreview: state.preview,
        );
      } else {
        bool isLong =
            (evalResult.abs() < math.pow(10, -6) ||
            evalResult.abs() >= math.pow(10, 21));
        String formattedResult = _formatNumber(evalResult);
        if (isLong && evalResult != 0) {
          formattedResult = evalResult.toStringAsExponential();
        }
        state.result = formattedResult;
        state.preview = ''; // Clear preview after calculation
        state.hasError = false;
        copyWith(
          newResult: state.result,
          newPreview: state.preview,
          newHasError: false,
        );

        // Store in history with format: expression = result
        _addToHistory(originalExpression, formattedResult);

        // Keep the original expression visible - don't replace with result
        // The user can see both the expression and result
        // If user wants to continue with result, they can manually clear and use result
      }
    } on FormatException catch (e) {
      state.result = 'Format Error';
      state.hasError = true;
      state.preview = '';
      copyWith(
        newResult: state.result,
        newHasError: state.hasError,
        newPreview: state.preview,
      );
      if (kDebugMode) {
        print('Format error in calculation: $e');
      }
    } on ArgumentError catch (e) {
      state.result = 'Invalid Input';
      state.hasError = true;
      state.preview = '';
      copyWith(
        newResult: state.result,
        newHasError: state.hasError,
        newPreview: state.preview,
      );
      if (kDebugMode) {
        print('Argument error in calculation: $e');
      }
    } on Exception catch (e) {
      String errorMessage = 'Syntax Error';
      String errorString = e.toString().toLowerCase();
      if (errorString.contains('division by zero') ||
          errorString.contains('divide by zero')) {
        errorMessage = 'Cannot divide by zero';
      } else if (errorString.contains('overflow')) {
        errorMessage = 'Number too large';
      } else if (errorString.contains('underflow')) {
        errorMessage = 'Number too small';
      } else if (errorString.contains('invalid') ||
          errorString.contains('illegal')) {
        errorMessage = 'Invalid expression';
      }
      state.result = errorMessage;
      state.hasError = true;
      state.preview = '';
      copyWith(
        newResult: state.result,
        newHasError: state.hasError,
        newPreview: state.preview,
      );
      if (kDebugMode) {
        print('Exception in calculation: $e');
      }
    } catch (e) {
      state.result = 'Error';
      state.hasError = true;
      state.preview = '';
      copyWith(
        newResult: state.result,
        newHasError: state.hasError,
        newPreview: state.preview,
      );
      if (kDebugMode) {
        print('Unexpected error in calculation: $e');
      }
    }
  }

  void _addToHistory(String expresion, String resultado) {
    ref
        .read(ecuacionesProvider.notifier)
        .add(Ecuacion(input: expresion, result: resultado));
    // This will be called by the UI to add to history provider
    // The UI will handle the actual history storage
  }

  String _preprocessExpression(String expression) {
    if (expression.isEmpty) return '';
    String processed = expression;
    // Replace display symbols with math expression symbols
    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');
    //processed = processed.replaceAll('²', '^2');
    processed = processed.replaceAll('ⁿ', '^');

    // Handle scientific functions with proper parsing and error checking
    // Match function names followed by parentheses and content

    // Handle square root
    processed = processed.replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) {
      try {
        String content = match.group(1)!;
        if (content.isEmpty) throw Exception('Empty sqrt parameter');
        double value = _evaluateSimpleExpression(content);
        if (value < 0) throw Exception('sqrt requires non-negative number');
        if (value.isInfinite || value.isNaN) {
          throw Exception('Invalid sqrt input');
        }
        return math.sqrt(value).toString();
      } catch (e) {
        return 'sqrt(${match.group(1)!})';
      }
    });

    // Now replace constants after function processing
    processed = processed.replaceAll('π', math.pi.toString());
    processed = processed.replaceAll('e', math.e.toString());
    processed = processed.replaceAll('√²', math.sqrt2.toString());

    // Validate parentheses balance
    int openCount = processed.split('(').length - 1;
    int closeCount = processed.split(')').length - 1;
    if (openCount != closeCount) {
      throw Exception('Unbalanced parentheses');
    }

    // Check for invalid patterns like double operators
    if (RegExp(r'[+\-*/]{2,}').hasMatch(processed)) {
      throw Exception('Invalid operator sequence');
    }

    // Check for division by zero patterns
    /*if (RegExp(r'/\s*0(?!\d)').hasMatch(processed)) {
      throw Exception('Division by zero');
    }*/ // .*\/0([^.]|$|\.(0{4,}.*|0{1,4}([^0-9]|$))).*

    if (RegExp(
      r'.*/0([^.]|$|\.(0{4,}.*|0{1,4}([^0-9]|$))).*',
    ).hasMatch(processed)) {
      throw Exception('Division by zero');
    }

    return processed;
  }

  // Helper method to evaluate simple expressions within function parameters
  double _evaluateSimpleExpression(String expr) {
    String processed = expr.trim();

    // Replace constants first
    processed = processed.replaceAll('π', math.pi.toString());
    processed = processed.replaceAll('e', math.e.toString());
    processed = processed.replaceAll('√²', math.sqrt2.toString());

    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');
    processed = processed.replaceAll('ⁿ', '^');

    // Try to parse as a simple number first
    try {
      return double.parse(processed);
    } catch (e) {
      // If not a simple number, try to evaluate as expression
      try {
        GrammarParser parser = GrammarParser();
        Expression exp = parser.parse(processed);
        //return exp.evaluate(EvaluationType.REAL, ContextModel());
        ContextModel cm = ContextModel();
        var eval = RealEvaluator(cm).evaluate(exp);
        return eval as double; //.toDouble();
      } catch (e) {
        throw Exception('Cannot evaluate expression: $expr');
      }
    }
  }

  String _formatNumber(double number) {
    try {
      final NumberFormat pattern = NumberFormat.decimalPattern();
      pattern.maximumFractionDigits = 8;
      var resultado = pattern
          .format(number)
          .spaceSeparateDecimals()
          .replaceAll(',', '\u{202F}');
      if (resultado == 'NaN' || resultado == '∞') {
        throw Error();
      }
      return resultado;
    } catch (e) {
      return 'Error';
    }
  }

  void clear() => copyAll(defaultCalculator);

  void backspace() {
    if (state.expression.isNotEmpty && state.cursorPosition > 0) {
      state.expression =
          state.expression.substring(0, state.cursorPosition - 1) +
          state.expression.substring(state.cursorPosition);
      state.cursorPosition--;
      copyWith(
        newExpression: state.expression,
        newCursorPosition: state.cursorPosition,
      );
      _updatePreview();
    }
  }

  void pasteFromClipboard(String ecuacion) {
    try {
      copyWith(
        newResult: '',
        newExpression: ecuacion,
        newCursorPosition: ecuacion.length,
      );
      calculate();
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting from history: $e');
      }
      clear();
    }
  }

  bool _isNumeric(String? s) {
    if (s == null) return false;
    return double.tryParse(s) != null;
  }

  bool isEq(String item) {
    try {
      ExpressionParser p = GrammarParser();
      Expression exp = p.parse(item);
      ContextModel cm = ContextModel();
      var eval = RealEvaluator(cm).evaluate(exp);
      if (_isNumeric(eval.toString()) && eval.isFinite && !eval.isNaN) {
        return true;
      } else {
        throw Error();
      }
    } catch (e) {
      return false;
    }
  }
}
