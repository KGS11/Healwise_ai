import 'package:flutter/material.dart';

import '../data/guidance_content_data.dart';
import 'widgets/category_tab_bar.dart';
import 'widgets/video_content_card.dart';
import 'widgets/video_player_screen.dart';

class VideoGuidanceScreen extends StatefulWidget {
  const VideoGuidanceScreen({super.key});

  @override
  State<VideoGuidanceScreen> createState() => _VideoGuidanceScreenState();
}

class _VideoGuidanceScreenState extends State<VideoGuidanceScreen> {
  String _selectedCategory = 'all';

  static const _categories = [
    GuidanceCategory(id: 'all', label: 'All', icon: Icons.apps_rounded),
    GuidanceCategory(
      id: 'yoga',
      label: 'Yoga & Meditation',
      icon: Icons.self_improvement_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final videoList = GuidanceContentData.getVideoByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Guidance',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              'Yoga tutorials and natural health videos',
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
            child: videoList.isEmpty
                ? const Center(
                    child: Text(
                      'No videos available in this category.',
                      style: TextStyle(color: Color(0xFF53645F)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 18),
                    itemCount: videoList.length,
                    itemBuilder: (context, index) {
                      final video = videoList[index];
                      return VideoContentCard(
                        video: video,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerScreen(video: video),
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
