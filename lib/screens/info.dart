import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info')),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xff292D36),
          padding: .all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AboutDialog(
                  applicationName: 'Calculadora',
                  applicationVersion: '0.1',
                  //applicationLegalese: 'GNU v3.0',
                  applicationIcon: Icon(Icons.calculate_outlined, size: 150),
                  children: [
                    Text('Open Source by Webierta'),
                    //Icon(Icons.code),
                    Text('https://github.com/Webierta/calculadora'),
                    Text('GNU General Public License v3.0'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
