import 'package:flutter/material.dart';

import '../../chatbot/presentation/ai_chatbot_screen.dart';
import '../../reports/presentation/medical_report_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
    required this.languageName,
    this.userName = 'Wellness Friend',
  });

  final String languageName;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final copy = _DashboardCopy(languageName);
    final features = copy.features;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _WelcomeHeader(
            userName: userName,
            title: copy.welcomeTitle,
            subtitle: copy.welcomeSubtitle,
          ),
          const SizedBox(height: 14),
          _WellnessScoreCard(
            title: copy.wellnessScore,
            message: copy.scoreMessage,
            score: 82,
          ),
          const SizedBox(height: 14),
          _DailyQuoteCard(title: copy.dailyQuote, quote: copy.quote),
          const SizedBox(height: 22),
          _SectionHeader(title: copy.dashboard),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 210,
              mainAxisExtent: 168,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];

              return _DashboardFeatureCard(
                feature: feature,
                onTap: () => feature.opensChatbot
                    ? _openChatbot(context)
                    : feature.opensReports
                    ? _openReports(context)
                    : _showComingSoon(context, feature.title),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, [String? title]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${title ?? 'This section'} coming soon.')),
    );
  }

  void _openChatbot(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AiChatbotScreen(languageName: languageName, showAppBar: true),
      ),
    );
  }

  void _openReports(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MedicalReportScreen(languageName: languageName),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({
    required this.userName,
    required this.title,
    required this.subtitle,
  });

  final String userName;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.health_and_safety_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _WellnessScoreCard extends StatelessWidget {
  const _WellnessScoreCard({
    required this.title,
    required this.message,
    required this.score,
  });

  final String title;
  final String message;
  final int score;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 74,
              height: 74,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFE2E8E5),
                    color: colorScheme.primary,
                  ),
                  Center(
                    child: Text(
                      '$score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyQuoteCard extends StatelessWidget {
  const _DailyQuoteCard({required this.title, required this.quote});

  final String title;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote, color: Color(0xFF2563EB)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    quote,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF53645F),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class _DashboardFeatureCard extends StatelessWidget {
  const _DashboardFeatureCard({required this.feature, required this.onTap});

  final _FeatureInfo feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(feature.icon, color: feature.color),
              ),
              const Spacer(),
              Text(
                feature.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      feature.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF647067),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCopy {
  const _DashboardCopy(this.languageName);

  final String languageName;

  bool get isKannada => languageName.toLowerCase() == 'kannada';

  String get welcomeTitle => isKannada ? 'ಮತ್ತೆ ಸ್ವಾಗತ' : 'Welcome back';
  String get welcomeSubtitle => isKannada
      ? 'ಇಂದು ನಿಮ್ಮ ಆರೋಗ್ಯ ಗುರಿಗಳನ್ನು ಶಾಂತವಾಗಿ ಮುಂದುವರಿಸಿ.'
      : 'Keep your wellness routine calm, steady, and natural today.';
  String get wellnessScore => isKannada ? 'ಆರೋಗ್ಯ ಅಂಕ' : 'Wellness score';
  String get scoreMessage => isKannada
      ? 'ನಿದ್ರೆ, ನೀರು, ಯೋಗ ಮತ್ತು ಒತ್ತಡ ಅಭ್ಯಾಸಗಳ ಆಧಾರದ ಮೇಲೆ.'
      : 'Based on sleep, hydration, yoga, and stress habits.';
  String get dailyQuote =>
      isKannada ? 'ದೈನಂದಿನ ಆರೋಗ್ಯ ಚಿಂತನೆ' : 'Daily health quote';
  String get quote => isKannada
      ? 'ಸಣ್ಣ ಆರೋಗ್ಯಕರ ಅಭ್ಯಾಸಗಳು ದೀರ್ಘಕಾಲದ ಉತ್ತಮ ಜೀವನವನ್ನು ರೂಪಿಸುತ್ತವೆ.'
      : 'Small healthy habits practiced daily create long-term wellbeing.';
  String get dashboard => isKannada ? 'ಡ್ಯಾಶ್ಬೋರ್ಡ್' : 'Dashboard';

  List<_FeatureInfo> get features => [
    _FeatureInfo(
      icon: Icons.chat_bubble_outline,
      title: isKannada ? 'AI ಚಾಟ್‌ಬಾಟ್' : 'AI Chatbot',
      subtitle: isKannada ? 'ಲಕ್ಷಣಗಳ ಸಹಾಯ' : 'Symptom guidance',
      color: const Color(0xFF0F766E),
      opensChatbot: true,
    ),
    _FeatureInfo(
      icon: Icons.upload_file_outlined,
      title: isKannada ? 'ರಿಪೋರ್ಟ್ ಅಪ್ಲೋಡ್' : 'Upload Medical Report',
      subtitle: isKannada ? 'OCR ವಿಶ್ಲೇಷಣೆ' : 'OCR analysis',
      color: const Color(0xFF2563EB),
      opensReports: true,
    ),
    _FeatureInfo(
      icon: Icons.self_improvement_outlined,
      title: isKannada ? 'ಯೋಗ ಸಹಾಯಕ' : 'Yoga Assistant',
      subtitle: isKannada ? 'ಪೋಸ್ ಮಾರ್ಗದರ್ಶನ' : 'Pose guidance',
      color: const Color(0xFF7C3AED),
    ),
    _FeatureInfo(
      icon: Icons.headphones_outlined,
      title: isKannada ? 'ಆಡಿಯೋ ಮಾರ್ಗದರ್ಶನ' : 'Audio Guidance',
      subtitle: isKannada ? 'ಧ್ಯಾನ ಮತ್ತು ನಿದ್ರೆ' : 'Meditation audio',
      color: const Color(0xFF0891B2),
    ),
    _FeatureInfo(
      icon: Icons.ondemand_video_outlined,
      title: isKannada ? 'ವೀಡಿಯೋ ಮಾರ್ಗದರ್ಶನ' : 'Video Guidance',
      subtitle: isKannada ? 'ಯೋಗ ಟ್ಯುಟೋರಿಯಲ್' : 'Yoga tutorials',
      color: const Color(0xFFEA580C),
    ),
    _FeatureInfo(
      icon: Icons.local_hospital_outlined,
      title: isKannada ? 'ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆಗಳು' : 'Nearby Hospitals',
      subtitle: isKannada ? 'ನಕ್ಷೆ ಮತ್ತು ಸಂಪರ್ಕ' : 'Maps and contacts',
      color: const Color(0xFFDC2626),
    ),
    _FeatureInfo(
      icon: Icons.show_chart,
      title: isKannada ? 'ಪ್ರಗತಿ ಟ್ರ್ಯಾಕರ್' : 'Progress Tracker',
      subtitle: isKannada ? 'ಆರೋಗ್ಯ ಟ್ರೆಂಡ್‌ಗಳು' : 'Health trends',
      color: const Color(0xFF16A34A),
    ),
    _FeatureInfo(
      icon: Icons.functions,
      title: isKannada ? 'ಗಣಿತ ಡ್ಯಾಶ್ಬೋರ್ಡ್' : 'Mathematical Dashboard',
      subtitle: isKannada ? 'ಅಂಕಿಅಂಶ ಗ್ರಾಫ್‌ಗಳು' : 'Statistics graphs',
      color: const Color(0xFF4F46E5),
    ),
    _FeatureInfo(
      icon: Icons.account_tree_outlined,
      title: isKannada ? 'DAA ಡ್ಯಾಶ್ಬೋರ್ಡ್' : 'DAA Dashboard',
      subtitle: isKannada ? 'ಅಲ್ಗೋರಿದಮ್ ದೃಶ್ಯಗಳು' : 'Algorithm visuals',
      color: const Color(0xFFBE123C),
    ),
  ];
}

class _FeatureInfo {
  const _FeatureInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.opensChatbot = false,
    this.opensReports = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool opensChatbot;
  final bool opensReports;
}
