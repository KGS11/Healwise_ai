import '../domain/audio_content.dart';
import '../domain/video_content.dart';

class GuidanceContentData {
  static const List<AudioContent> audioContent = [
    AudioContent(
      id: 'mng_001',
      title: '5 Minute Morning Motivation',
      description:
          'Energize your mind and body with positive affirmations to begin your day.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      category: 'morning_energy',
      duration: '5:00',
      language: 'English',
      thumbnailEmoji: 'sparkle',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'mng_002',
      title: 'Wake-up Breathing Exercise',
      description:
          'Bellows breath (Bhastrika) to boost respiratory energy and mental clarity.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      category: 'morning_energy',
      duration: '3:00',
      language: 'English',
      thumbnailEmoji: 'breathing',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'aft_001',
      title: 'Concentration Breathing',
      description:
          'Box breathing technique (Sama Vritti) to enhance focus and cognitive function.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      category: 'afternoon_focus',
      duration: '4:00',
      language: 'English',
      thumbnailEmoji: 'air',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'aft_002',
      title: 'Mind Relaxation',
      description:
          'A quick, gentle mental pause to reset a busy mind during workday hours.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      category: 'afternoon_focus',
      duration: '6:00',
      language: 'English',
      thumbnailEmoji: 'sunset',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'str_001',
      title: 'Calm Breathing',
      description:
          'The 4-7-8 breathing exercise to immediately trigger the parasympathetic nervous system.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      category: 'stress_relief',
      duration: '5:00',
      language: 'English',
      thumbnailEmoji: 'calm',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'str_002',
      title: 'Anxiety Reduction Guidance',
      description:
          'Soothe physical panic sensations and lower your heart rate with grounding cues.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      category: 'stress_relief',
      duration: '8:00',
      language: 'English',
      thumbnailEmoji: 'meditation',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'ang_001',
      title: 'Deep Breathing Exercise',
      description:
          'Slow cooling breath (Sitali Pranayama) to pacify anger, frustration and stress.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      category: 'anger_control',
      duration: '4:00',
      language: 'English',
      thumbnailEmoji: 'rain',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'ang_002',
      title: 'Relaxation Guidance',
      description:
          'Sensory withdrawal (Pratyahara) instructions to quiet external anger triggers.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      category: 'anger_control',
      duration: '7:00',
      language: 'English',
      thumbnailEmoji: 'moon',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'slp_001',
      title: 'Bedtime Meditation',
      description:
          'Guided visualization and full body relaxation to drift off into deep sleep naturally.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      category: 'sleep',
      duration: '12:00',
      language: 'English',
      thumbnailEmoji: 'sleep',
      instructor: 'HealWise AI',
    ),
    AudioContent(
      id: 'slp_002',
      title: 'Sleep Relaxation Audio',
      description:
          'Calming ambient sleep tones and rhythmic frequencies to support sleep cycle transitions.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      category: 'sleep',
      duration: '15:00',
      language: 'English',
      thumbnailEmoji: 'moon',
      instructor: 'HealWise AI',
    ),
  ];

  static const List<VideoContent> videoContent = [
    VideoContent(
      id: 'yog_001',
      title: 'Surya Namaskar for Beginners',
      description:
          'A gentle, detailed step-by-step walkthrough of the 12 classic sun salutation poses.',
      youtubeVideoId: 'pHna_9AmJoU',
      category: 'yoga',
      duration: '15 min',
      language: 'English',
      thumbnailEmoji: 'sunrise',
      instructor: 'Yoga with Adriene',
    ),
    VideoContent(
      id: 'yog_002',
      title: 'Yoga for Stress Relief',
      description:
          'Slow, grounding floor postures to alleviate stress and lower nervous system tension.',
      youtubeVideoId: 'hJbRpHZr_d0',
      category: 'yoga',
      duration: '20 min',
      language: 'English',
      thumbnailEmoji: 'meditation',
      instructor: 'Yoga with Adriene',
    ),
    VideoContent(
      id: 'yog_003',
      title: 'Morning Yoga Routine',
      description:
          'Quick 10-minute full body stretch and breathing routine to start your day energized.',
      youtubeVideoId: 'BiWDsfZ3zbo',
      category: 'yoga',
      duration: '10 min',
      language: 'English',
      thumbnailEmoji: 'moon',
      instructor: 'Yoga with Adriene',
    ),
    VideoContent(
      id: 'yog_004',
      title: 'Back Pain Relief Yoga',
      description:
          'Targeted spinal releases, hamstring stretches, and postures to relieve lower back pain.',
      youtubeVideoId: 'YqDFv0rJNFQ',
      category: 'yoga',
      duration: '18 min',
      language: 'English',
      thumbnailEmoji: 'strength',
      instructor: 'Yoga with Adriene',
    ),
    VideoContent(
      id: 'yog_005',
      title: 'Meditation for Beginners',
      description:
          'Simple breathing techniques and optimal posture guides to start your meditation journey.',
      youtubeVideoId: 'O-6f5wQXSu8',
      category: 'yoga',
      duration: '10 min',
      language: 'English',
      thumbnailEmoji: 'calm',
      instructor: 'Headspace',
    ),
  ];

  static List<AudioContent> getAudioByCategory(String category) {
    if (category == 'all') {
      return audioContent;
    }
    return audioContent
        .where((content) => content.category == category)
        .toList();
  }

  static List<VideoContent> getVideoByCategory(String category) {
    if (category == 'all') {
      return videoContent;
    }
    return videoContent
        .where((content) => content.category == category)
        .toList();
  }
}
