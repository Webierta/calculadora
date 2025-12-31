import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ecuacion_notifier.dart';
import '../providers/resultado_notifier.dart';

class Pantalla extends ConsumerStatefulWidget {
  const Pantalla({super.key});

  @override
  ConsumerState<Pantalla> createState() => _PantallaState();
}

class _PantallaState extends ConsumerState<Pantalla> {
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

    return Container(
      padding: .symmetric(horizontal: 10),
      color: Color(0xff22252D),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            child: Text(
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'ShareTechMono',
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: pantallaResultado == 'Error' ? Colors.red : Colors.white,
              ),
              pantallaResultado,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextField(
                minLines: 1,
                maxLines: 10,
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
                style: TextStyle(fontSize: 24.0, color: Colors.white54),
                //maxLines: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
