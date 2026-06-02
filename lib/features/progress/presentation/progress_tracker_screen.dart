import 'package:flutter/material.dart';

class ProgressTrackerScreen extends StatelessWidget {
  const ProgressTrackerScreen({super.key, required this.languageName});

  final String languageName;

  @override
  Widget build(BuildContext context) {
    final copy = _ProgressCopy(languageName);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProgressHeader(copy: copy),
          const SizedBox(height: 14),
          _WeeklySummaryGrid(copy: copy),
          const SizedBox(height: 14),
          _PlaceholderLineChart(copy: copy),
          const SizedBox(height: 14),
          _DailyGoalsSection(copy: copy),
          const SizedBox(height: 14),
          _AchievementBadges(copy: copy),
          const SizedBox(height: 14),
          _HealthyHabitStreak(copy: copy),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.copy});

  final _ProgressCopy copy;

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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.show_chart, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  copy.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  copy.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySummaryGrid extends StatelessWidget {
  const _WeeklySummaryGrid({required this.copy});

  final _ProgressCopy copy;

  @override
  Widget build(BuildContext context) {
    final metrics = copy.metrics;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        mainAxisExtent: 168,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];

        return _MetricCard(metric: metric);
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _ProgressMetric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: metric.progress,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFE2E8E5),
                    color: metric.color,
                  ),
                  Icon(metric.icon, color: metric.color, size: 24),
                ],
              ),
            ),
            const Spacer(),
            Text(
              metric.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              metric.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF53645F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderLineChart extends StatelessWidget {
  const _PlaceholderLineChart({required this.copy});

  final _ProgressCopy copy;

  @override
  Widget build(BuildContext context) {
    final values = [48.0, 56.0, 52.0, 64.0, 70.0, 76.0, 82.0];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              copy.weeklyTrend,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < values.length; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${values[i].round()}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F766E).withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF0F766E), width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              weekdays[i],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF53645F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Wellness Score Trend over the last 7 days. Higher percentages indicate consistent daily routines (hydration, yoga sessions, and sleep timings).',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalsSection extends StatelessWidget {
  const _DailyGoalsSection({required this.copy});

  final _ProgressCopy copy;

  @override
  Widget build(BuildContext context) {
    final goals = copy.goals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: copy.dailyGoals),
        const SizedBox(height: 10),
        for (final goal in goals) _GoalProgressCard(goal: goal),
      ],
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  const _GoalProgressCard({required this.goal});

  final _GoalProgress goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(goal.icon, color: goal.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  goal.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: goal.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: goal.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: const Color(0xFFE2E8E5),
              color: goal.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBadges extends StatelessWidget {
  const _AchievementBadges({required this.copy});

  final _ProgressCopy copy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: copy.achievements),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: copy.badges
              .map(
                (badge) => Chip(
                  avatar: Icon(badge.icon, size: 18, color: badge.color),
                  label: Text(badge.title),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE2E8E5)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HealthyHabitStreak extends StatelessWidget {
  const _HealthyHabitStreak({required this.copy});

  final _ProgressCopy copy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFEA580C).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Color(0xFFEA580C),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.habitStreak,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    copy.streakMessage,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

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

class _ProgressCopy {
  const _ProgressCopy(this.languageName);

  final String languageName;

  bool get isKannada => languageName.toLowerCase() == 'kannada';

  String get title => 'Progress Tracker';
  String get subtitle => isKannada
      ? 'Kannada-ready wellness analytics using local dummy data.'
      : 'Weekly wellness analytics using local dummy data.';
  String get weeklyTrend => 'Weekly Wellness Trend';
  String get chartPlaceholder =>
      'Placeholder graph. Real charts will be added later.';
  String get dailyGoals => 'Daily Goal Progress';
  String get achievements => 'Achievement Badges';
  String get habitStreak => 'Healthy Habit Streak';
  String get streakMessage =>
      '4-day streak for water intake, yoga, and sleep routine.';

  List<_ProgressMetric> get metrics => const [
    _ProgressMetric(
      icon: Icons.favorite_outline,
      title: 'Wellness Score',
      value: '82 / 100',
      progress: 0.82,
      color: Color(0xFF0F766E),
    ),
    _ProgressMetric(
      icon: Icons.psychology_outlined,
      title: 'Stress Reduction',
      value: '64%',
      progress: 0.64,
      color: Color(0xFF7C3AED),
    ),
    _ProgressMetric(
      icon: Icons.bedtime_outlined,
      title: 'Sleep Quality',
      value: '7.2 hrs',
      progress: 0.72,
      color: Color(0xFF2563EB),
    ),
    _ProgressMetric(
      icon: Icons.self_improvement_outlined,
      title: 'Yoga Consistency',
      value: '5 days',
      progress: 0.71,
      color: Color(0xFF16A34A),
    ),
    _ProgressMetric(
      icon: Icons.water_drop_outlined,
      title: 'Water Intake',
      value: '2.4 L',
      progress: 0.80,
      color: Color(0xFF0891B2),
    ),
    _ProgressMetric(
      icon: Icons.mood_outlined,
      title: 'Mood Tracking',
      value: 'Calm',
      progress: 0.76,
      color: Color(0xFFEA580C),
    ),
  ];

  List<_GoalProgress> get goals => const [
    _GoalProgress(
      icon: Icons.water_drop_outlined,
      title: 'Drink 3 liters water',
      value: '80%',
      progress: 0.80,
      color: Color(0xFF0891B2),
    ),
    _GoalProgress(
      icon: Icons.self_improvement_outlined,
      title: 'Practice yoga',
      value: '60%',
      progress: 0.60,
      color: Color(0xFF16A34A),
    ),
    _GoalProgress(
      icon: Icons.bedtime_outlined,
      title: 'Sleep before 10:30 PM',
      value: '70%',
      progress: 0.70,
      color: Color(0xFF2563EB),
    ),
  ];

  List<_BadgeInfo> get badges => const [
    _BadgeInfo(
      icon: Icons.emoji_events_outlined,
      title: 'Yoga Starter',
      color: Color(0xFF16A34A),
    ),
    _BadgeInfo(
      icon: Icons.water_drop_outlined,
      title: 'Hydration Hero',
      color: Color(0xFF0891B2),
    ),
    _BadgeInfo(
      icon: Icons.nightlight_round,
      title: 'Sleep Focus',
      color: Color(0xFF2563EB),
    ),
  ];
}

class _ProgressMetric {
  const _ProgressMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final double progress;
  final Color color;
}

class _GoalProgress {
  const _GoalProgress({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final double progress;
  final Color color;
}

class _BadgeInfo {
  const _BadgeInfo({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;
}
