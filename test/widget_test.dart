import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/app/healwise_app.dart';

void main() {
  testWidgets('language selection opens auth and profile flow', (tester) async {
    await tester.pumpWidget(const HealWiseApp());

    expect(find.text('HealWise AI'), findsOneWidget);
    expect(find.text('Continue in English'), findsOneWidget);

    await tester.tap(find.text('Continue in English'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.text('Continue demo'));
    await tester.pumpAndSettle();

    expect(find.text('Health profile setup'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Demo User',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Age'), '22');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Height (cm)'),
      '170',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Weight (kg)'),
      '65',
    );

    await tester.drag(find.byType(ListView), const Offset(0, -450));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('AI Chatbot'), findsWidgets);

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();

    expect(find.text('Progress Tracker'), findsOneWidget);
  });
}
