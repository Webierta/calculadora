import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/calculator_notifier.dart';

class DisplayPreview extends ConsumerWidget {
  const DisplayPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.watch(calculatorProvider);
    final expression = calculator.expression;
    final cursorPosition = calculator.cursorPosition;

    final String leftCursor = expression.substring(0, cursorPosition);
    final String rightCursor = expression.substring(cursorPosition);
    const String cursor = '|';
    return Padding(
      padding: .symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RichText(
          maxLines: 1,
          //overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: TextStyle(fontSize: 24.0, fontFamily: 'ShareTechMono'),
            children: [
              TextSpan(text: leftCursor),
              TextSpan(
                text: cursor,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Colors.blueAccent,
                  fontFamily: 'ShareTechMono',
                  //fontFamily: 'RobotoMono',
                  fontSize: 24,
                  //Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(text: rightCursor),
            ],
          ),
        ),
      ),
    );
  }
}
