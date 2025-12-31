import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  List<String> get items => _sharedPrefs?.getStringList('items') ?? [];

  set items(List<String> lista) => _sharedPrefs?.setStringList('items', lista);

  void addItem(String value) {
    List<String> lista = items;
    lista.add(value);
    items = lista;
    //_sharedPrefs?.setStringList('items', lista);
  }

  void removeItem(int index) {
    List<String> lista = items;
    lista.removeAt(index);
    items = lista;
    //_sharedPrefs?.setStringList('items', lista);
  }

  void clearAll() {
    items = [];
    //_sharedPrefs?.setStringList('items', []);
  }
}
