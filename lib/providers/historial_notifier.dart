import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/historial.dart';

final historialProvider = NotifierProvider<HistorialNotifier, List<Historial>>(
  HistorialNotifier.new,
);

class HistorialNotifier extends Notifier<List<Historial>> {
  @override
  List<Historial> build() {
    return [];
  }

  void add(Historial historial) {
    state.add(historial);
  }

  void clear() {
    state = [];
  }
}
