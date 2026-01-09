import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ecuacion.dart';
import '../providers/calculator_notifier.dart';
import '../utils/shared_prefs.dart';
import '../utils/snack_bar_helper.dart';

class MemoriaScreen extends ConsumerStatefulWidget {
  const MemoriaScreen({super.key});

  @override
  ConsumerState<MemoriaScreen> createState() => _MemoriaScreenState();
}

class _MemoriaScreenState extends ConsumerState<MemoriaScreen> {
  final SharedPrefs sharedPrefs = SharedPrefs();
  List<Ecuacion> memory = [];
  int? indexSelected;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Future<void> _loadItems() async {
    await sharedPrefs.init();
    setState(() => memory = sharedPrefs.memoryRecall());
  }

  void showDialogInfo() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Info Memoria',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Column(children: [Icon(Icons.copy), Text('CC')]),
                title: Text('Copiar'),
                subtitle: Text(
                  'Copia la ecuacion (expresión y resultado) en el portapapeles del dispositivo.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Column(children: [Icon(Icons.paste), Text('MR')]),
                title: Text('Memory Recall'),
                subtitle: Text(
                  'Recupera la expresión almacenada y la inserta en el campo de expresión, en el punto actual del cursor. Vuelve a la calculadora.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Column(children: [Icon(Icons.delete), Text('MC')]),
                title: Text('Memory Clear'),
                subtitle: Text(
                  'Borra de la memoria la ecuación seleccionada.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Column(
                  children: [Icon(Icons.delete_forever), Text('MAC')],
                ),
                title: Text('Memory All Clear'),
                subtitle: Text(
                  'Vacía toda la memoria.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
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
  }

  void copy() async {
    if (indexSelected == null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SnackBarHelper.show(
        context: context,
        msg: 'Selecciona una ecuación para copiar',
      );
      return;
    }
    try {
      Ecuacion ec = memory[indexSelected!];
      await Clipboard.setData(ClipboardData(text: ec.toString())).then(((_) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        SnackBarHelper.show(
          context: context,
          msg: 'Ecuacion y resultado copiados al portapapeles',
        );
      }));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        SnackBarHelper.show(
          context: context,
          msg: 'Error al copiar al portapapeles',
        );
      }
    }
  }

  void paste(CalculatorNotifier calculatorNotifier) {
    if (indexSelected == null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SnackBarHelper.show(
        context: context,
        msg: 'Selecciona una ecuación para recuperar.',
      );
      return;
    }
    try {
      Ecuacion ec = memory[indexSelected!];
      String ecuacion = ec.input;
      //ref.read(calculatorProvider.notifier).pasteFromClipboard(ecuacion);
      //calculatorNotifier.pasteFromClipboard(ecuacion);
      calculatorNotifier.pasteToExpression(ecuacion);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SnackBarHelper.show(
        context: context,
        msg: 'Error recuparando desde Memoria',
      );
    }
  }

  void remove() {
    if (indexSelected == null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SnackBarHelper.show(
        context: context,
        msg: 'Selecciona una ecuación para eliminar.',
      );
      return;
    }
    try {
      sharedPrefs.memoryClear(indexSelected!);
      _loadItems();
      setState(() => indexSelected = null);
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SnackBarHelper.show(context: context, msg: 'Error al borrar en Memoria');
    }
  }

  void removeAll() {
    sharedPrefs.memoryAllClear();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Memoria'),
          actions: [
            IconButton(
              onPressed: showDialogInfo,
              icon: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          iconSize: 32,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: (index) {
            if (index case 0) {
              copy();
            } else if (index case 1) {
              paste(ref.read(calculatorProvider.notifier));
            } else if (index case 2) {
              remove();
            } else if (index case 3) {
              removeAll();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.copy),
              label: 'CC',
              tooltip: 'Copiar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.paste),
              label: 'MR',
              tooltip: 'Recuperar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: 'MC',
              tooltip: 'Eliminar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete_forever),
              label: 'MAC',
              tooltip: 'Borrar memoria',
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            //padding: const EdgeInsets.symmetric(vertical: 1),
            height: double.infinity,
            width: double.infinity,
            color: Color(0xff292D36),
            child: memory.isEmpty
                ? Center(
                    child: Text(
                      'Memoria vacía',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  )
                : ListView.separated(
                    itemCount: memory.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (context, index) {
                      var item = memory[index];
                      String resultado = item.result;
                      String ecuacion = item.input;
                      return ListTile(
                        //contentPadding: .all(4),
                        //titleAlignment: ListTileTitleAlignment.top,
                        selected: index == indexSelected,
                        leading: CircleAvatar(
                          backgroundColor: index == indexSelected
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Colors.black12,
                          child: Text('${index + 1}'),
                        ),
                        title: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text(
                            resultado,
                            style: TextStyle(fontFamily: 'ShareTechMono'),
                          ),
                        ),
                        subtitle: Text(ecuacion),
                        trailing: Checkbox(
                          value: indexSelected == index,
                          onChanged: (bool? onChanged) {
                            setState(() {
                              if (index == indexSelected) {
                                indexSelected = null;
                              } else {
                                indexSelected = index;
                              }
                              //indexSelected = index;
                            });
                          },
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
