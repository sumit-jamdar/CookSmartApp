import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../widgets/language_selector_modal.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    final lang = provider.currentLanguage;
    final recipes = provider.filteredHomeRecipes;

    final categories = [
      {'key': 'All', 'label': AppStrings.get('all', lang)},
      {
        'key': 'महाराष्ट्रीयन खास',
        'label': AppStrings.get('maharashtrian', lang)
      },
      {'key': 'खमंग नाश्ता', 'label': AppStrings.get('breakfast', lang)},
      {'key': 'पारंपरिक जेवण', 'label': AppStrings.get('traditional', lang)},
      {'key': 'स्ट्रीट फूड', 'label': AppStrings.get('streetFood', lang)},
      {'key': 'उपवास स्पेशल', 'label': AppStrings.get('fasting', lang)},
      {'key': 'गोडधोड', 'label': AppStrings.get('sweets', lang)},
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white24, width: 1.5),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('welcomeBack', lang),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.onSurfaceVariant),
                            ),
                            Text(
                              AppStrings.get('goodEvening', lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Language Switch Button
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color:
                                      AppTheme.primary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.translate_rounded,
                                    color: AppTheme.primary, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.languageCodes[lang] ?? 'EN',
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 11,
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
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: AppTheme.primary, size: 18),
                          ),
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
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: TextField(
                    onChanged: provider.setHomeSearchQuery,
                    style: const TextStyle(
                        color: AppTheme.onSurface, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: AppStrings.get('searchHint', lang),
                      hintStyle: const TextStyle(
                          color: AppTheme.onSurfaceVariant, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppTheme.onSurfaceVariant, size: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune_rounded,
                            color: AppTheme.primary, size: 20),
                        onPressed: () {
                          if (onNavigateTab != null) {
                            onNavigateTab!(1);
                          } else {
                            Navigator.pushNamed(context, '/ingredient-input');
                          }
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),

            // "आज काय बनवायचं?" Daily Smart Assistant Quick Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                child: InkWell(
                  onTap: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(1);
                    } else {
                      Navigator.pushNamed(context, '/meal-planner');
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.2),
                          Colors.deepOrangeAccent.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.lightbulb_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.get('mealSuggestionTitle', lang),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'डिश रिपीट न करता आजचा परिपूर्ण मेनू ठरवा!',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: AppTheme.primary, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Featured Recipe of the Day Hero
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.get('recipeOfTheDay', lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                        Text(
                          AppStrings.get('editorsPick', lang),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        provider.setCurrentRecipe(provider.allRecipes.first);
                        Navigator.pushNamed(context, '/recipe-result');
                      },
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.borderSubtle),
                          image: DecorationImage(
                            image: NetworkImage(
                                provider.allRecipes.first.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.surface.withValues(alpha: 0.4),
                                    AppTheme.surface.withValues(alpha: 0.95),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.surface.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppTheme.tertiary, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      provider.allRecipes.first.rating,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          provider.allRecipes.first.time,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          provider.allRecipes.first.category,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    provider.allRecipes.first.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Chips Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('foodCategories', lang),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          final cat = categories[idx];
                          final key = cat['key']!;
                          final label = cat['label']!;
                          final isSelected = provider.homeCategoryFilter == key;

                          return ChoiceChip(
                            label: Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.onSurfaceVariant,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) =>
                                provider.setHomeCategoryFilter(key),
                            selectedColor: AppTheme.primary,
                            backgroundColor: AppTheme.surfaceCard,
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.borderSubtle,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            showCheckmark: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Trending Feed Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.get('trendingNow', lang),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 18),
                    ),
                    Text(
                      '${recipes.length} ${AppStrings.get('recipesCount', lang)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),

            // Trending Recipes List
            if (recipes.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      AppStrings.get('noRecipesFound', lang),
                      style: const TextStyle(color: AppTheme.onSurfaceVariant),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final recipe = recipes[idx];
                      final isSaved = provider.isSaved(recipe.id);

                      return GestureDetector(
                        onTap: () {
                          provider.setCurrentRecipe(recipe);
                          Navigator.pushNamed(context, '/recipe-result');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  recipe.imageUrl,
                                  width: 76,
                                  height: 76,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          recipe.category.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppTheme.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('•',
                                            style: TextStyle(
                                                color:
                                                    AppTheme.onSurfaceVariant)),
                                        const SizedBox(width: 6),
                                        Text(
                                          recipe.time,
                                          style: const TextStyle(
                                            color: AppTheme.onSurfaceVariant,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      recipe.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: AppTheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            color: AppTheme.tertiary, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          recipe.rating,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          recipe.calories,
                                          style: const TextStyle(
                                              color: AppTheme.onSurfaceVariant,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: isSaved
                                      ? AppTheme.primary
                                      : AppTheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  provider.toggleSave(recipe);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: AppTheme.surfaceCard,
                                      content: Text(
                                        isSaved
                                            ? AppStrings.get(
                                                'removedFromSaved', lang)
                                            : AppStrings.get(
                                                'savedToCookbook', lang),
                                        style: TextStyle(
                                          color: isSaved
                                              ? Colors.white
                                              : AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: recipes.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
