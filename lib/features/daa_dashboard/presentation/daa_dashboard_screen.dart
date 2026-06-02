import 'package:flutter/material.dart';

class DaaDashboardScreen extends StatefulWidget {
  const DaaDashboardScreen({super.key});

  @override
  State<DaaDashboardScreen> createState() => _DaaDashboardScreenState();
}

class _DaaDashboardScreenState extends State<DaaDashboardScreen> {
  int? _activeTooltipIndex;

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
              'DAA Dashboard',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              'Design & Analysis of Algorithms in HealWise AI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Header Banner
              _buildHeaderSection(context),
              const SizedBox(height: 24),

              // Section 2: Comparison Bar Graph
              _buildSectionHeader(context, 'Algorithm Usage Across HealWise AI'),
              const SizedBox(height: 8),
              Text(
                'Relative weight of DAA computational paradigms implemented within the application. Tap any bar to view details.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildComparisonGraph(context),
              const SizedBox(height: 28),

              // Section 3: Clickable Algorithm Cards
              _buildSectionHeader(context, 'Clickable Algorithm Cards'),
              const SizedBox(height: 8),
              Text(
                'Select any algorithmic model to inspect its implementation parameters, mathematical complexity bounds, and module linkages.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildAlgorithmGrid(context),
              const SizedBox(height: 28),

              // Section 5: Algorithm vs Module Table
              _buildSectionHeader(context, 'Algorithm vs Module Alignment Matrix'),
              const SizedBox(height: 8),
              Text(
                'Comprehensive mapping cross-referencing active codebases, modules, and matching algorithmic classes.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildAlignmentTable(context),
              const SizedBox(height: 28),

              // Section 6: Project Flow Visualization
              _buildSectionHeader(context, 'Algorithmic Data Pipelines'),
              const SizedBox(height: 8),
              Text(
                'Logical transformation sequence of user parameters through successive processing steps.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF53645F),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _buildFlowVisualization(context),
              const SizedBox(height: 28),

              // Section 7: Presentation Note
              _buildPresentationNote(context),
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

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.08),
              primaryColor.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_tree_rounded, color: primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Algorithms Behind HealWise AI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Understanding the algorithms and DAA concepts powering OCR, Yoga Analysis, AI Recommendations, Firebase Operations, and Health Tracking.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF455A64),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonGraph(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final graphItems = [
      _GraphItem('Pattern Matching', 0.30, 'OCR Text Recognition Analysis'),
      _GraphItem('Classification', 0.25, 'Pose categorizing and deviation checks'),
      _GraphItem('Image Processing', 0.20, 'MediaPipe body landmarks & report scans'),
      _GraphItem('Searching', 0.15, 'Profile queries & database history retrievals'),
      _GraphItem('Sorting & Filtering', 0.07, 'Chronological health trend alignments'),
      _GraphItem('Greedy Ranking', 0.03, 'Best recommendation prioritization models'),
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
          children: [
            ...List.generate(graphItems.length, (index) {
              final item = graphItems[index];
              final isSelected = _activeTooltipIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_activeTooltipIndex == index) {
                        _activeTooltipIndex = null;
                      } else {
                        _activeTooltipIndex = index;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                              height: 12,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFECEFF1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: item.value,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor,
                                      primaryColor.withValues(alpha: 0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: Color(0xFF2563EB)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.tooltip,
                                    style: const TextStyle(
                                      color: Color(0xFF1E3A8A),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmGrid(BuildContext context) {
    final algorithms = _getAlgorithmsData();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: algorithms.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final algo = algorithms[index];
        return Card(
          key: ValueKey('daa_card_${algo.title}'),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE2E8E5)),
          ),
          child: InkWell(
            onTap: () => _showAlgorithmPopup(context, algo),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: algo.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(algo.icon, color: algo.color, size: 16),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          algo.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    algo.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7C8D88),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlignmentTable(BuildContext context) {
    final rows = [
      _AlignmentRow('OCR Analyzer', 'Pattern Matching\nImage Processing', const Color(0xFF2563EB)),
      _AlignmentRow('Yoga Assistant', 'Classification\nImage Processing', const Color(0xFF7C3AED)),
      _AlignmentRow('Progress Tracker', 'Sorting\nFiltering', const Color(0xFF16A34A)),
      _AlignmentRow('AI Assistant', 'Classification\nGreedy Ranking', const Color(0xFF0F766E)),
      _AlignmentRow('Firebase', 'Searching', const Color(0xFFEA580C)),
      _AlignmentRow('Medical Report Analysis', 'Pattern Matching', const Color(0xFFE11D48)),
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.8),
      },
      border: TableBorder.all(color: const Color(0xFFCFD8DC), width: 1, borderRadius: BorderRadius.circular(8)),
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFECEFF1)),
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Module Name',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF37474F)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Algorithmic Paradigms Implemented',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF37474F)),
              ),
            ),
          ],
        ),
        ...rows.map((row) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: row.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        row.module,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF263238)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  row.algorithms,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF546E7A),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildFlowVisualization(BuildContext context) {
    return Column(
      children: [
        _buildFlowCard(
          context,
          'Pipeline A: Medical Report Diagnostics',
          ['Medical Report', 'OCR Extraction', 'Pattern Matching', 'Classification', 'Health Result'],
          Colors.blue,
        ),
        const SizedBox(height: 14),
        _buildFlowCard(
          context,
          'Pipeline B: Yoga Posture Evaluation',
          ['Yoga Image Input', 'Image Processing', 'Classification Check', 'Pose Analysis Result'],
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildFlowCard(BuildContext context, String header, List<String> items, Color flowColor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: flowColor),
            ),
            const SizedBox(height: 14),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 10,
                children: List.generate(items.length, (index) {
                  final isLast = index == items.length - 1;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: flowColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: flowColor.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          items[index],
                          style: TextStyle(
                            color: flowColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF90A4AE)),
                      ],
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresentationNote(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_turned_in_rounded, color: primaryColor, size: 24),
                const SizedBox(width: 10),
                Text(
                  'DAA Concepts Used in HealWise AI',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCheckItem(context, 'Implemented in App Runtime:', [
              'Searching algorithms (Firebase data indexes)',
              'Pattern Matching (BP/sugar parameters matching)',
              'Classification algorithms (pose verification & thresholds)',
              'Sorting (chronological records list)',
              'Filtering (conditional history displays)',
              'Greedy Technique (priority recommendation sorting)',
              'Image Processing (MediaPipe joints extraction)',
            ], true),
            const SizedBox(height: 12),
            _buildCheckItem(context, 'Academic Syllabus Alignments:', [
              'Backtracking concepts (syllabus alignment, no active codebase use)',
              'Dynamic Programming (syllabus reference, no current optimization models)',
            ], false),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFCFD8DC)),
            const SizedBox(height: 8),
            const Text(
              'Academic Reference Note: Formulated and structured specifically for project viva evaluations, algorithmic demonstrations, and faculty inspections.',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String header, List<String> points, bool isImplemented) {
    final checkColor = isImplemented ? Theme.of(context).colorScheme.primary : const Color(0xFF78909C);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF263238)),
        ),
        const SizedBox(height: 6),
        ...points.map((pt) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded, color: checkColor, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pt,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF455A64),
                      fontWeight: FontWeight.w500,
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

  void _showAlgorithmPopup(BuildContext context, _AlgoData algo) {
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
                            color: algo.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(algo.icon, color: algo.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            algo.title,
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
                    _buildPopupSection(context, 'Used In:', algo.usedIn, primaryColor),
                    const SizedBox(height: 12),

                    // Purpose
                    _buildPopupSection(context, 'Purpose:', algo.purpose, primaryColor),
                    const SizedBox(height: 12),

                    // Code Usage
                    _buildPopupSection(context, 'Code Usage:', algo.codeUsage, primaryColor),
                    const SizedBox(height: 12),

                    // Related Module
                    _buildPopupSection(context, 'Related Modules / References:', algo.relatedModules, primaryColor),
                    const SizedBox(height: 20),

                    // Dismiss Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildPopupSection(BuildContext context, String header, List<String> items, Color bulletColor) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF37474F)),
        ),
        const SizedBox(height: 4),
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
                    decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle),
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

  List<_AlgoData> _getAlgorithmsData() {
    return [
      _AlgoData(
        title: 'Pattern Matching',
        icon: Icons.search_rounded,
        color: const Color(0xFF4F46E5),
        tagline: 'Keyword & text extraction scans.',
        usedIn: ['OCR Medical Report Analyzer'],
        purpose: [
          'Detect BP values',
          'Detect Sugar values',
          'Detect Cholesterol values',
          'Detect Hemoglobin values',
        ],
        codeUsage: [
          'Keyword matching',
          'Text extraction validation',
          'Complexity: O(n)',
        ],
        relatedModules: ['OCR Analyzer'],
      ),
      _AlgoData(
        title: 'Searching Algorithms',
        icon: Icons.find_in_page_rounded,
        color: const Color(0xFF0F766E),
        tagline: 'Database records lookup index.',
        usedIn: [
          'Firebase user lookup',
          'Health profile retrieval',
          'Report history retrieval',
        ],
        purpose: ['Find required records quickly'],
        codeUsage: [
          'Binary search on indexed keys',
          'Complexity: O(log n) to O(n)',
        ],
        relatedModules: ['Profile', 'Progress Tracker', 'Firebase Storage'],
      ),
      _AlgoData(
        title: 'Classification Algorithms',
        icon: Icons.category_rounded,
        color: const Color(0xFF7C3AED),
        tagline: 'Category grouping based on parameters.',
        usedIn: [
          'Yoga Assistant',
          'Health Status Analysis',
        ],
        purpose: [
          'Categorize results',
          'Examples: Normal, High, Low',
        ],
        codeUsage: [
          'Angle check bounds evaluation',
          'Blood report parameter boundary classification',
        ],
        relatedModules: ['Yoga Assistant', 'OCR Analyzer'],
      ),
      _AlgoData(
        title: 'Image Processing',
        icon: Icons.image_search_rounded,
        color: const Color(0xFFEC4899),
        tagline: 'Landmark detection & pixel matrix scans.',
        usedIn: [
          'OCR Scanner',
          'Yoga Pose Analysis',
        ],
        purpose: [
          'Extract image features',
          'Detect body landmarks',
          'Process medical reports',
        ],
        codeUsage: [
          'Pixel grid normalization',
          'Coordinate scaling of 2D joint markers',
        ],
        relatedModules: ['OCR', 'Yoga Assistant'],
      ),
      _AlgoData(
        title: 'Sorting Algorithms',
        icon: Icons.sort_rounded,
        color: const Color(0xFF16A34A),
        tagline: 'Chronological timeline order layouts.',
        usedIn: [
          'Progress Tracker',
          'History screens',
        ],
        purpose: [
          'Arrange records by date',
          'Arrange reports chronologically',
        ],
        codeUsage: [
          'Built-in TimSort (Dart List.sort)',
          'Complexity: O(n log n)',
        ],
        relatedModules: ['Progress Tracker'],
      ),
      _AlgoData(
        title: 'Filtering Algorithms',
        icon: Icons.filter_alt_rounded,
        color: const Color(0xFFD97706),
        tagline: 'Sub-array extraction from sets.',
        usedIn: [
          'Health records',
          'Report history',
        ],
        purpose: [
          'Display only required data',
          'Examples: Show only reports, Show only yoga history',
        ],
        codeUsage: [
          'Dart List.where predicate filters',
        ],
        relatedModules: ['Progress Tracker'],
      ),
      _AlgoData(
        title: 'Greedy Technique',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFFEA580C),
        tagline: 'Selecting optimal localized paths.',
        usedIn: [
          'Recommendation ranking',
          'Health suggestion prioritization',
        ],
        purpose: [
          'Select best recommendation first',
        ],
        codeUsage: [
          'Weighted ranking parameter models',
        ],
        relatedModules: ['AI Assistant', 'Health Suggestions'],
      ),
      _AlgoData(
        title: 'Brute Force Technique',
        icon: Icons.auto_awesome_motion_rounded,
        color: const Color(0xFFDC2626),
        tagline: 'Linear scan of all possibilities.',
        usedIn: [
          'OCR parameter matching',
        ],
        purpose: [
          'Scan all possible keywords',
          'Example: Checking all text entries to find BP or Sugar values',
        ],
        codeUsage: [
          'Nested loops comparing strings',
          'Complexity: O(n)',
        ],
        relatedModules: ['OCR Analyzer'],
      ),
      _AlgoData(
        title: 'Backtracking Technique',
        icon: Icons.undo_rounded,
        color: const Color(0xFF90A4AE),
        tagline: 'Recursive searching of solution spaces.',
        usedIn: [
          'Not directly implemented',
        ],
        purpose: [
          'Project requirements do not require recursive search solutions.',
        ],
        codeUsage: [
          'Academic Relevance: DAA syllabus concept.',
        ],
        relatedModules: ['Academic reference'],
      ),
      _AlgoData(
        title: 'Dynamic Programming',
        icon: Icons.grid_on_rounded,
        color: const Color(0xFF78909C),
        tagline: 'Overlapping subproblems & tables.',
        usedIn: [
          'Not directly implemented',
        ],
        purpose: [
          'No optimization problem currently requires DP.',
        ],
        codeUsage: [
          'Academic Relevance: DAA syllabus concept.',
        ],
        relatedModules: ['Academic reference'],
      ),
    ];
  }
}

class _GraphItem {
  const _GraphItem(this.label, this.value, this.tooltip);
  final String label;
  final double value;
  final String tooltip;
}

class _AlignmentRow {
  const _AlignmentRow(this.module, this.algorithms, this.color);
  final String module;
  final String algorithms;
  final Color color;
}

class _AlgoData {
  const _AlgoData({
    required this.title,
    required this.icon,
    required this.color,
    required this.tagline,
    required this.usedIn,
    required this.purpose,
    required this.codeUsage,
    required this.relatedModules,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String tagline;
  final List<String> usedIn;
  final List<String> purpose;
  final List<String> codeUsage;
  final List<String> relatedModules;
}
