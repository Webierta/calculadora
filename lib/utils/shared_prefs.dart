import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/ecuacion.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  List<String> get memory => _sharedPrefs?.getStringList('memory') ?? [];

  set memory(List<String> lista) {
    _sharedPrefs?.setStringList('memory', lista);
  }

  List<Ecuacion> memoryRecall() {
    List<Ecuacion> lista = [];
    for (var item in memory) {
      final json = jsonDecode(item);
      lista.add(Ecuacion.fromJson(json));
    }
    return lista;
  }

  void memoryStore(Ecuacion value) async {
    List<String> lista = memory;
    String jsonString = jsonEncode(value);
    lista.add(jsonString);
    memory = lista;
  }

  void memoryClear(int index) {
    List<String> lista = memory;
    lista.removeAt(index);
    memory = lista;
  }

  void memoryAllClear() {
    memory = [];
  }
}
