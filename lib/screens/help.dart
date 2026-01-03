import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const TextStyle titulo = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
  );

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Entrada', style: titulo),
                Text(
                  'Esta calculadora presenta un teclado con varios tipos de botones:',
                ),
                Text(
                  '- Funciones de limpiar todo (AC), limpiar ecuacion y resultado (C), '
                  'deshacer, copiar (copia al portapapeles y guarda en el Clipboard) y '
                  'pegar (pega ecuacion desde el portapapeles).',
                ),
                const SizedBox(height: 10),
                Text(
                  '- Operadores para calcular porcentaje, módulo, cuadrado, exponente, '
                  'raíz cuadrada, factorial, división, multiplicación, resta y suma.',
                ),
                const SizedBox(height: 10),
                Text('- Números y caracteres (decimal, parentesis y llaves).'),
                const SizedBox(height: 10),
                Text(
                  '- Constantes: π (pi), e (número de Euler o constante de Napier), √2 (ráiz cuadrada de 2 o constante pitagórica).',
                ),
                const SizedBox(height: 10),
                Text(
                  'También es posible pegar una ecuación desde el portapapeles. '
                  'Además, desde el Clipboard se puede pegar directamente una ecuación guardada.',
                ),
                const SizedBox(height: 20),
                Text('Salida', style: titulo),
                Text(
                  'La pantalla de salida muestra la ecuación tecleada o pegada, '
                  'el resultado calculado y el historial de ecuaciones utilizadas.',
                ),
                const SizedBox(height: 20),
                Text('Precisión', style: titulo),
                Text(
                  'Los números se manejan como valores dobles regulares que son '
                  'números de punto flotante de doble precisión de 64 bits como '
                  'se especifica en el Estándar IEEE 754. '
                  'Aproximadamente ofrecen hasta 15 dígitos de precisión.',
                ),
                const SizedBox(height: 10),
                Text('El resultado se expresa con un máximo de 10 decimales.'),
                const SizedBox(height: 20),
                Text(
                  'Secuencia de operadores. Jerarquía detallada',
                  style: titulo,
                ),
                Text(
                  '''1. Paréntesis y Signos de Agrupación (Paréntesis, Llaves): Resuelve primero lo que esté dentro de ellos.

2. Exponentes y Raíces: Calcula potencias y raíces.

3. Multiplicación y División: Realiza estas operaciones en el orden en que aparecen, de izquierda a derecha.

4. Suma y Resta: Ejecuta estas operaciones al final, también de izquierda a derecha.''',
                ),
                const SizedBox(height: 10),
                Text(
                  '''Es importante conocer y aplicar correctamente la jerarquía de operaciones para obtener un resultado correcto. Por ejemplo:

5+3x4 = 8x4 = 32 Incorrecto, no se respetó la jerarquía.

5+3x4 = 5+12 = 17 Correcto.''',
                ),
                const SizedBox(height: 20),
                Text('Ecuación de Raíz cuadrada', style: titulo),
                Text(
                  'El radicando debe preceder al símbolo raíz. Ejemplo para calcular la raíz cuadrada de 49:',
                ),
                const SizedBox(height: 10),
                Text('49√ = 7'),
                const SizedBox(height: 20),
                Text('Ecuación de porcentaje', style: titulo),
                Text('Ejemplo para calcular el 50% de 30:'),
                const SizedBox(height: 10),
                Text('50％30 = 15'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
