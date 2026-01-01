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
                FittedBox(
                  child: const AboutDialog(
                    applicationName: 'Calculadora',
                    applicationVersion: '1.0.0\nby Webierta',
                    applicationLegalese: 'Licencia GPLv3',
                    applicationIcon: Icon(Icons.calculate_outlined, size: 200),
                    children: [
                      Text('Open Source. Copyleft 2025-2026'),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.code),
                          Text(' in github.com/Webierta/calculadora'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('GNU General Public License v3.0'),
                      SizedBox(height: 10),
                      Text('All Wrongs Reserved.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
