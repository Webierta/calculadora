import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/calculator_notifier.dart';

class DisplayPreview2 extends ConsumerStatefulWidget {
  const DisplayPreview2({super.key});

  @override
  ConsumerState createState() => _DisplayPreview2State();
}

class _DisplayPreview2State extends ConsumerState<DisplayPreview2>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calculator = ref.watch(calculatorProvider);
    final expression = calculator.expression;
    final cursorPosition = calculator.cursorPosition;

    final String leftCursor = expression.substring(0, cursorPosition);
    final String rightCursor = expression.substring(cursorPosition);
    const String cursor = '|';
    //final String paste = leftCursor + cursor + rightCursor;

    //scrollController.
    //.position = cursorPosition;

    /*scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );*/

    /*if (scrollController.hasClients) {
      scrollController.animateTo(
        //scrollController.position.pixels,
        //cursorPosition.toDouble(),
        scrollController.position.maxScrollExtent,
        //leftCursor.length.toDouble(),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }*/

    return Padding(
      padding: .symmetric(horizontal: 10),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              leftCursor,
              maxLines: 1,
              style: TextStyle(fontSize: 24.0, fontFamily: 'ShareTechMono'),
            ),
            FadeTransition(
              opacity: _animation,
              child: Text(
                maxLines: 1,
                cursor,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Colors.blueAccent,
                  fontFamily: 'ShareTechMono',
                  //fontFamily: 'RobotoMono',
                  fontSize: 24,
                  //Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              rightCursor,
              maxLines: 1,
              style: TextStyle(fontSize: 24.0, fontFamily: 'ShareTechMono'),
            ),
          ],
        ),
      ),
    );
  }
}
