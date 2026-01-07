import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/calculator_notifier.dart';
import '../../providers/historial_notifier.dart';
import 'display_history.dart';

class CalculatorDisplay extends ConsumerWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.watch(calculatorProvider);
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
            child: SizedBox(
              height: 58,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  calculator.result.isEmpty
                      ? (calculator.expression.isEmpty ? '0' : '')
                      : calculator.result,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'ShareTechMono',
                    fontWeight: FontWeight.bold,
                    fontSize: calculator.hasError ? 16 : 42,
                    color: calculator.hasError ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          (history.isNotEmpty)
              ? Expanded(child: const DisplayHistory())
              : const Spacer(),
          Padding(
            padding: .symmetric(horizontal: 10),
            child: Text(
              calculator.expression,
              style: TextStyle(fontSize: 24.0, fontFamily: 'ShareTechMono'),
            ),
          ),
          if (calculator.preview.isNotEmpty && calculator.result.isEmpty)
            Padding(
              padding: .symmetric(horizontal: 10),
              child: Text(
                softWrap: true,
                '= ${calculator.preview}',
                style: TextStyle(fontSize: 18.0, color: Colors.white54),
              ),
            ),
        ],
      ),
    );
  }
}
