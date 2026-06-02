import 'package:flutter/material.dart';

class GuidanceCategory {
  const GuidanceCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class CategoryTabBar extends StatelessWidget {
  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<GuidanceCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedCategory;

          return ChoiceChip(
            selected: selected,
            avatar: Icon(
              category.icon,
              size: 18,
              color: selected ? Colors.white : primaryColor,
            ),
            label: Text(category.label),
            labelStyle: TextStyle(
              color: selected ? Colors.white : const Color(0xFF12342F),
              fontWeight: FontWeight.w800,
            ),
            selectedColor: primaryColor,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected ? primaryColor : const Color(0xFFD8E2DD),
            ),
            onSelected: (_) => onSelected(category.id),
          );
        },
      ),
    );
  }
}
