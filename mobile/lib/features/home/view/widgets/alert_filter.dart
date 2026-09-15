import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class AlertFilter extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const AlertFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final List<String> filters = const ['All', 'Critical', 'Warning', 'Resolved'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: filters.map((filter) {
        final bool isSelected = selectedFilter == filter;

        return GestureDetector(
          onTap: () {
            onChanged(filter);
          },
          child: Container(
            height: 42,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : Colors.transparent,
              border: Border.all(color: AppTheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                filter,
                style: TextTheme.of(context).titleMedium!.copyWith(
                  color: isSelected ? AppTheme.cream : AppTheme.primary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
