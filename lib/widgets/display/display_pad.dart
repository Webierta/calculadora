import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/ecuacion_notifier.dart';
import '../../providers/historial_notifier.dart';
import '../../providers/resultado_notifier.dart';

class DisplayPad extends ConsumerStatefulWidget {
  const DisplayPad({super.key});

  @override
  ConsumerState<DisplayPad> createState() => _PantallaState();
}

class _PantallaState extends ConsumerState<DisplayPad> {
  final TextEditingController ecuacionController = TextEditingController();

  @override
  void initState() {
    ecuacionController.text = '';
    //ecuacionController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    ecuacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pantallaEcuacion = ref.watch(ecuacionProvider);
    final pantallaResultado = ref.watch(resultadoProvider);
    ecuacionController.text = pantallaEcuacion;
    final history = ref.watch(historialProvider);

    return Container(
      //padding: .symmetric(horizontal: 10),
      color: Color(0xff22252D),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: .symmetric(horizontal: 10),
            child: FittedBox(
              child: Text(
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'ShareTechMono',
                  fontWeight: FontWeight.bold,
                  fontSize: 42.0,
                  color: pantallaResultado == 'Error'
                      ? Colors.red
                      : Colors.white,
                ),
                pantallaResultado,
              ),
            ),
          ),
          (history.isNotEmpty)
              ? Expanded(
                  child: Container(
                    color: Colors.white10,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final reversedHistory = history.reversed.toList();
                        final calculation = reversedHistory[index];
                        return ListTile(
                          title: Text(
                            calculation.input,
                            style: TextStyle(color: Colors.white54),
                          ),
                          trailing: Text(
                            calculation.result,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white54,
                                  fontFamily: 'ShareTechMono',
                                ),
                          ),
                          contentPadding: .symmetric(horizontal: 10),
                        );
                      },
                    ),
                  ),
                )
              : const Spacer(),
          Padding(
            padding: .symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextField(
                minLines: 1,
                maxLines: 3,
                //maxLines: 1,
                controller: ecuacionController,
                onChanged: (input) {
                  ecuacionController.text = input.replaceAll(',', '.');
                  ref.read(ecuacionProvider.notifier).clear();
                  ref
                      .read(ecuacionProvider.notifier)
                      .add(ecuacionController.text);
                },
                textAlign: TextAlign.end,
                decoration: InputDecoration(border: InputBorder.none),
                style: TextStyle(fontSize: 24.0, fontFamily: 'ShareTechMono'),
                //maxLines: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
