import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/display/historial.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  List<String> get clipboard => _sharedPrefs?.getStringList('clipboard') ?? [];

  set clipboard(List<String> lista) {
    _sharedPrefs?.setStringList('clipboard', lista);
  }

  List<Historial> getHistory() {
    List<Historial> lista = [];
    for (var item in clipboard) {
      final json = jsonDecode(item);
      lista.add(Historial.fromJson(json));
    }
    return lista;
  }

  void saveHistory(Historial value) async {
    List<String> lista = clipboard;
    String jsonString = jsonEncode(value);
    lista.add(jsonString);
    clipboard = lista;
  }

  void removeHistory(int index) {
    List<String> lista = clipboard;
    lista.removeAt(index);
    clipboard = lista;
  }

  void clearClipboard() {
    clipboard = [];
  }
}
