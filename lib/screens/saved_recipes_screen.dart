import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../widgets/language_selector_modal.dart';

class SavedRecipesScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const SavedRecipesScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    final lang = provider.currentLanguage;
    final saved = provider.filteredSavedRecipes;

    final categories = [
      {'key': 'All', 'label': AppStrings.get('all', lang)},
      {'key': 'Quick Meals', 'label': AppStrings.get('quickMeals', lang)},
      {'key': 'High Protein', 'label': AppStrings.get('highProtein', lang)},
      {'key': 'Italian', 'label': AppStrings.get('italian', lang)},
      {'key': 'Vegetarian', 'label': AppStrings.get('vegetarian', lang)},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (onNavigateTab != null) {
              onNavigateTab!(0);
            }
          },
        ),
        title: Column(
          children: [
            Text(
              AppStrings.get('mySavedRecipes', lang),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${provider.savedRecipes.length} ${AppStrings.get('recipesSaved', lang)}',
              style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          // Language Switch Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: AppTheme.primary, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.languageCodes[lang] ?? 'EN',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => const LanguageSelectorModal(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppTheme.primary),
            onPressed: () {
              if (onNavigateTab != null) {
                onNavigateTab!(1);
              } else {
                Navigator.pushNamed(context, '/ingredient-input');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: TextField(
                    onChanged: provider.setSavedSearchQuery,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: AppStrings.get('filterSavedHint', lang),
                      hintStyle: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.onSurfaceVariant, size: 18),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),

            // Category Filter Pills
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = categories[idx];
                      final key = cat['key']!;
                      final label = cat['label']!;
                      final isSelected = provider.savedCategoryFilter == key;

                      return ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => provider.setSavedCategoryFilter(key),
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.surfaceCard,
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 2-Column Saved Grid or Empty State
            if (saved.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: const Icon(Icons.bookmark_border_rounded, size: 32, color: AppTheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.get('noSavedYet', lang),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.get('noSavedDesc', lang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppTheme.borderSubtle),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              if (onNavigateTab != null) {
                                onNavigateTab!(0);
                              } else {
                                Navigator.pushNamed(context, '/');
                              }
                            },
                            child: Text(AppStrings.get('exploreFeed', lang), style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              if (onNavigateTab != null) {
                                onNavigateTab!(1);
                              } else {
                                Navigator.pushNamed(context, '/ingredient-input');
                              }
                            },
                            child: Text(AppStrings.get('pantryGen', lang), style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final recipe = saved[idx];

                      return GestureDetector(
                        onTap: () {
                          provider.setCurrentRecipe(recipe);
                          Navigator.pushNamed(context, '/recipe-result');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      recipe.imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        provider.toggleSave(recipe);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(seconds: 1),
                                            backgroundColor: AppTheme.surfaceCard,
                                            content: Text(
                                              AppStrings.get('removedFromSaved', lang),
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.bookmark_rounded,
                                          size: 16,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.65),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        recipe.time,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        recipe.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            recipe.calories,
                                            style: const TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: AppTheme.tertiary, size: 13),
                                              const SizedBox(width: 2),
                                              Text(
                                                recipe.rating,
                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: saved.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
