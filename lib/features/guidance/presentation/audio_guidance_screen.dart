import 'package:flutter/material.dart';

import '../data/guidance_content_data.dart';
import 'widgets/audio_content_card.dart';
import 'widgets/audio_player_screen.dart';
import 'widgets/category_tab_bar.dart';

class AudioGuidanceScreen extends StatefulWidget {
  const AudioGuidanceScreen({super.key});

  @override
  State<AudioGuidanceScreen> createState() => _AudioGuidanceScreenState();
}

class _AudioGuidanceScreenState extends State<AudioGuidanceScreen> {
  String _selectedCategory = 'all';

  static const _categories = [
    GuidanceCategory(id: 'all', label: 'All', icon: Icons.apps_rounded),
    GuidanceCategory(
      id: 'morning_energy',
      label: 'Morning Energy',
      icon: Icons.wb_sunny_rounded,
    ),
    GuidanceCategory(
      id: 'afternoon_focus',
      label: 'Afternoon Focus',
      icon: Icons.center_focus_strong_rounded,
    ),
    GuidanceCategory(
      id: 'stress_relief',
      label: 'Stress Relief',
      icon: Icons.self_improvement_rounded,
    ),
    GuidanceCategory(
      id: 'anger_control',
      label: 'Anger Control',
      icon: Icons.air_rounded,
    ),
    GuidanceCategory(
      id: 'sleep',
      label: 'Sleep',
      icon: Icons.bedtime_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final audioList = GuidanceContentData.getAudioByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audio Guidance',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              'Healing sounds and guided meditations',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),
          CategoryTabBar(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: audioList.isEmpty
                ? const Center(
                    child: Text(
                      'No tracks available in this category.',
                      style: TextStyle(color: Color(0xFF53645F)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 18),
                    itemCount: audioList.length,
                    itemBuilder: (context, index) {
                      final audio = audioList[index];
                      return AudioContentCard(
                        audio: audio,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AudioPlayerScreen(audio: audio),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
