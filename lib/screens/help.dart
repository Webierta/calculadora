import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_md/flutter_md.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Markdown markdown = Markdown.fromString('');

  @override
  void initState() {
    loadFileAsset();
    super.initState();
  }

  Future<void> loadFileAsset() async {
    String textFile = '';
    try {
      String fileText = await rootBundle.loadString('assets/files/help.md');
      textFile = fileText;
    } catch (e) {
      textFile = 'Failed to load asset';
    } finally {
      setState(() {
        markdown = Markdown.fromString(textFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayuda')),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff292D36),
          padding: .all(20),
          child: SingleChildScrollView(
            child: MarkdownTheme(
              data: MarkdownThemeData(
                textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                h2Style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              child: MarkdownWidget(markdown: markdown),
            ),
          ),
        ),
      ),
    );
  }
}
