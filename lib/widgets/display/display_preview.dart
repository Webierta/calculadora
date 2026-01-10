import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/calculator_notifier.dart';

class DisplayPreview extends ConsumerStatefulWidget {
  const DisplayPreview({super.key});

  @override
  ConsumerState createState() => _DisplayPreviewState();
}

class _DisplayPreviewState extends ConsumerState<DisplayPreview>
    with TickerProviderStateMixin {
  final cursorKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _animation;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToCursor() {
    // Ensure the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = cursorKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
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

    scrollToCursor();

    return Padding(
      padding: .symmetric(horizontal: 10),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        //physics: const NeverScrollableScrollPhysics(),
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
                key: cursorKey,
                maxLines: 1,
                cursor,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Colors.blueAccent,
                  fontSize: 24,
                  fontFamily: 'ShareTechMono',
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
