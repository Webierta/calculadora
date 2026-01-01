import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/portapapeles.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final SharedPrefs sharedPrefs = SharedPrefs();
  List<String> items = [];

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Future<void> _loadItems() async {
    await sharedPrefs.init();
    setState(() => items = sharedPrefs.items);
  }

  @override
  Widget build(BuildContext context) {
    void copyItem(String item) async {
      await Clipboard.setData(ClipboardData(text: item));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            onPressed: () {
              sharedPrefs.clearAll();
              _loadItems();
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff292D36),
          child: items.isEmpty
              ? Text(
                  'Portapapeles vacío',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    String item = items[index];
                    String resultado = item.substring(item.indexOf('=') + 1);
                    String ecuacion = item.substring(0, item.indexOf('='));
                    return ListTile(
                      contentPadding: .all(14),
                      titleAlignment: ListTileTitleAlignment.top,
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          resultado,
                          style: TextStyle(fontFamily: 'ShareTechMono'),
                        ),
                      ),
                      subtitle: Text(ecuacion),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              copyItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ecuacion y resultado copiados al portapapeles',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.copy),
                          ),
                          IconButton(
                            onPressed: () {
                              sharedPrefs.removeItem(index);
                              _loadItems();
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
