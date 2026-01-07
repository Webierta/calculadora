import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/historial.dart';
import '../providers/calculator_notifier.dart';
import '../utils/portapapeles.dart';
import '../utils/snack_bar_helper.dart';

class ClipboardScreen extends ConsumerStatefulWidget {
  const ClipboardScreen({super.key});

  @override
  ConsumerState<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends ConsumerState<ClipboardScreen> {
  final SharedPrefs sharedPrefs = SharedPrefs();

  List<Historial> clipboard = [];

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Future<void> _loadItems() async {
    await sharedPrefs.init();
    setState(() => clipboard = sharedPrefs.getHistory());
  }

  @override
  Widget build(BuildContext context) {
    void save(Historial hist) async {
      await Clipboard.setData(ClipboardData(text: hist.toString()));
    }

    void paste(String ecuacion) {
      try {
        ref.read(calculatorProvider.notifier).pasteFromClipboard(ecuacion);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        SnackBarHelper.show(
          context: context,
          msg: 'Error inserting from history',
        );
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Clipboard'),
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Acciones Clipboard',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: CircleAvatar(child: Icon(Icons.copy)),
                            title: Text(
                              'Copiar ecuacion y resultado en el portapapeles.',
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: CircleAvatar(child: Icon(Icons.paste)),
                            title: Text(
                              'Pegar ecuacion y calcularla. Vuelve a la calculadora.',
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: CircleAvatar(child: Icon(Icons.delete)),
                            title: Text('Eliminar ítem del historial.'),
                          ),
                          const Divider(),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            leading: CircleAvatar(
                              child: Icon(Icons.delete_forever),
                            ),
                            title: Text('Borrar todo el historial.'),
                          ),

                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.info),
            ),
            IconButton(
              onPressed: () {
                //sharedPrefs.clearAll();
                sharedPrefs.clearClipboard();
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
            child: clipboard.isEmpty
                ? Text(
                    'Portapapeles vacío',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : ListView.builder(
                    itemCount: clipboard.length,
                    itemBuilder: (context, index) {
                      var item = clipboard[index];
                      String resultado = item.result;
                      String ecuacion = item.input;
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
                                save(item);
                                SnackBarHelper.show(
                                  context: context,
                                  msg:
                                      'Ecuacion y resultado copiados al portapapeles',
                                );
                              },
                              icon: Icon(Icons.copy),
                            ),
                            IconButton(
                              onPressed: () {
                                paste(ecuacion);
                              },
                              icon: Icon(Icons.paste),
                            ),
                            IconButton(
                              onPressed: () {
                                sharedPrefs.removeHistory(index);
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
      ),
    );
  }
}
