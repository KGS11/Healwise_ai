import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/features/math_dashboard/presentation/math_dashboard_screen.dart';

void main() {
  testWidgets('MathDashboardScreen renders correctly and shows sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MathDashboardScreen(),
      ),
    );

    // Verify AppBar titles
    expect(find.text('Mathematical Dashboard'), findsOneWidget);
    expect(find.text('Academic & algorithmic foundations of HealWise AI'), findsOneWidget);

    // Verify academic banner
    expect(find.text('Academic Viva Presentation'), findsOneWidget);

    // Verify key sections are present
    expect(find.text('Mathematics Behind HealWise AI'), findsOneWidget);
    expect(find.text('Core Concept Utilization Index'), findsOneWidget);
    expect(find.text('Where Mathematics Appears in HealWise'), findsOneWidget);

    // Verify that the 6 mathematical concepts cards are rendered via keys
    expect(find.byKey(const ValueKey('concept_card_Probability')), findsOneWidget);
    expect(find.byKey(const ValueKey('concept_card_Statistics')), findsOneWidget);
    expect(find.byKey(const ValueKey('concept_card_Coordinate Geometry')), findsOneWidget);
    expect(find.byKey(const ValueKey('concept_card_Trigonometry')), findsOneWidget);
    expect(find.byKey(const ValueKey('concept_card_Coding Theory')), findsOneWidget);
    expect(find.byKey(const ValueKey('concept_card_Group Theory')), findsOneWidget);

    // Verify mapping badges exist
    expect(find.text('OCR Analyzer'), findsOneWidget);
    expect(find.text('Yoga Assistant'), findsOneWidget);
    expect(find.text('Progress Tracker'), findsOneWidget);
    expect(find.text('AI Assistant'), findsOneWidget);
  });

  testWidgets('Tapping a math concept card opens popup dialog and close dismisses it', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MathDashboardScreen(),
      ),
    );

    // Click on Probability concept card by key (scroll into view first)
    final probabilityCard = find.byKey(const ValueKey('concept_card_Probability'));
    expect(probabilityCard, findsOneWidget);
    await tester.ensureVisible(probabilityCard);
    await tester.tap(probabilityCard);
    await tester.pumpAndSettle(); // Wait for popup transition

    // Verify Dialog content is visible
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('OCR confidence score'), findsOneWidget);
    expect(find.text('Yoga pose confidence score'), findsOneWidget);
    expect(find.text('AI prediction confidence'), findsOneWidget);
    expect(find.text('Confidence calculations'), findsOneWidget);
    expect(find.text('Result scoring'), findsOneWidget);

    // Verify close buttons exist
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Dismiss Plan'), findsOneWidget);

    // Tap dismiss button
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle(); // Wait for close transition

    // Verify dialog is gone
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Tapping each concept card shows correct detailed popup information', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MathDashboardScreen(),
      ),
    );

    // 1. Statistics
    final statsCard = find.byKey(const ValueKey('concept_card_Statistics'));
    await tester.ensureVisible(statsCard);
    await tester.tap(statsCard);
    await tester.pumpAndSettle();
    expect(find.text('Health Progress Tracker'), findsOneWidget);
    expect(find.text('Average calculations'), findsOneWidget);
    expect(find.text('Trend analysis'), findsOneWidget);
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 2. Coordinate Geometry
    final geomCard = find.byKey(const ValueKey('concept_card_Coordinate Geometry'));
    await tester.ensureVisible(geomCard);
    await tester.tap(geomCard);
    await tester.pumpAndSettle();
    expect(find.text('MediaPipe landmarks'), findsOneWidget);
    expect(find.text('Joint coordinates'), findsOneWidget);
    expect(find.text('Pose detection'), findsOneWidget);
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 3. Trigonometry
    final trigCard = find.byKey(const ValueKey('concept_card_Trigonometry'));
    await tester.ensureVisible(trigCard);
    await tester.tap(trigCard);
    await tester.pumpAndSettle();
    expect(find.text('Angle calculations'), findsOneWidget);
    expect(find.text('Yoga posture verification'), findsOneWidget);
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 4. Coding Theory
    final codingCard = find.byKey(const ValueKey('concept_card_Coding Theory'));
    await tester.ensureVisible(codingCard);
    await tester.tap(codingCard);
    await tester.pumpAndSettle();
    expect(find.text('OCR text recognition'), findsOneWidget);
    expect(find.text('Error correction concepts'), findsOneWidget);
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 5. Group Theory
    final groupCard = find.byKey(const ValueKey('concept_card_Group Theory'));
    await tester.ensureVisible(groupCard);
    await tester.tap(groupCard);
    await tester.pumpAndSettle();
    expect(find.text('Academic syllabus reference'), findsOneWidget);
    expect(find.text('Not directly implemented'), findsOneWidget);
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();
  });
}
