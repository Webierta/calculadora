class Calculator {
  String expression;
  String preview;
  String result;
  bool hasError;
  int cursorPosition; // Position of cursor in expression

  Calculator({
    required this.expression,
    required this.preview,
    required this.result,
    required this.hasError,
    required this.cursorPosition,
  });
}
