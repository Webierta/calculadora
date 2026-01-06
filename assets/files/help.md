# Entrada de datos

## Teclado

Esta calculadora presenta un teclado con varios tipos de botones:

- **Funciones** de limpiar todo (AC), limpiar ecuacion y resultado (C), deshacer, copiar (copia al portapapeles y guarda en el Clipboard) y pegar (pega ecuacion desde el portapapeles).

- **Operadores** para calcular porcentaje, módulo, cuadrado, exponente, raíz cuadrada, factorial, división, multiplicación, resta y suma.

- **Números y caracteres** (decimal, parentesis y llaves).

- **Constantes**: π (pi), e (número de Euler o constante de Napier), √² (ráiz cuadrada de 2 o constante pitagórica).

También es posible **pegar una ecuación** desde el portapapeles. Además, desde el Clipboard se puede pegar directamente una ecuación guardada.

## Sugerencias, expresiones y ecuaciones

Según se ingresan datos, la calculadora va facilitando sugerencias para la correcta expresión de la ecuación. Por ejemplo, después de introducir un operador normalmente se sugiere introducir otro número.

Si la expresión introducida no se reconoce como válida, se avisará del error antes de intentar hacer los cálculos.

Para calcular la raíz cuadrada, se requiere que el radicando esté entre paréntesis (también al pegar una ecuación desde el portapapeles), por lo que al escribir el operador √ se escribe automáticamente el primer paréntesis, y se recuerda no introducir un número negativo. Si después de introducir un número no se cierra el paréntesis se recordará que la expresión está incompleta.

Ejemplo para calcular la raíz cuadrada de 49:

`√(49) = 7`

Ejemplo para calcular el 50% de 30:

`50％30 = 15` (en pantalla aparecerá `50 / 100 * 30`)

Los exponentes negativos deben encerrarse entre paréntesis:

`2^(-3) = 0.125`

# Salida de datos

## Pantalla

La pantalla de salida muestra, de arriba a abajo:

- El **resultado** calculado o, en su caso, un aviso de error.
- El **historial** de ecuaciones utilizadas en la actual sesión (si lo hay).
- La expresión o ecuación tecleada o pegada.
- La **previsualización** del resultado o, en su caso, una **sugerencia** o un aviso de error (desaparece cuando se obtiene el resultado).

## Formato

**El separador de decimales siempre es un punto.**

En el resultado, el **separador de millares** es un espacio en blanco. De acuerdo con las directrices del Sistema Internacional de Unidades, no debe ponerse ningún otro signo distinto al separador decimal pero, para facilitar la lectura de números grandes, pueden agruparse las cifras de tres en tres a partir de la coma o punto decimal, separándolas con un espacio fino, tanto en la parte entera como en la fraccionaria. No debe usarse ni punto ni coma como separador de millares. La norma ISO/IEC 80000-1:2009 establece que ha de hacerse tanto en la parte entera como en la decimal.

Asimismo, el libro de estilo de la lengua española recomienda un espacio fino en la separación de millares tanto en la parte entera como decimal.

## Precisión

Los números se manejan como valores dobles regulares que son números de punto flotante de doble precisión de 64 bits como se especifica en el Estándar IEEE 754. Aproximadamente ofrecen hasta 15 dígitos de precisión.

El resultado se expresa con un máximo de 8 decimales.

## Secuencia de operadores. Jerarquía detallada

1. Paréntesis y Signos de Agrupación (paréntesis, llaves): Resuelve primero lo que esté dentro de ellos.

2. Exponentes y Raíces: Calcula potencias y raíces.

3. Multiplicación y División: Realiza estas operaciones en el orden en que aparecen, de izquierda a derecha.

4. Suma y Resta: Ejecuta estas operaciones al final, también de izquierda a derecha.

Es importante conocer y aplicar correctamente la jerarquía de operaciones para obtener un resultado correcto. Por ejemplo:

`5+3x4 = 8x4 = 32` Incorrecto, no se respetó la jerarquía.

Correcto: `5+3x4 = 5+12 = 17`
