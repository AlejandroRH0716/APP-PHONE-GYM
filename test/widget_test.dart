import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('muestra pantalla principal del tracker', (WidgetTester tester) async {
    await tester.pumpWidget(const GymTrackerApp());

    expect(find.text('Tracker de Gym'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Press banca'), findsOneWidget);
  });
}
