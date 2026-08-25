import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../widgets/language_selector_modal.dart';

class MealPlannerScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const MealPlannerScreen({super.key, this.onNavigateTab});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _customVeggieController = TextEditingController();
  final TextEditingController _yesterdayController = TextEditingController();

  final List<Map<String, String>> _quickVeggies = const [
    {'name': 'बटाटा (Potato)', 'icon': '🥔'},
    {'name': 'मेथी (Methi)', 'icon': '🥬'},
    {'name': 'पालक (Palak)', 'icon': '🍃'},
    {'name': 'भेंडी (Bhendi)', 'icon': '🌱'},
    {'name': 'पनीर (Paneer)', 'icon': '🧀'},
    {'name': 'फ्लॉवर-मटार (Cauliflower)', 'icon': '🥦'},
    {'name': 'वांगी (Brinjal)', 'icon': '🍆'},
    {'name': 'गवार (Cluster Beans)', 'icon': '🌿'},
    {'name': 'दुधी भोपळा (Bottle Gourd)', 'icon': '🥒'},
    {'name': 'कडधान्य / मटकी (Sprouts)', 'icon': '🌾'},
    {'name': 'कांदा-टोमॅटो (Pantry)', 'icon': '🧅'},
  ];

  final List<String> _yesterdayOptions = const [
    'बटाटा भाजी',
    'पनीर भुर्जी',
    'मटकी उसळ',
    'डाळ-भात',
    'भरली वांगी',
    'शेव भाजी',
    'खिचडी-कढी',
  ];

  final List<Map<String, String>> _popularExtraVeggies = const [
    {'name': 'कारले (Bitter Gourd)', 'icon': '🌰'},
    {'name': 'शेवग्याच्या शेंगा (Drumsticks)', 'icon': '🌿'},
    {'name': 'पडवळ (Snake Gourd)', 'icon': '🥒'},
    {'name': 'तोंडली (Tindora)', 'icon': '🥒'},
    {'name': 'दोडका / शिराळे (Ridge Gourd)', 'icon': '🥒'},
    {'name': 'कोबी (Cabbage)', 'icon': '🥬'},
    {'name': 'शिमला मिरची (Capsicum)', 'icon': '🫑'},
    {'name': 'चवळीच्या शेंगा (Cowpeas)', 'icon': '🌱'},
    {'name': 'अळूची पाने (Colocasia)', 'icon': '🥗'},
    {'name': 'लाल भोपळा (Pumpkin)', 'icon': '🎃'},
    {'name': 'रताळे (Sweet Potato)', 'icon': '🥔'},
    {'name': 'मशरूम (Mushroom)', 'icon': '🍄'},
    {'name': 'ब्रोकोली (Broccoli)', 'icon': '🥦'},
  ];

  void _showAddVeggieModal(
      BuildContext context, RecipeProvider provider, String lang) {
    _customVeggieController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        color: AppTheme.primary, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'नवीन भाजी जोडा (Add Vegetable)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppTheme.onSurfaceVariant),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'घरात असलेली कोणतीही भाजी टाइप करा किंवा खालील पर्यायांवर टॅप करा:',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customVeggieController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'उदा. शेवगा, कारले, पडवळ, तोंडली...',
                      hintStyle: const TextStyle(
                          color: AppTheme.onSurfaceVariant, fontSize: 13),
                      filled: true,
                      fillColor: AppTheme.surfaceHigh,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        provider.addCustomPlannerVeggie(val.trim());
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    final text = _customVeggieController.text.trim();
                    if (text.isNotEmpty) {
                      provider.addCustomPlannerVeggie(text);
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('जोडा +',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'इतर लोकप्रिय भाज्या (Quick Pick):',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _popularExtraVeggies.map((veg) {
                    final isAlreadyAdded =
                        provider.plannerVeggies.contains(veg['name']);
                    return ActionChip(
                      avatar: Text(veg['icon']!,
                          style: const TextStyle(fontSize: 14)),
                      label: Text(veg['name']!),
                      backgroundColor: isAlreadyAdded
                          ? AppTheme.primary.withValues(alpha: 0.2)
                          : AppTheme.surfaceHigh,
                      side: BorderSide(
                        color: isAlreadyAdded
                            ? AppTheme.primary
                            : AppTheme.borderSubtle,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color:
                            isAlreadyAdded ? AppTheme.primary : Colors.white70,
                        fontWeight: isAlreadyAdded
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onPressed: () {
                        provider.addCustomPlannerVeggie(veg['name']!);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customVeggieController.dispose();
    _yesterdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    final lang = provider.currentLanguage;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.tertiary],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.lightbulb_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('mealSuggestionTitle', lang),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Smart Vegetable & Meal Assistant',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.translate_rounded,
                                color: AppTheme.primary, size: 14),
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.onSurfaceVariant,
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: AppStrings.get('dailySuggestionTab', lang)),
                      Tab(text: AppStrings.get('weeklyPlannerTab', lang)),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDailySuggestionView(context, provider, lang),
              _buildWeeklyPlannerView(context, provider, lang),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailySuggestionView(
      BuildContext context, RecipeProvider provider, String lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle Info Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_alt_rounded,
                    color: AppTheme.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.get('mealSuggestionSubtitle', lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Meal Time Selector
          Text(
            AppStrings.get('mealTime', lang),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMealTimeChip(
                  'Breakfast', AppStrings.get('breakfastOpt', lang), provider),
              const SizedBox(width: 8),
              _buildMealTimeChip(
                  'Lunch', AppStrings.get('lunchOpt', lang), provider),
              const SizedBox(width: 8),
              _buildMealTimeChip(
                  'Dinner', AppStrings.get('dinnerOpt', lang), provider),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Available Vegetables Chips
          Text(
            AppStrings.get('availableVeggies', lang),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._quickVeggies.map((veg) {
                final isSelected =
                    provider.plannerVeggies.contains(veg['name']);
                return FilterChip(
                  label: Text('${veg['icon']} ${veg['name']}'),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceCard,
                  side: BorderSide(
                    color:
                        isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                  ),
                  onSelected: (_) => provider.togglePlannerVeggie(veg['name']!),
                );
              }),
              // Custom User-Added Veggies
              ...provider.plannerVeggies
                  .where((v) => !_quickVeggies.any((q) => q['name'] == v))
                  .map((customVeg) {
                return Chip(
                  avatar: const Text('🥗', style: TextStyle(fontSize: 13)),
                  label: Text(customVeg),
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.25),
                  side: const BorderSide(color: AppTheme.primary),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                  deleteIcon: const Icon(Icons.close_rounded,
                      size: 14, color: AppTheme.primary),
                  onDeleted: () => provider.removePlannerVeggie(customVeg),
                );
              }),
              // "+ आणखी भाजी जोडा" Button
              ActionChip(
                avatar: const Icon(Icons.add_rounded,
                    color: AppTheme.primary, size: 18),
                label: const Text(
                  '+ आणखी भाजी जोडा',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                side: BorderSide(
                  color: AppTheme.primary.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                onPressed: () => _showAddVeggieModal(context, provider, lang),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Family Members Count
          Text(
            AppStrings.get('familyMembers', lang),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['१-२ लोक', '३-४ लोक', '५-६ लोक', '७+ लोक'].map((count) {
              final isSelected = provider.plannerPeopleCount == count;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    label: Text(count, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.surfaceCard,
                    side: BorderSide(
                      color:
                          isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                    ),
                    labelStyle: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                    ),
                    onSelected: (_) => provider.setPlannerPeopleCount(count),
                    showCheckmark: false,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 4. What was cooked yesterday? (Anti-repeat trigger)
          Text(
            AppStrings.get('cookedYesterday', lang),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _yesterdayOptions.map((opt) {
              final isSelected = provider.plannerYesterdayDish == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                selectedColor: Colors.deepOrangeAccent,
                backgroundColor: AppTheme.surfaceCard,
                side: BorderSide(
                  color: isSelected
                      ? Colors.deepOrangeAccent
                      : AppTheme.borderSubtle,
                ),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
                onSelected: (_) => provider.setPlannerYesterdayDish(opt),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Suggest Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppTheme.primary.withValues(alpha: 0.4),
              ),
              onPressed: provider.isSuggestingMeal
                  ? null
                  : () => provider.generateSmartMealSuggestion(),
              child: provider.isSuggestingMeal
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(AppStrings.get('suggestingMeal', lang)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.get('suggestMealBtn', lang),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Result Card if generated
          if (provider.currentSuggestion != null)
            _buildRecommendationCard(
                context, provider.currentSuggestion!, provider, lang),
        ],
      ),
    );
  }

  Widget _buildMealTimeChip(String key, String label, RecipeProvider provider) {
    final isSelected = provider.plannerMealTime == key;
    return Expanded(
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: isSelected,
        selectedColor: AppTheme.primary,
        backgroundColor: AppTheme.surfaceCard,
        side: BorderSide(
          color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
        ),
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
        ),
        onSelected: (_) => provider.setPlannerMealTime(key),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    MealSuggestion suggestion,
    RecipeProvider provider,
    String lang,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Banner
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(suggestion.recipe.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.surfaceCard.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⭐ ${AppStrings.get('todaysRecommendation', lang)}',
                      style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 14, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(suggestion.cookingTime,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.onSurfaceVariant)),
                          const SizedBox(width: 14),
                          const Icon(Icons.local_fire_department_rounded,
                              size: 14, color: Colors.orangeAccent),
                          const SizedBox(width: 4),
                          Text(suggestion.calories,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Reason Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.deepOrangeAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: Colors.deepOrangeAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('whyThisDish', lang),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              suggestion.aiReason,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Complete Thali Pairing
                Text(
                  AppStrings.get('completeThali', lang),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('🍛', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          suggestion.thaliPairing,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon:
                            const Icon(Icons.restaurant_menu_rounded, size: 18),
                        label: Text(
                          AppStrings.get('startCookingThis', lang),
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          provider.setCurrentRecipe(suggestion.recipe);
                          Navigator.pushNamed(context, '/recipe-result');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.borderSubtle),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          AppStrings.get('suggestAnother', lang),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.onSurfaceVariant),
                        ),
                        onPressed: () => provider.generateSmartMealSuggestion(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPlannerView(
      BuildContext context, RecipeProvider provider, String lang) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      itemCount: provider.weeklyMealPlan.length + 1,
      itemBuilder: (context, idx) {
        if (idx == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('weeklyPlannerTitle', lang),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.get('weeklyPlannerSubtitle', lang),
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }

        final item = provider.weeklyMealPlan[idx - 1];
        final day = lang == 'mr' ? item['day_mr'] : item['day_en'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: ExpansionTile(
            shape: const Border(),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(item['icon'] as String,
                  style: const TextStyle(fontSize: 20)),
            ),
            title: Text(
              day as String,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            subtitle: Text(
              'दुपार: ${item['lunch']} | रात्र: ${item['dinner']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.onSurfaceVariant),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const Divider(color: AppTheme.borderSubtle),
              // Lunch
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🍛 ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'दुपारचे जेवण: ${item['lunch']}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary),
                        ),
                        Text(
                          'सोबत: ${item['lunch_side']}',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Dinner
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🍲 ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'रात्रीचे जेवण: ${item['dinner']}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent),
                        ),
                        Text(
                          'सोबत: ${item['dinner_side']}',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
