import 'package:flutter_riverpod/flutter_riverpod.dart';

final ecuacionProvider = NotifierProvider<EcuacionNotifier, String>(
  EcuacionNotifier.new,
);

class EcuacionNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void add(String op) {
    state += op;
  }

  void clear() {
    state = '';
  }

  void remove() {
    if (state.isNotEmpty) {
      state = state.substring(0, state.length - 1);
    }
  }
}
