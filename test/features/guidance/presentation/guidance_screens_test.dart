import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/features/guidance/presentation/audio_guidance_screen.dart';
import 'package:healwise_ai/features/guidance/presentation/video_guidance_screen.dart';
import 'package:healwise_ai/features/guidance/presentation/widgets/audio_content_card.dart';
import 'package:healwise_ai/features/guidance/presentation/widgets/video_content_card.dart';

void main() {
  group('AudioGuidanceScreen Tests', () {
    testWidgets('renders screen title and all category items correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AudioGuidanceScreen(),
        ),
      );

      // Verify header titles
      expect(find.text('Audio Guidance'), findsOneWidget);
      expect(
        find.text('Healing sounds and guided meditations'),
        findsOneWidget,
      );

      // Verify category tabs that are initially on screen exist
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Morning Energy'), findsOneWidget);
      expect(find.text('Afternoon Focus'), findsOneWidget);
      expect(find.text('Stress Relief'), findsOneWidget);

      // Verify audio content cards render
      expect(find.byType(AudioContentCard), findsWidgets);
    });

    testWidgets('filtering categories displays only matching audio tracks',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AudioGuidanceScreen(),
        ),
      );

      // Click "Morning Energy" category chip (fully visible next to All)
      await tester.tap(find.text('Morning Energy'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify tracks in sleep category exist and non-sleep do not
      expect(find.text('5 Minute Morning Motivation'), findsOneWidget);
      expect(find.text('Wake-up Breathing Exercise'), findsOneWidget);
      expect(find.text('Calm Breathing'), findsNothing);
    });
  });

  group('VideoGuidanceScreen Tests', () {
    testWidgets('renders screen title and all category items correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VideoGuidanceScreen(),
        ),
      );

      // Verify header titles
      expect(find.text('Video Guidance'), findsOneWidget);
      expect(
        find.text('Yoga tutorials and natural health videos'),
        findsOneWidget,
      );

      // Verify category tabs exist
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Yoga & Meditation'), findsOneWidget);

      // Verify video content cards render
      expect(find.byType(VideoContentCard), findsWidgets);
    });

    testWidgets('filtering categories displays only matching videos',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VideoGuidanceScreen(),
        ),
      );

      // Click "Yoga & Meditation" category chip
      await tester.tap(find.text('Yoga & Meditation'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify tracks in yoga category exist
      expect(find.text('Surya Namaskar for Beginners'), findsOneWidget);
    });
  });
}
