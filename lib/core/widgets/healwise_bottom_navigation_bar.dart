import 'package:flutter/material.dart';

class HealWiseBottomNavigationBar extends StatelessWidget {
  const HealWiseBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: const Color(0xFF647067),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'AI Chatbot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          activeIcon: Icon(Icons.show_chart),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
