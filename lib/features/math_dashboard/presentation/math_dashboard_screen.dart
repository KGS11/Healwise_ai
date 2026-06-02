import 'package:flutter/material.dart';

class MathDashboardScreen extends StatelessWidget {
  const MathDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mathematical Dashboard',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              'Academic & algorithmic foundations of HealWise AI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Academic Banner
              _buildAcademicBanner(context),
              const SizedBox(height: 24),

              // Section 1: Mathematics Behind HealWise AI
              _buildSectionHeader(context, 'Mathematics Behind HealWise AI'),
              const SizedBox(height: 8),
              Text(
                'Explore the fundamental mathematical disciplines driving our intelligent modules. Tap any card below to review concrete code implementations and logical components.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),

              // 2x3 Grid of Interactive Mathematical Cards
              _buildConceptGrid(context),
              const SizedBox(height: 28),

              // Section: Usage Chart
              _buildSectionHeader(context, 'Core Concept Utilization Index'),
              const SizedBox(height: 8),
              Text(
                'Estimated mathematical concept footprint and weight across active software routines, repositories, and models.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildUsageChart(context),
              const SizedBox(height: 28),

              // Section 2: Where Mathematics Appears in HealWise
              _buildSectionHeader(context, 'Where Mathematics Appears in HealWise'),
              const SizedBox(height: 8),
              Text(
                'High-level mapping demonstrating the integration of theoretical topics into functional application layers.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildModuleMappingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicBanner(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.08),
            primaryColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Viva Presentation',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Perfect reference detailing algorithms, formulas, and structural math applications within HealWise AI.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF53645F),
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

  Widget _buildConceptGrid(BuildContext context) {
    final concepts = _getConceptsData();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: concepts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final concept = concepts[index];
        return _ConceptCard(
          key: ValueKey('concept_card_${concept.title}'),
          concept: concept,
          onTap: () => _showConceptPopup(context, concept),
        );
      },
    );
  }

  Widget _buildUsageChart(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final chartData = [
      _ChartItem('Coordinate Geometry', 0.90, Icons.grid_3x3_rounded, 'MediaPipe landmark mappings'),
      _ChartItem('Probability', 0.85, Icons.bubble_chart_rounded, 'OCR & pose confidence metrics'),
      _ChartItem('Statistics', 0.75, Icons.analytics_rounded, 'Weekly progress progress aggregation'),
      _ChartItem('Trigonometry', 0.65, Icons.architecture_rounded, 'Joint angle verification ratios'),
      _ChartItem('Coding Theory', 0.45, Icons.font_download_rounded, 'Error correction & text recognition'),
      _ChartItem('Group Theory', 0.10, Icons.blur_on_rounded, 'Neural weight space symmetries'),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: chartData.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(item.icon, size: 16, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '${(item.value * 100).toInt()}%',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECEFF1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: item.value,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.desc,
                    style: const TextStyle(
                      color: Color(0xFF7C8D88),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildModuleMappingSection(BuildContext context) {
    final mappings = [
      _MappingData(
        module: 'OCR Analyzer',
        maths: ['Probability'],
        icon: Icons.upload_file_outlined,
        color: const Color(0xFF2563EB),
      ),
      _MappingData(
        module: 'Yoga Assistant',
        maths: ['Geometry', 'Trigonometry'],
        icon: Icons.self_improvement_outlined,
        color: const Color(0xFF7C3AED),
      ),
      _MappingData(
        module: 'Progress Tracker',
        maths: ['Statistics'],
        icon: Icons.show_chart,
        color: const Color(0xFF16A34A),
      ),
      _MappingData(
        module: 'AI Assistant',
        maths: ['Probability', 'Statistics'],
        icon: Icons.chat_bubble_outline,
        color: const Color(0xFF0F766E),
      ),
    ];

    return Column(
      children: mappings.map((map) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE2E8E5)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Module icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: map.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(map.icon, color: map.color, size: 20),
                ),
                const SizedBox(width: 14),
                // Module name
                Expanded(
                  child: Text(
                    map.module,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ),
                // Arrow
                const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF90A4AE)),
                const SizedBox(width: 8),
                // Math concepts mapped
                Wrap(
                  spacing: 4,
                  children: map.maths.map((math) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        math,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showConceptPopup(BuildContext context, _ConceptData concept) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Bar
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: concept.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(concept.icon, color: concept.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            concept.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1, color: Color(0xFFECEFF1)),

                    // Used In
                    _buildPopupSection(
                      context,
                      'Used In:',
                      concept.usedIn,
                      primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // Code Usage
                    _buildPopupSection(
                      context,
                      'Code Usage:',
                      concept.codeUsage,
                      primaryColor,
                    ),
                    const SizedBox(height: 16),

                    // Related Module
                    _buildPopupSection(
                      context,
                      'Related Module:',
                      concept.relatedModule,
                      primaryColor,
                    ),
                    const SizedBox(height: 20),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Dismiss Plan',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupSection(
    BuildContext context,
    String header,
    List<String> items,
    Color bulletColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            color: Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 6),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF546E7A),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<_ConceptData> _getConceptsData() {
    return [
      _ConceptData(
        title: 'Probability',
        icon: Icons.bubble_chart_outlined,
        color: const Color(0xFF4F46E5),
        description: 'Confidence scores and prediction models.',
        usedIn: [
          'OCR confidence score',
          'Yoga pose confidence score',
          'AI prediction confidence',
        ],
        codeUsage: [
          'Confidence calculations',
          'Result scoring',
        ],
        relatedModule: [
          'OCR Analyzer',
          'Yoga Assistant',
        ],
      ),
      _ConceptData(
        title: 'Statistics',
        icon: Icons.analytics_outlined,
        color: const Color(0xFF16A34A),
        description: 'Tracking weekly averages and trends.',
        usedIn: [
          'Health Progress Tracker',
          'Average calculations',
          'Trend analysis',
        ],
        codeUsage: [
          'Weekly aggregation formulas',
          'Standard deviation & variance of scores',
        ],
        relatedModule: [
          'Progress Tracker',
        ],
      ),
      _ConceptData(
        title: 'Coordinate Geometry',
        icon: Icons.grid_3x3_outlined,
        color: const Color(0xFFD97706),
        description: 'Spatial landmarks and Cartesian plots.',
        usedIn: [
          'MediaPipe landmarks',
          'Joint coordinates',
          'Pose detection',
        ],
        codeUsage: [
          '2D plane pixel location plotting',
          'Coordinate scaling & bounding boxes',
        ],
        relatedModule: [
          'Yoga Assistant',
        ],
      ),
      _ConceptData(
        title: 'Trigonometry',
        icon: Icons.architecture_outlined,
        color: const Color(0xFFEA580C),
        description: 'Joint angles & spatial orientations.',
        usedIn: [
          'Angle calculations',
          'Yoga posture verification',
        ],
        codeUsage: [
          'Cosine distance & dot products',
          'Angle derivation from 3 sequential vertices',
        ],
        relatedModule: [
          'Yoga Assistant',
        ],
      ),
      _ConceptData(
        title: 'Coding Theory',
        icon: Icons.font_download_outlined,
        color: const Color(0xFF2563EB),
        description: 'Error detection & string matching.',
        usedIn: [
          'OCR text recognition',
          'Error correction concepts',
        ],
        codeUsage: [
          'Levenstein edit distance',
          'String alignment & fuzzy matching indexes',
        ],
        relatedModule: [
          'OCR Analyzer',
        ],
      ),
      _ConceptData(
        title: 'Group Theory',
        icon: Icons.blur_on_outlined,
        color: const Color(0xFF9333EA),
        description: 'Theoretical weight space patterns.',
        usedIn: [
          'Academic syllabus reference',
          'Not directly implemented',
        ],
        codeUsage: [
          'Symmetry in pose classification parameters',
          'Mathematical abstraction models',
        ],
        relatedModule: [
          'OCR Analyzer',
          'Yoga Assistant',
        ],
      ),
    ];
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({super.key, required this.concept, required this.onTap});

  final _ConceptData concept;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8E5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: concept.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(concept.icon, color: concept.color, size: 20),
              ),
              const Spacer(),
              Text(
                concept.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  concept.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7C8D88),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConceptData {
  const _ConceptData({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.usedIn,
    required this.codeUsage,
    required this.relatedModule,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> usedIn;
  final List<String> codeUsage;
  final List<String> relatedModule;
}

class _ChartItem {
  const _ChartItem(this.label, this.value, this.icon, this.desc);

  final String label;
  final double value;
  final IconData icon;
  final String desc;
}

class _MappingData {
  const _MappingData({
    required this.module,
    required this.maths,
    required this.icon,
    required this.color,
  });

  final String module;
  final List<String> maths;
  final IconData icon;
  final Color color;
}
