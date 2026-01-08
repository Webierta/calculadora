import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown_widget/markdown_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String data = '';
  final tocController = TocController();

  @override
  void initState() {
    loadFileAsset();
    super.initState();
  }

  @override
  void dispose() {
    tocController.dispose();
    super.dispose();
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
        data = textFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayuda')),
      endDrawer: Drawer(
        child: TocWidget(
          controller: tocController,
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          //itemBuilder: (TocItemBuilderData item) {},
          //tocTextStyle: TextStyle(fontSize: 12),
        ),
      ),
      body: SafeArea(
        child: Container(
          //height: double.infinity,
          //width: double.infinity,
          color: Color(0xff292D36),
          padding: .all(20),
          //single scroll
          child: Column(
            children: [
              Expanded(
                child: MarkdownWidget(
                  data: data,
                  tocController: tocController,
                  shrinkWrap: true,
                  /*markdownGenerator: MarkdownGenerator(
                    richTextBuilder: (span) => Text.rich(span),
                  ),*/
                  config: MarkdownConfig(
                    configs: [
                      ListConfig(marginBottom: 0),
                      H2Config(
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 22,
                        ),
                      ),
                      //PConfig(textStyle: TextStyle(fontSize: 16)),
                      //CodeConfig(style: TextStyle(backgroundColor: Colors.black45),),
                      BlockquoteConfig(textColor: Colors.white54),
                      /*PreConfig(
                        decoration: BoxDecoration(color: Colors.white54),
                        textStyle: TextStyle(fontSize: 8, color: Colors.black),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
