class VideoContent {
  const VideoContent({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.category,
    required this.duration,
    required this.language,
    required this.thumbnailEmoji,
    required this.instructor,
  });

  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String category;
  final String duration;
  final String language;
  final String thumbnailEmoji;
  final String instructor;
}
