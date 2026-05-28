import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/language/presentation/language_selection_screen.dart';

class HealWiseApp extends StatelessWidget {
  const HealWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealWise AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LanguageSelectionScreen(),
    );
  }
}
