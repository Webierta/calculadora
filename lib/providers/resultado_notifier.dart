import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/parse_eq.dart';

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
    state = ParseEq.evaluar(pantallaEcuacion);
  }
}
