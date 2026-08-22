import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../widgets/language_selector_modal.dart';

class IngredientInputScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const IngredientInputScreen({super.key, this.onNavigateTab});

  @override
  State<IngredientInputScreen> createState() => _IngredientInputScreenState();
}

class _IngredientInputScreenState extends State<IngredientInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _staples = const [
    {'en': 'Chicken Breast', 'mr': 'चिकन ब्रेस्ट', 'hi': 'चिकन', 'es': 'Pechuga de Pollo', 'icon': '🍗'},
    {'en': 'Organic Eggs', 'mr': 'अंडी (Eggs)', 'hi': 'अंडे', 'es': 'Huevos Orgánicos', 'icon': '🥚'},
    {'en': 'Tomatoes', 'mr': 'टोमॅटो', 'hi': 'टमाटर', 'es': 'Tomates', 'icon': '🍅'},
    {'en': 'Garlic Cloves', 'mr': 'लसूण पाकळ्या', 'hi': 'लहसुन', 'es': 'Dientes de Ajo', 'icon': '🧄'},
    {'en': 'Olive Oil', 'mr': 'ऑलिव्ह ऑईल', 'hi': 'जैतून का तेल', 'es': 'Aceite de Oliva', 'icon': '🫒'},
    {'en': 'Basmati Rice', 'mr': 'बासमती तांदूळ', 'hi': 'बासमती चावल', 'es': 'Arroz Basmati', 'icon': '🍚'},
    {'en': 'Penne Pasta', 'mr': 'पेन्ने पास्ता', 'hi': 'पास्ता', 'es': 'Pasta Penne', 'icon': '🍝'},
    {'en': 'Mozzarella', 'mr': 'मोझरेला चीज', 'hi': 'मोज़ेरेला पनीर', 'es': 'Mozzarella', 'icon': '🧀'},
    {'en': 'Baby Spinach', 'mr': 'ताजी पालक', 'hi': 'ताज़ा पालक', 'es': 'Espinacas Frescas', 'icon': '🥬'},
    {'en': 'Ripe Avocado', 'mr': 'ॲव्होकॅडो', 'hi': 'एवोकैडो', 'es': 'Aguacate Maduro', 'icon': '🥑'},
    {'en': 'Mushrooms', 'mr': 'मशरूम (Mushroom)', 'hi': 'मशरूम', 'es': 'Champiñones', 'icon': '🍄'},
    {'en': 'Fresh Salmon', 'mr': 'ताजा मासा (Salmon)', 'hi': 'सैल्मन मछली', 'es': 'Salmón Fresco', 'icon': '🐟'},
  ];

  final List<Map<String, String>> _dietaryOptions = const [
    {'en': '🥑 Keto', 'mr': '🥑 कीटो (Keto)', 'hi': '🥑 कीटो', 'es': '🥑 Keto'},
    {'en': '🌱 Vegan', 'mr': '🌱 शाकाहारी (Vegan)', 'hi': '🌱 शाकाहारी', 'es': '🌱 Vegano'},
    {'en': '🌾 Gluten-Free', 'mr': '🌾 ग्लूटेन-मुक्त', 'hi': '🌾 ग्लूटेन मुक्त', 'es': '🌾 Sin Gluten'},
    {'en': '⏱️ Under 30 Mins', 'mr': '⏱️ ३० मिनिटांत', 'hi': '⏱️ ३० मिनट से कम', 'es': '⏱️ Menos de 30 Min'},
  ];

  void _handleAddCustom(String lang) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final items = text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
      for (final item in items) {
        Provider.of<RecipeProvider>(context, listen: false).addCustomIngredient(item);
      }
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: AppTheme.surfaceCard,
          content: Text(
            AppStrings.get('addedIngredient', lang),
            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> _handleGenerate(String lang) async {
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    if (provider.selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.surfaceCard,
          content: Text(
            AppStrings.get('pleaseSelectIngredient', lang),
            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      await provider.generateRecipeFromPantry();
      if (mounted) {
        setState(() => _isGenerating = false);
        Navigator.pushNamed(context, '/recipe-result');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        Navigator.pushNamed(context, '/recipe-result');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    final lang = provider.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (widget.onNavigateTab != null) {
              widget.onNavigateTab!(0);
            }
          },
        ),
        title: Text(
          AppStrings.get('smartPantryTitle', lang),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          TextButton(
            onPressed: provider.clearIngredients,
            child: Text(
              AppStrings.get('clearAll', lang),
              style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.surfaceCard, AppTheme.surfaceHigh],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.get('aiKitchenAssistant', lang),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.get('fridgeQuestion', lang),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.get('fridgeSubtitle', lang),
                      style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Custom Input
              Text(
                AppStrings.get('addCustom', lang),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _handleAddCustom(lang),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: AppStrings.get('customInputHint', lang),
                          hintStyle: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.onSurfaceVariant, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _handleAddCustom(lang),
                    child: const Icon(Icons.add_rounded, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Selected Ingredients Tags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.get('selectedIngredients', lang)} (${provider.selectedIngredients.length})',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    provider.selectedIngredients.isNotEmpty
                        ? AppStrings.get('readyToCook', lang)
                        : AppStrings.get('selectAtLeastOne', lang),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: provider.selectedIngredients.isNotEmpty ? AppTheme.success : AppTheme.tertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: provider.selectedIngredients.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppStrings.get('noIngredientsAdded', lang),
                            style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.selectedIngredients.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceHigh,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => provider.removeIngredient(item),
                                  child: const Icon(Icons.close_rounded, size: 14, color: AppTheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),

              // Pantry Staples Grid
              Text(
                AppStrings.get('pantryStaples', lang),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemCount: _staples.length,
                itemBuilder: (context, idx) {
                  final staple = _staples[idx];
                  final displayName = staple[lang] ?? staple['en']!;
                  final canonicalName = staple['en']!;
                  final icon = staple['icon']!;
                  final isSelected = provider.selectedIngredients.contains(displayName) ||
                      provider.selectedIngredients.contains(canonicalName);

                  return GestureDetector(
                    onTap: () => provider.toggleIngredient(displayName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary.withValues(alpha: 0.18) : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Dietary Preferences
              Text(
                AppStrings.get('dietaryPreferences', lang),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _dietaryOptions.map((opt) {
                  final displayPref = opt[lang] ?? opt['en']!;
                  final canonicalPref = opt['en']!;
                  final isSelected = provider.selectedPreferences.contains(displayPref) ||
                      provider.selectedPreferences.contains(canonicalPref);

                  return FilterChip(
                    label: Text(displayPref),
                    selected: isSelected,
                    onSelected: (_) => provider.togglePreference(displayPref),
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.surfaceCard,
                    side: BorderSide(
                      color: isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Action CTA Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 4,
                    shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                  ),
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Icon(Icons.auto_awesome_rounded, size: 22),
                  label: Text(
                    _isGenerating ? AppStrings.get('generatingBtn', lang) : AppStrings.get('generateBtn', lang),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isGenerating ? null : () => _handleGenerate(lang),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
