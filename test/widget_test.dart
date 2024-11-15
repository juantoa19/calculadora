import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calcu/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Construir la aplicación y disparar un frame
    await tester.pumpWidget(const MaterialApp(home: CalculadoraScreen())); // Agrega MaterialApp aquí

    // Verificar que el contador empieza en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tocar el ícono '+' y disparar un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verificar que el contador se ha incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
