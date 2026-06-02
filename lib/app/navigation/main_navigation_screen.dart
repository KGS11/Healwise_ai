import 'package:flutter/material.dart';

import '../../core/widgets/healwise_bottom_navigation_bar.dart';
import '../../features/chatbot/presentation/chatbot_screen.dart';
import '../../features/home/presentation/home_dashboard_screen.dart';
import '../../features/progress/presentation/progress_tracker_screen.dart';
import '../../features/auth/presentation/profile_placeholder_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.languageName,
    required this.userName,
  });

  final String languageName;
  final String userName;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeDashboardScreen(
        languageName: widget.languageName,
        userName: widget.userName,
      ),
      ChatbotScreen(languageName: widget.languageName),
      ProgressTrackerScreen(languageName: widget.languageName),
      ProfilePlaceholderScreen(
        userName: widget.userName,
        languageName: widget.languageName,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealWise AI'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                widget.languageName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: IndexedStack(
          key: ValueKey(_currentIndex),
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: HealWiseBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
