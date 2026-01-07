import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/historial_notifier.dart';

class DisplayHistory extends StatelessWidget {
  const DisplayHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: Consumer(
        builder: (context, ref, _) {
          final history = ref.watch(historialProvider);
          return ListView.builder(
            padding: .symmetric(horizontal: 10),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final reversedHistory = history.reversed.toList();
              final calculation = reversedHistory[index];
              return Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      //maxLines: 3,
                      //overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      calculation.input,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topRight,
                      child: Text(
                        calculation.result,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                          fontFamily: 'ShareTechMono',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
