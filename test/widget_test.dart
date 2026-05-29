import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healwise_ai/features/language/presentation/language_selection_screen.dart';

void main() {
  testWidgets('language selection opens login screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LanguageSelectionScreen())),
    );

    expect(find.text('HealWise AI'), findsOneWidget);
    expect(find.text('Continue in English'), findsOneWidget);

    await tester.tap(find.text('Continue in English'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
