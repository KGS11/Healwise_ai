import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/features/daa_dashboard/presentation/daa_dashboard_screen.dart';

void main() {
  testWidgets('DaaDashboardScreen renders correctly and shows sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DaaDashboardScreen(),
      ),
    );

    // Verify AppBar titles
    expect(find.text('DAA Dashboard'), findsOneWidget);
    expect(find.text('Design & Analysis of Algorithms in HealWise AI'), findsOneWidget);

    // Verify header banner
    expect(find.text('Algorithms Behind HealWise AI'), findsOneWidget);
    expect(
      find.textContaining('OCR, Yoga Analysis, AI Recommendations, Firebase Operations, and Health Tracking'),
      findsOneWidget,
    );

    // Verify section headers
    expect(find.text('Algorithm Usage Across HealWise AI'), findsOneWidget);
    expect(find.text('Clickable Algorithm Cards'), findsOneWidget);
    expect(find.text('Algorithm vs Module Alignment Matrix'), findsOneWidget);
    expect(find.text('Algorithmic Data Pipelines'), findsOneWidget);
    expect(find.text('DAA Concepts Used in HealWise AI'), findsOneWidget);

    // Verify 10 cards are rendered via keys
    expect(find.byKey(const ValueKey('daa_card_Pattern Matching')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Searching Algorithms')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Classification Algorithms')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Image Processing')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Sorting Algorithms')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Filtering Algorithms')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Greedy Technique')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Brute Force Technique')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Backtracking Technique')), findsOneWidget);
    expect(find.byKey(const ValueKey('daa_card_Dynamic Programming')), findsOneWidget);
  });

  testWidgets('Tapping a graph bar item displays/toggles tooltip details', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DaaDashboardScreen(),
      ),
    );

    // Verify tooltip is not visible initially
    expect(find.text('OCR Text Recognition Analysis'), findsNothing);

    // Tap the 'Pattern Matching' bar item
    final patternMatchingText = find.text('Pattern Matching').first;
    expect(patternMatchingText, findsOneWidget);
    await tester.tap(patternMatchingText);
    await tester.pump(); // Rebuild state

    // Verify tooltip appears
    expect(find.text('OCR Text Recognition Analysis'), findsOneWidget);

    // Tap it again to toggle
    await tester.tap(patternMatchingText);
    await tester.pump();

    // Verify tooltip disappears
    expect(find.text('OCR Text Recognition Analysis'), findsNothing);
  });

  testWidgets('Tapping an algorithm card opens detailed popup dialog and dismisses it', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DaaDashboardScreen(),
      ),
    );

    // Click on Pattern Matching card (scroll into view first)
    final patternCard = find.byKey(const ValueKey('daa_card_Pattern Matching'));
    expect(patternCard, findsOneWidget);
    await tester.ensureVisible(patternCard);
    await tester.tap(patternCard);
    await tester.pumpAndSettle(); // Wait for dialog transition

    // Verify dialog content is correct
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('OCR Medical Report Analyzer'), findsAtLeastNWidgets(1));
    expect(find.text('Detect BP values'), findsAtLeastNWidgets(1));
    expect(find.text('Detect Sugar values'), findsAtLeastNWidgets(1));
    expect(find.text('Keyword matching'), findsAtLeastNWidgets(1));
    expect(find.text('Complexity: O(n)'), findsAtLeastNWidgets(1));

    // Tap close dismiss button
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // Verify dialog closes
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Tapping all cards presents accurate computational and module metadata', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DaaDashboardScreen(),
      ),
    );

    // 1. Searching Algorithms
    final searchCard = find.byKey(const ValueKey('daa_card_Searching Algorithms'));
    await tester.ensureVisible(searchCard);
    await tester.tap(searchCard);
    await tester.pumpAndSettle();
    expect(find.text('Firebase user lookup'), findsAtLeastNWidgets(1));
    expect(find.text('Find required records quickly'), findsAtLeastNWidgets(1));
    expect(find.text('Complexity: O(log n) to O(n)'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 2. Classification Algorithms
    final classCard = find.byKey(const ValueKey('daa_card_Classification Algorithms'));
    await tester.ensureVisible(classCard);
    await tester.tap(classCard);
    await tester.pumpAndSettle();
    expect(find.text('Yoga Assistant'), findsAtLeastNWidgets(1));
    expect(find.text('Categorize results'), findsAtLeastNWidgets(1));
    expect(find.text('Examples: Normal, High, Low'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 3. Image Processing
    final imgCard = find.byKey(const ValueKey('daa_card_Image Processing'));
    await tester.ensureVisible(imgCard);
    await tester.tap(imgCard);
    await tester.pumpAndSettle();
    expect(find.text('Extract image features'), findsAtLeastNWidgets(1));
    expect(find.text('Detect body landmarks'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 4. Sorting Algorithms
    final sortCard = find.byKey(const ValueKey('daa_card_Sorting Algorithms'));
    await tester.ensureVisible(sortCard);
    await tester.tap(sortCard);
    await tester.pumpAndSettle();
    expect(find.text('Arrange records by date'), findsAtLeastNWidgets(1));
    expect(find.text('Complexity: O(n log n)'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 5. Filtering Algorithms
    final filterCard = find.byKey(const ValueKey('daa_card_Filtering Algorithms'));
    await tester.ensureVisible(filterCard);
    await tester.tap(filterCard);
    await tester.pumpAndSettle();
    expect(find.text('Display only required data'), findsAtLeastNWidgets(1));
    expect(find.text('Examples: Show only reports, Show only yoga history'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 6. Greedy Technique
    final greedyCard = find.byKey(const ValueKey('daa_card_Greedy Technique'));
    await tester.ensureVisible(greedyCard);
    await tester.tap(greedyCard);
    await tester.pumpAndSettle();
    expect(find.text('Select best recommendation first'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 7. Brute Force Technique
    final bruteCard = find.byKey(const ValueKey('daa_card_Brute Force Technique'));
    await tester.ensureVisible(bruteCard);
    await tester.tap(bruteCard);
    await tester.pumpAndSettle();
    expect(find.text('Scan all possible keywords'), findsAtLeastNWidgets(1));
    expect(find.text('Example: Checking all text entries to find BP or Sugar values'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 8. Backtracking Technique
    final backCard = find.byKey(const ValueKey('daa_card_Backtracking Technique'));
    await tester.ensureVisible(backCard);
    await tester.tap(backCard);
    await tester.pumpAndSettle();
    expect(find.text('Academic Relevance: DAA syllabus concept.'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();

    // 9. Dynamic Programming
    final dpCard = find.byKey(const ValueKey('daa_card_Dynamic Programming'));
    await tester.ensureVisible(dpCard);
    await tester.tap(dpCard);
    await tester.pumpAndSettle();
    expect(find.text('No optimization problem currently requires DP.'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Dismiss Plan'));
    await tester.pumpAndSettle();
  });
}
