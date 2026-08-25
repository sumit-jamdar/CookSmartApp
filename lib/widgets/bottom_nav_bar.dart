import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';

class CookSmartBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CookSmartBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<RecipeProvider>(context).currentLanguage;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.95),
        border: const Border(
          top: BorderSide(color: AppTheme.borderSubtle, width: 1),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    icon: Icons.home_rounded,
                    label: AppStrings.get('home', lang),
                    isActive: currentIndex == 0,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    icon: Icons.lightbulb_rounded,
                    label: AppStrings.get('mealPlanner', lang),
                    isActive: currentIndex == 1,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    icon: Icons.auto_awesome_rounded,
                    label: AppStrings.get('generator', lang),
                    isActive: currentIndex == 2,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    icon: Icons.bookmark_rounded,
                    label: AppStrings.get('saved', lang),
                    isActive: currentIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
