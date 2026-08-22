import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/gemini_service.dart';

class RecipeProvider with ChangeNotifier {
  final List<Recipe> _allRecipes = [
    Recipe(
      id: 'rec_chicken_skillet',
      title: 'Tuscan Garlic Butter Chicken Skillet',
      category: 'High Protein',
      imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=900&q=80',
      time: '25 min',
      calories: '420 kcal',
      servings: '4 Servings',
      rating: '4.9',
      reviews: '1.2k',
      difficulty: 'Medium',
      description: 'Tender pan-seared chicken breasts smothered in a rich garlic butter cream sauce infused with sun-dried tomatoes and fresh baby spinach.',
      ingredients: [
        IngredientItem(name: 'Chicken breasts', amount: '2 large cutlets'),
        IngredientItem(name: 'Fresh garlic cloves', amount: '4 cloves (minced)'),
        IngredientItem(name: 'Sun-dried tomatoes', amount: '1/2 cup (chopped)'),
        IngredientItem(name: 'Fresh baby spinach', amount: '2 cups packed'),
        IngredientItem(name: 'Heavy whipping cream', amount: '3/4 cup'),
        IngredientItem(name: 'Parmesan cheese', amount: '1/3 cup grated'),
        IngredientItem(name: 'Extra virgin olive oil', amount: '2 tbsp'),
        IngredientItem(name: 'Paprika & herbs', amount: '1 tsp each'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'Season and Sear Chicken',
          instruction: 'Pat chicken cutlets dry. Season with paprika, salt, and pepper. Heat olive oil in a skillet over medium-high heat and sear for 5-6 minutes per side until golden.',
          timerSeconds: 360,
        ),
        CookingStep(
          number: 2,
          title: 'Sauté Aromatics',
          instruction: 'Reduce heat to medium. Add minced garlic and sun-dried tomatoes to the skillet drippings. Sauté for 2 minutes until fragrant.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 3,
          title: 'Build the Cream Sauce',
          instruction: 'Pour in heavy cream, deglazing the pan. Stir in freshly grated Parmesan cheese until melted into a silky sauce.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 4,
          title: 'Wilt Spinach & Simmer',
          instruction: 'Add fresh spinach leaves. Simmer for 2 minutes until wilted, then return chicken to the pan and coat with warm sauce.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 5,
          title: 'Garnish & Plate',
          instruction: 'Garnish with cracked black pepper and fresh basil. Serve immediately with warm crusty bread or pasta.',
          timerSeconds: 0,
        ),
      ],
    ),
    Recipe(
      id: 'rec_honey_salmon',
      title: 'Spicy Honey Glazed Salmon',
      category: 'Quick Meals',
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=900&q=80',
      time: '20 min',
      calories: '380 kcal',
      servings: '2 Servings',
      rating: '4.8',
      reviews: '950',
      difficulty: 'Easy',
      description: 'Crispy caramelized salmon fillets coated with a sweet & spicy honey-sriracha glaze, served over fluffy quinoa.',
      ingredients: [
        IngredientItem(name: 'Fresh salmon fillets', amount: '2 portions (6 oz)'),
        IngredientItem(name: 'Pure raw honey', amount: '3 tbsp'),
        IngredientItem(name: 'Sriracha chili paste', amount: '1 tbsp'),
        IngredientItem(name: 'Soy sauce', amount: '1.5 tbsp'),
        IngredientItem(name: 'Lime juice', amount: '1 tbsp'),
        IngredientItem(name: 'Toasted sesame seeds', amount: '1 tsp'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'Whisk Glaze',
          instruction: 'Whisk honey, sriracha, soy sauce, lime juice, and garlic powder in a small bowl until blended.',
          timerSeconds: 60,
        ),
        CookingStep(
          number: 2,
          title: 'Sear Salmon',
          instruction: 'Sear salmon skin-side up in a hot oiled pan for 4 minutes until golden crusted.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 3,
          title: 'Glaze and Caramelize',
          instruction: 'Flip salmon, pour glaze into skillet, and baste constantly for 3 minutes until thick and glossy.',
          timerSeconds: 180,
        ),
      ],
    ),
    Recipe(
      id: 'rec_creamy_pasta',
      title: 'Creamy Sun-Dried Tomato Penne',
      category: 'Italian',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d6281e04?auto=format&fit=crop&w=900&q=80',
      time: '18 min',
      calories: '490 kcal',
      servings: '3 Servings',
      rating: '4.7',
      reviews: '820',
      difficulty: 'Easy',
      description: 'Al dente penne pasta tossed in a velvety mascarpone garlic sauce with sweet sun-dried tomatoes and fresh basil.',
      ingredients: [
        IngredientItem(name: 'Penne pasta', amount: '250g'),
        IngredientItem(name: 'Sun-dried tomatoes', amount: '1/2 cup'),
        IngredientItem(name: 'Heavy cream', amount: '1/2 cup'),
        IngredientItem(name: 'Garlic cloves', amount: '3 cloves'),
        IngredientItem(name: 'Fresh basil', amount: '1/2 cup'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'Boil Pasta',
          instruction: 'Cook penne in salted boiling water until al dente. Reserve 1/2 cup pasta water before draining.',
          timerSeconds: 600,
        ),
        CookingStep(
          number: 2,
          title: 'Sauté Garlic & Tomatoes',
          instruction: 'Heat olive oil and sauté sliced garlic for 1 minute before stirring in sun-dried tomatoes.',
          timerSeconds: 120,
        ),
        CookingStep(
          number: 3,
          title: 'Simmer Cream Sauce',
          instruction: 'Add cream and parmesan. Stir until glossy, toss in pasta and fresh torn basil.',
          timerSeconds: 120,
        ),
      ],
    ),
    Recipe(
      id: 'rec_avocado_bowl',
      title: 'Avocado & Truffle Egg Power Bowl',
      category: 'Vegetarian',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80',
      time: '12 min',
      calories: '340 kcal',
      servings: '1 Serving',
      rating: '4.9',
      reviews: '640',
      difficulty: 'Easy',
      description: 'A nutrient-packed breakfast bowl with creamy sliced avocado, farm-fresh poached eggs, and truffle oil drizzle.',
      ingredients: [
        IngredientItem(name: 'Hass avocado', amount: '1 ripe sliced'),
        IngredientItem(name: 'Organic eggs', amount: '2 large'),
        IngredientItem(name: 'Baby arugula & greens', amount: '2 cups'),
        IngredientItem(name: 'Cherry tomatoes', amount: '1/2 cup'),
        IngredientItem(name: 'Truffle oil & seasonings', amount: '1 tsp'),
      ],
      steps: [
        CookingStep(
          number: 1,
          title: 'Prep Greens',
          instruction: 'Toss greens and cherry tomatoes with lemon juice and olive oil.',
          timerSeconds: 60,
        ),
        CookingStep(
          number: 2,
          title: 'Poach Eggs',
          instruction: 'Poach eggs in simmering water for 3 minutes for perfect runny yolks.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 3,
          title: 'Assemble Bowl',
          instruction: 'Top with sliced avocado, warm poached eggs, truffle oil, and bagel seasoning.',
          timerSeconds: 0,
        ),
      ],
    ),
  ];

