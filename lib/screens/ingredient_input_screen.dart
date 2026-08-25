import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../services/gemini_service.dart';
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
    {
      'en': 'Onion',
      'mr': 'कांदा (Onion)',
      'hi': 'प्याज (Onion)',
      'es': 'Cebolla',
      'icon': '🧅'
    },
    {
      'en': 'Potato',
      'mr': 'बटाटा (Potato)',
      'hi': 'आलू (Potato)',
      'es': 'Patata',
      'icon': '🥔'
    },
    {
      'en': 'Garlic & Ginger',
      'mr': 'लसूण-आले (Garlic-Ginger)',
      'hi': 'लहसुन-अदरक',
      'es': 'Ajo y Jengibre',
      'icon': '🧄'
    },
    {
      'en': 'Green Chillies',
      'mr': 'हिरवी मिरची (Chillies)',
      'hi': 'हरी मिर्च',
      'es': 'Chiles Verdes',
      'icon': '🌶️'
    },
    {
      'en': 'Poha (Flattened Rice)',
      'mr': 'जाड पोहे (Poha)',
      'hi': 'पोहा (Poha)',
      'es': 'Poha',
      'icon': '🌾'
    },
    {
      'en': 'Gram Flour (Besan)',
      'mr': 'बेसन (Besan)',
      'hi': 'बेसन (Besan)',
      'es': 'Harina de Garbanzo',
      'icon': '🥣'
    },
    {
      'en': 'Sprouted Matki / Moong',
      'mr': 'मोड आलेली मटकी/मूग',
      'hi': 'अंकुरित मटकी/मूंग',
      'es': 'Brotes',
      'icon': '🌱'
    },
    {
      'en': 'Roasted Peanuts',
      'mr': 'शेंगदाणे (Peanuts)',
      'hi': 'मूंगफली',
      'es': 'Cacahuetes',
      'icon': '🥜'
    },
    {
      'en': 'Grated Coconut',
      'mr': 'ओले/सुके खोबरे',
      'hi': 'नारियल (Coconut)',
      'es': 'Coco Rallado',
      'icon': '🥥'
    },
    {
      'en': 'Tomatoes',
      'mr': 'टोमॅटो (Tomato)',
      'hi': 'टमाटर',
      'es': 'Tomates',
      'icon': '🍅'
    },
    {
      'en': 'Fresh Coriander',
      'mr': 'ताजी कोथिंबीर',
      'hi': 'हरा धनिया',
      'es': 'Cilantro Fresco',
      'icon': '🌿'
    },
    {
      'en': 'Rava / Semolina',
      'mr': 'बारीक रवा (Sooji)',
      'hi': 'रवा / सूजी',
      'es': 'Sémola',
      'icon': '🍚'
    },
    {
      'en': 'Paneer / Tofu',
      'mr': 'ताजे पनीर (Paneer)',
      'hi': 'पनीर (Paneer)',
      'es': 'Paneer',
      'icon': '🧀'
    },
    {
      'en': 'Basmati / Rice',
      'mr': 'तांदूळ (Rice)',
      'hi': 'चावल (Rice)',
      'es': 'Arroz',
      'icon': '🍚'
    },
    {
      'en': 'Brinjal (Vangi)',
      'mr': 'काटेरी वांगी (Brinjal)',
      'hi': 'बैंगन (Brinjal)',
      'es': 'Berenjena',
      'icon': '🍆'
    },
    {
      'en': 'Goda / Garam Masala',
      'mr': 'गोडा मसाला / कांदा लसूण',
      'hi': 'गरम / गोडा मसाला',
      'es': 'Especias Garam',
      'icon': '✨'
    },
  ];

  final List<Map<String, String>> _dietaryOptions = const [
    {
      'en': '🌶️ Spicy (झणझणीत)',
      'mr': '🌶️ झणझणीत (Spicy)',
      'hi': '🌶️ चटपटा / तीखा',
      'es': '🌶️ Picante'
    },
    {
      'en': '🥑 Fasting (उपवास)',
      'mr': '🥑 उपवास स्पेशल (Fasting)',
      'hi': '🥑 व्रत / उपवास',
      'es': '🥑 Ayuno'
    },
    {
      'en': '🌱 Pure Veg (शाकाहारी)',
      'mr': '🌱 शुद्ध शाकाहारी',
      'hi': '🌱 शुद्ध शाकाहारी',
      'es': '🌱 Puro Vegetariano'
    },
    {
      'en': '⏱️ Under 20 Mins',
      'mr': '⏱️ २० मिनिटांत झटपट',
      'hi': '⏱️ २० मिनट से कम',
      'es': '⏱️ Menos de 20 Min'
    },
    {
      'en': '🥣 High Protein',
      'mr': '🥣 भरपूर प्रोटीनयुक्त',
      'hi': '🥣 हाई प्रोटीन',
      'es': '🥣 Alto en Proteínas'
    },
  ];

  void _handleAddCustom(String lang) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final items =
          text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
      for (final item in items) {
        Provider.of<RecipeProvider>(context, listen: false)
            .addCustomIngredient(item);
      }
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: AppTheme.surfaceCard,
          content: Text(
            AppStrings.get('addedIngredient', lang),
            style: const TextStyle(
                color: AppTheme.primary, fontWeight: FontWeight.bold),
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
            style: const TextStyle(
                color: AppTheme.primary, fontWeight: FontWeight.bold),
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

  void _showApiKeyDialog(String lang) {
    final keyController =
        TextEditingController(text: GeminiService.customApiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.vpn_key_rounded, color: AppTheme.primary, size: 22),
            SizedBox(width: 10),
            Text('Gemini AI Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your Gemini API Key from Google AI Studio to unlock live cloud AI generation, or leave blank to use the high-variety smart engine:',
              style: TextStyle(
                  color: AppTheme.onSurfaceVariant, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: keyController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'AIzaSy...',
                hintStyle: const TextStyle(color: AppTheme.onSurfaceVariant),
                filled: true,
                fillColor: AppTheme.surfaceHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              GeminiService.customApiKey = '';
              Navigator.pop(ctx);
            },
            child: const Text('Reset',
                style: TextStyle(color: AppTheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              GeminiService.customApiKey = keyController.text.trim();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.surfaceCard,
                  content: Text(
                    GeminiService.customApiKey.isNotEmpty
                        ? 'Gemini Live Cloud AI key activated! ✨'
                        : 'Using Dynamic Variety Engine! ✨',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            child: const Text('Save Key'),
          ),
        ],
      ),
    );
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
          // API Key Settings Button
          IconButton(
            icon: const Icon(Icons.vpn_key_outlined,
                color: AppTheme.primary, size: 20),
            tooltip: 'Configure Gemini API Key',
            onPressed: () => _showApiKeyDialog(lang),
          ),
          // Language Switch Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
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
          TextButton(
            onPressed: provider.clearIngredients,
            child: Text(
              AppStrings.get('clearAll', lang),
              style: const TextStyle(
                  color: AppTheme.onSurfaceVariant, fontSize: 12),
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
                        const Icon(Icons.auto_awesome_rounded,
                            color: AppTheme.primary, size: 20),
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
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.get('fridgeSubtitle', lang),
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                          height: 1.4),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: AppStrings.get('customInputHint', lang),
                          hintStyle: const TextStyle(
                              color: AppTheme.onSurfaceVariant, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppTheme.onSurfaceVariant, size: 20),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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
                      color: provider.selectedIngredients.isNotEmpty
                          ? AppTheme.success
                          : AppTheme.tertiary,
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
                            style: const TextStyle(
                                color: AppTheme.onSurfaceVariant,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.selectedIngredients.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceHigh,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      AppTheme.primary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => provider.removeIngredient(item),
                                  child: const Icon(Icons.close_rounded,
                                      size: 14,
                                      color: AppTheme.onSurfaceVariant),
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
                  final isSelected =
                      provider.selectedIngredients.contains(displayName) ||
                          provider.selectedIngredients.contains(canonicalName);

                  return GestureDetector(
                    onTap: () => provider.toggleIngredient(displayName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary.withValues(alpha: 0.18)
                            : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.borderSubtle,
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
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.onSurfaceVariant,
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
                  final isSelected =
                      provider.selectedPreferences.contains(displayPref) ||
                          provider.selectedPreferences.contains(canonicalPref);

                  return FilterChip(
                    label: Text(displayPref),
                    selected: isSelected,
                    onSelected: (_) => provider.togglePreference(displayPref),
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.surfaceCard,
                    side: BorderSide(
                      color:
                          isSelected ? AppTheme.primary : AppTheme.borderSubtle,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color:
                          isSelected ? Colors.white : AppTheme.onSurfaceVariant,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 4,
                    shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                  ),
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Icon(Icons.auto_awesome_rounded, size: 22),
                  label: Text(
                    _isGenerating
                        ? AppStrings.get('generatingBtn', lang)
                        : AppStrings.get('generateBtn', lang),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
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
