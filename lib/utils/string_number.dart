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
}
