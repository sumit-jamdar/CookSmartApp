import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class GeminiService {
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const List<String> candidateModels = [
    'gemini-3.5-flash',
    'gemini-flash-latest',
    'gemini-3.6-flash',
    'gemini-3-flash-preview',
  ];

  static Future<Recipe> generateRecipe({
    required List<String> ingredients,
    required List<String> preferences,
    String language = 'en',
  }) async {
    final ingredientsList = ingredients.join(', ');
    final preferencesList = preferences.isNotEmpty ? preferences.join(', ') : 'None';

    String langInstruction = 'in English';
    if (language == 'mr') {
      langInstruction = 'completely and authentically in MARATHI (मराठी) language. Use natural Marathi food terminology (उदा. पाककृतीचे नाव, साहित्याची नावे व अचूक प्रमाण, कृतीचे टप्पे सर्व मराठीत असावेत).';
    } else if (language == 'hi') {
      langInstruction = 'completely in HINDI (हिंदी) language. Use natural Hindi culinary terms (उदा. शीर्षक, सामग्री और मात्रा, निर्देश सब शुद्ध व सरल हिंदी में हों).';
    } else if (language == 'es') {
      langInstruction = 'completely in SPANISH (Español) language.';
    }

    final prompt = '''
You are a Michelin-star Executive Chef and multilingual culinary expert.
Create a unique, creative, and delicious gourmet recipe tailored specifically around these available ingredients:
Available Ingredients: $ingredientsList
Dietary Preferences / Restrictions: $preferencesList

CRITICAL REQUIREMENT: Output the recipe content (title, category, time, description, ingredient names and preparation cuts, and step-by-step instructions) $langInstruction.

You may include essential kitchen seasonings (salt, pepper, olive oil, water, butter) as needed.

Return ONLY a JSON object matching this exact schema:
{
  "title": "Dish Title in target language",
  "category": "Cuisine Category in target language",
  "time": "Total cooking & prep time (e.g. 20 min / २० मिनिटे)",
  "calories": "Estimated calories (e.g. 450 kcal / ४५० कॅलरी)",
  "servings": "Number of servings (e.g. 2 Servings / २ व्यक्तींसाठी)",
  "description": "2-3 appetizing sentences describing flavor, aroma, and texture in target language.",
  "ingredients": [
    {
      "name": "Ingredient item name with cut or prep in target language",
      "amount": "Exact measurement / quantity in target language (e.g. 250g, 2 चम्मच, 2 चमचे)"
    }
  ],
  "steps": [
    {
      "number": 1,
      "title": "Step action title in target language",
      "instruction": "Detailed, clear cooking instruction in target language",
      "timerSeconds": 180
    }
  ]
}
''';

    for (final model in candidateModels) {
      try {
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [{'text': prompt}]
              }
            ],
            'generationConfig': {
              'responseMimeType': 'application/json',
              'temperature': 0.7,
            }
          }),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final text = candidates[0]['content']['parts'][0]['text'] as String;
            final recipeJson = jsonDecode(text);
            return _parseRecipeFromJson(recipeJson, ingredients, language);
          }
        }
      } catch (e) {
        // Try next candidate model
        continue;
      }
    }

    // Fallback synthesis if remote attempts fail
    return _buildFallbackRecipe(ingredients, preferences, language);
  }

  static Recipe _parseRecipeFromJson(Map<String, dynamic> json, List<String> ingredients, String language) {
    final defaultTitle = language == 'mr'
        ? 'शेफची खास रेसिपी'
        : language == 'hi'
            ? 'शेफ की खास रेसिपी'
            : 'Chef’s Special Recipe';

    final defaultCategory = language == 'mr'
        ? 'झटपट जेवण'
        : language == 'hi'
            ? 'झटपट भोजन'
            : 'Quick Meals';

    final title = json['title'] as String? ?? defaultTitle;
    final category = json['category'] as String? ?? defaultCategory;
    final time = json['time'] as String? ?? (language == 'mr' ? '२५ मिनिटे' : '25 min');
    final calories = json['calories'] as String? ?? (language == 'mr' ? '४५० कॅलरी' : '450 kcal');
    final servings = json['servings'] as String? ?? (language == 'mr' ? '२ व्यक्तींसाठी' : '2 Servings');
    final description = json['description'] as String? ??
        (language == 'mr'
            ? 'आपल्या घरातील साहित्यापासून तयार केलेली एक अप्रतिम व चवदार डिश.'
            : 'A delicious dish crafted with your pantry ingredients.');

    final rawIngredients = json['ingredients'] as List? ?? [];
    final parsedIngredients = rawIngredients.map((i) {
      return IngredientItem(
        name: i['name'] as String? ?? 'Ingredient',
        amount: i['amount'] as String? ?? (language == 'mr' ? 'आवश्यकतेनुसार' : 'As needed'),
        isChecked: false,
      );
    }).toList();

    final rawSteps = json['steps'] as List? ?? [];
    final parsedSteps = <CookingStep>[];
    for (int i = 0; i < rawSteps.length; i++) {
      final s = rawSteps[i];
      parsedSteps.add(
        CookingStep(
          number: s['number'] is int ? s['number'] as int : i + 1,
          title: s['title'] as String? ?? (language == 'mr' ? 'टप्पा ${i + 1}' : 'Step ${i + 1}'),
          instruction: s['instruction'] as String? ?? 'Follow preparation guidelines.',
          timerSeconds: s['timerSeconds'] is int ? s['timerSeconds'] as int : 0,
        ),
      );
    }

    final imageUrl = _getImageForCategory(category, title);

    return Recipe(
      id: 'gemini-recipe-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      rating: '4.9',
      reviews: language == 'mr' ? 'AI निर्मित' : 'AI Generated',
      difficulty: language == 'mr' ? 'सोपे' : 'Easy',
      time: time,
      calories: calories,
      servings: servings,
      imageUrl: imageUrl,
      description: description,
      ingredients: parsedIngredients.isNotEmpty
          ? parsedIngredients
          : ingredients.map((item) => IngredientItem(name: item, amount: language == 'mr' ? '१ भाग' : '1 portion')).toList(),
      steps: parsedSteps.isNotEmpty
          ? parsedSteps
          : [
              CookingStep(
                number: 1,
                title: language == 'mr' ? 'साहित्याची पूर्वतयारी' : 'Prep Ingredients',
                instruction: language == 'mr' ? 'सर्व साहित्य स्वच्छ धुवून बारीक चिरून घ्या.' : 'Wash and prep all ingredients into bite-sized cuts.',
                timerSeconds: 300,
              ),
              CookingStep(
                number: 2,
                title: language == 'mr' ? 'परतणे व शिजवणे' : 'Cook & Simmer',
                instruction: language == 'mr' ? 'कढईत तेल गरम करून मसाले व साहित्य मध्यम आचेवर परतून घ्या.' : 'Heat pan with olive oil, sauté aromatics, and cook until tender.',
                timerSeconds: 600,
              ),
              CookingStep(
                number: 3,
                title: language == 'mr' ? 'सजावट व सर्व्ह करणे' : 'Plate & Garnish',
                instruction: language == 'mr' ? 'ताजी कोथिंबीर किंवा हर्ब्सने सजवून गरमागरम वाढा.' : 'Season with herbs and serve hot.',
                timerSeconds: 60,
              ),
            ],
    );
  }

  static String _getImageForCategory(String category, String title) {
    final lower = '$category $title'.toLowerCase();
    if (lower.contains('pasta') || lower.contains('italian') || lower.contains('penne') || lower.contains('पास्ता')) {
      return 'https://images.unsplash.com/photo-1621996346565-e3d5d6281691?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('chicken') || lower.contains('poultry') || lower.contains('चिकन')) {
      return 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('salmon') || lower.contains('fish') || lower.contains('मासा')) {
      return 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('salad') || lower.contains('vegan') || lower.contains('avocado') || lower.contains('शाकाहारी')) {
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('egg') || lower.contains('breakfast') || lower.contains('अंडी')) {
      return 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('rice') || lower.contains('curry') || lower.contains('asian') || lower.contains('भात') || lower.contains('तांदूळ')) {
      return 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=80';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80';
  }

  static Recipe _buildFallbackRecipe(List<String> ingredients, List<String> preferences, String language) {
    final ingNames = ingredients.take(3).join(' & ');
    final ingredientsList = ingredients.join(', ');

    if (language == 'mr') {
      return Recipe(
        id: 'gemini-fallback-${DateTime.now().millisecondsSinceEpoch}',
        title: 'स्वादिष्ट $ingNames स्पेशल फ्राय',
        category: 'झटपट जेवण',
        rating: '4.9',
        reviews: 'AI निर्मित',
        difficulty: 'सोपे',
        time: '२० मिनिटे',
        calories: '४३० कॅलरी',
        servings: '२ व्यक्तींसाठी',
        imageUrl: _getImageForCategory('Quick Meals', ingNames),
        description: '$ingredientsList वापरून तयार केलेली एक उत्कृष्ट व चवदार डिश.',
        ingredients: ingredients.map((item) => IngredientItem(name: item, amount: '१ वाटी')).toList(),
        steps: [
          CookingStep(
            number: 1,
            title: 'साहित्याची तयारी',
            instruction: 'सर्व साहित्य स्वच्छ धुवून बारीक चिरून घ्या व हलके मीठ लावा.',
            timerSeconds: 240,
          ),
          CookingStep(
            number: 2,
            title: 'मसाल्यात परतणे',
            instruction: 'कढईत तेल किंवा तूप गरम करून मध्यम आचेवर सुवास येईपर्यंत परता.',
            timerSeconds: 480,
          ),
          CookingStep(
            number: 3,
            title: 'गरमागरम वाढा',
            instruction: 'वर कोथिंबीर किंवा लिंबाचा रस पिळून गरमागरम वाढा.',
            timerSeconds: 60,
          ),
        ],
      );
    }

    return Recipe(
      id: 'gemini-fallback-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Artisan $ingNames Sauté',
      category: preferences.isNotEmpty ? preferences.first.replaceAll(RegExp(r'[^\w\s-]'), '').trim() : 'Quick Meals',
      rating: '4.9',
      reviews: 'AI Generated',
      difficulty: 'Easy',
      time: '20 min',
      calories: '430 kcal',
      servings: '2 Servings',
      imageUrl: _getImageForCategory('Quick Meals', ingNames),
      description: 'A vibrant dish sautéed with $ingredientsList and fragrant herbs.',
      ingredients: ingredients.map((item) => IngredientItem(name: item, amount: '1 portion')).toList(),
      steps: [
        CookingStep(
          number: 1,
          title: 'Prep Ingredients',
          instruction: 'Chop and season your fresh ingredients with olive oil, salt, and pepper.',
          timerSeconds: 240,
        ),
        CookingStep(
          number: 2,
          title: 'Sauté to Perfection',
          instruction: 'Heat a heavy skillet over medium-high heat and sear ingredients until aromatic and golden.',
          timerSeconds: 480,
        ),
        CookingStep(
          number: 3,
          title: 'Garnish & Enjoy',
          instruction: 'Plate immediately with fresh herbs or cheese of your choice.',
          timerSeconds: 60,
        ),
      ],
    );
  }
}
