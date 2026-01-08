import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ecuacion.dart';

final ecuacionesProvider = NotifierProvider<EcuacionesNotifier, List<Ecuacion>>(
  EcuacionesNotifier.new,
);

class EcuacionesNotifier extends Notifier<List<Ecuacion>> {
  @override
  List<Ecuacion> build() {
    return [];
  }

  void add(Ecuacion ecuacion) {
    final newEcuacion = Ecuacion(
      input: ecuacion.input,
      result: ecuacion.result,
    );
    state = [...state, newEcuacion];
  }

  void clear() {
    state = [];
  }
}
