# Entrada de datos

## Teclado

Esta calculadora presenta un teclado con varios tipos de botones:

- **Funciones**:

  - AC (All Clear): Limpia toda la pantalla.  
  - C (Clear): Borra ecuación (expresión y resultado) manteniendo historial.  
  - ⌫: Deshace último carácter escrito.  
  - MS (Memory Store): Almacena la ecuación en memoria y copia la expresión al portapapeles del dispositivo.  
  - MR (Memory Recall): Añade el valor del portapapeles al campo de la expresión, en el lugar actual del cursor, por defecto al final.

- **Operadores** para calcular porcentaje, módulo, cuadrado, exponente, raíz cuadrada, factorial, división, multiplicación, resta y suma.

- **Números**, **caracteres** (decimal y paréntesis) y **desplazamiento del cursor** (↤ izquierda y ↦ derecha, y con pulsación prolongada a saltos de 5 posiciones). La posición del cursor indica el lugar de entrada del teclado y de los valores pegados desde el portapapeles y recuperados desde la Memoria. 

- **Constantes**: *π* (pi), *e* (número de Euler o constante de Napier), *√²* (raíz cuadrada de 2 o constante pitagórica).

Además del teclado, se puede insertar directamente una expresión o un valor desde el portapapeles del dispositivo o desde la Memoria de la Calculadora.

## Expresiones

Según se ingresan datos, la calculadora va facilitando sugerencias para la correcta expresión de la ecuación. Por ejemplo, después de introducir un operador normalmente se sugiere introducir otro número.

Si la expresión introducida no se reconoce como válida, se avisará del error antes de intentar hacer los cálculos.

Ejemplo: Para calcular la raíz cuadrada, se requiere que el radicando esté entre paréntesis (también al pegar una ecuación desde el portapapeles), por lo que al escribir el operador √ se escribe automáticamente el primer paréntesis, y se recuerda no introducir un número negativo. Si después de introducir un número no se cierra el paréntesis se recordará que la expresión está incompleta.

Así, por ejemplo, para calcular la raíz cuadrada de 49:

> √(49) = 7

Ejemplo para calcular el 50% de 30:

> 50％30 = 15
> en pantalla se traduce como
> 50/100*30

Los exponentes negativos deben encerrarse entre paréntesis:

> 2^(-3) = 0.125

# Salida de datos

## Pantalla

La pantalla de salida muestra, de arriba a abajo:

- El **resultado** calculado o, en su caso, un aviso de error.

- El **historial** de ecuaciones utilizadas en la actual sesión (si lo hay). Se pierde cuando se cierra la aplicación.

- La expresión o ecuación introducida (tecleada o pegada).

- La **previsualización** del resultado o, en su caso, una **sugerencia** o un aviso de error (desaparece cuando se obtiene el resultado).

## Formato

**El separador de decimales siempre es un punto.**

En el resultado, el **separador de millares** es un espacio en blanco. De acuerdo con las directrices del Sistema Internacional de Unidades, no debe ponerse ningún otro signo distinto al separador decimal pero, para facilitar la lectura de números grandes, pueden agruparse las cifras de tres en tres a partir de la coma o punto decimal, separándolas con un espacio fino, tanto en la parte entera como en la fraccionaria. No debe usarse ni punto ni coma como separador de millares. La norma ISO/IEC 80000-1:2009 establece que ha de hacerse tanto en la parte entera como en la decimal.

Asimismo, el libro de estilo de la lengua española recomienda un espacio fino en la separación de millares tanto en la parte entera como decimal.

## Precisión

Los números se manejan como valores dobles regulares que son números de punto flotante de doble precisión de 64 bits como se especifica en el Estándar IEEE 754. Aproximadamente ofrecen hasta 15 dígitos de precisión.

El resultado se expresa con un máximo de 8 decimales.

Las cantidades muy grandes (valores absolutos iguales o mayores que 10²¹) o muy pequeñas (valores absolutos menores que 10⁻⁶) se expresan de manera simplificada mediante la notación científica utilizando la letra *e* (notación e) para indicar la potencia de 10.

La notación e, donde la letra e seguida de un número representa, literalmente, «multiplicado por diez elevado a» (es decir, × 10ⁿ).

Dicho de otro modo, si tomamos dos números reales # y n, la representación #en significaría exactamente # × 10ⁿ.  Así, por ejemplo, 0.0000001 se escribe 1e-7 o el número de Avogadro (602214076000000000000000, seiscientos dos mil doscientos catorce trillones setenta y seis mil billones) se escribe 6.02214076e+23.

## Secuencia de operadores

Jerarquía detallada:

1. Signos de Agrupación (paréntesis): Resuelve primero lo que esté dentro de ellos.

2. Exponentes y Raíces: Calcula potencias y raíces.

3. Multiplicación y División: Realiza estas operaciones en el orden en que aparecen, de izquierda a derecha.

4. Suma y Resta: Ejecuta estas operaciones al final, también de izquierda a derecha.

Es importante conocer y aplicar correctamente la jerarquía de operaciones para obtener un resultado correcto. Por ejemplo:

> 5+3x4 = 8x4 = 32  Incorrecto, no se respetó la jerarquía.
> Correcto: 5+3x4 = 5+12 = 17

# Memoria

La calculadora dispone de una Memoria avanzada que muestra las ecuaciones que han sido almacenadas desde la página principal de la Calculadora con la tecla MS (Memory Store).

Esta Memoria es útil no solo para almacenar expresiones y su resultado, también como memoria de los números que interesa guardar para recuperar después y operar con ellos.  

Las acciones que ofrece Memoria son:

- *CC* (Copiar): Copia la ecuacion (expresión y resultado) en el portapapeles del dispositivo.

- *MR* (Memory Recall): Recupera la expresión almacenada y la inserta en el campo de expresión, en el punto actual del cursor. Vuelve a la calculadora.

- *MC* (Memory Clear): Borra de la memoria la ecuación seleccionada.

- *MAC* (Memory All Clear): Vacía toda la memoria.