  late final List<Recipe> _savedRecipes = [
    _allRecipes[0],
    _allRecipes[1],
  ];

  late Recipe _currentRecipe = _allRecipes[0];

  final List<String> _selectedIngredients = [
    'Chicken Breast',
    'Garlic Cloves',
    'Baby Spinach',
  ];

  final List<String> _selectedPreferences = [];
  String _homeCategoryFilter = 'All';
  String _savedCategoryFilter = 'All';
  String _homeSearchQuery = '';
  String _savedSearchQuery = '';
  String _currentLanguage = 'en';
  bool _isAiGenerating = false;

  // Getters
  List<Recipe> get allRecipes => _allRecipes;
  List<Recipe> get savedRecipes => _savedRecipes;
  Recipe get currentRecipe => _currentRecipe;
  List<String> get selectedIngredients => _selectedIngredients;
  List<String> get selectedPreferences => _selectedPreferences;
  String get homeCategoryFilter => _homeCategoryFilter;
  String get savedCategoryFilter => _savedCategoryFilter;
  String get homeSearchQuery => _homeSearchQuery;
  String get savedSearchQuery => _savedSearchQuery;
  String get currentLanguage => _currentLanguage;
  bool get isAiGenerating => _isAiGenerating;

  List<Recipe> get filteredHomeRecipes {
    return _allRecipes.where((r) {
      final matchesCategory = _homeCategoryFilter == 'All' || r.category == _homeCategoryFilter;
      final matchesSearch = _homeSearchQuery.isEmpty ||
          r.title.toLowerCase().contains(_homeSearchQuery.toLowerCase()) ||
          r.ingredients.any((i) => i.name.toLowerCase().contains(_homeSearchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Recipe> get filteredSavedRecipes {
    return _savedRecipes.where((r) {
      final matchesCategory = _savedCategoryFilter == 'All' || r.category == _savedCategoryFilter;
      final matchesSearch = _savedSearchQuery.isEmpty ||
          r.title.toLowerCase().contains(_savedSearchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  bool isSaved(String recipeId) {
    return _savedRecipes.any((r) => r.id == recipeId);
  }

  void setLanguage(String langCode) {
    _currentLanguage = langCode;
    notifyListeners();
  }

  void toggleSave(Recipe recipe) {
    final index = _savedRecipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      _savedRecipes.removeAt(index);
    } else {
      _savedRecipes.add(recipe);
    }
    notifyListeners();
  }

  void setCurrentRecipe(Recipe recipe) {
    _currentRecipe = recipe;
    notifyListeners();
  }

  void setHomeCategoryFilter(String category) {
    _homeCategoryFilter = category;
    notifyListeners();
  }

  void setSavedCategoryFilter(String category) {
    _savedCategoryFilter = category;
    notifyListeners();
  }

  void setHomeSearchQuery(String query) {
    _homeSearchQuery = query;
    notifyListeners();
  }

  void setSavedSearchQuery(String query) {
    _savedSearchQuery = query;
    notifyListeners();
  }

  void toggleIngredient(String item) {
    if (_selectedIngredients.contains(item)) {
      _selectedIngredients.remove(item);
    } else {
      _selectedIngredients.add(item);
    }
    notifyListeners();
  }

  void addCustomIngredient(String item) {
    final clean = item.trim();
    if (clean.isNotEmpty && !_selectedIngredients.contains(clean)) {
      _selectedIngredients.add(clean);
      notifyListeners();
    }
  }

  void removeIngredient(String item) {
    _selectedIngredients.remove(item);
    notifyListeners();
  }

  void clearIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  void togglePreference(String pref) {
    if (_selectedPreferences.contains(pref)) {
      _selectedPreferences.remove(pref);
    } else {
      _selectedPreferences.add(pref);
    }
    notifyListeners();
  }

  void toggleIngredientCheck(int idx) {
    if (idx >= 0 && idx < _currentRecipe.ingredients.length) {
      _currentRecipe.ingredients[idx].isChecked = !_currentRecipe.ingredients[idx].isChecked;
      notifyListeners();
    }
  }

  void toggleAllIngredientsCheck() {
    final allChecked = _currentRecipe.ingredients.every((i) => i.isChecked);
    for (var ing in _currentRecipe.ingredients) {
      ing.isChecked = !allChecked;
    }
    notifyListeners();
  }

  Future<Recipe> generateRecipeFromPantry() async {
    _isAiGenerating = true;
    notifyListeners();

    try {
      final generated = await GeminiService.generateRecipe(
        ingredients: _selectedIngredients,
        preferences: _selectedPreferences,
        language: _currentLanguage,
      );

      _currentRecipe = generated;
      // Prepend to all recipes feed so it shows in trending
      if (!_allRecipes.any((r) => r.id == generated.id)) {
        _allRecipes.insert(0, generated);
      }

      _isAiGenerating = false;
      notifyListeners();
      return generated;
    } catch (e) {
      _isAiGenerating = false;
      notifyListeners();
      rethrow;
    }
  }
}
