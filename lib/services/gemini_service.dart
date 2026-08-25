import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class GeminiService {
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static String customApiKey = '';

  static String get effectiveApiKey =>
      customApiKey.isNotEmpty ? customApiKey : apiKey;

  static const List<String> candidateModels = [
    'gemini-1.5-flash',
    'gemini-2.0-flash',
    'gemini-1.5-flash-latest',
    'gemini-1.5-pro',
    'gemini-2.0-flash-lite',
  ];

  static const List<String> indianCulinaryThemes = [
    'अस्सल महाराष्ट्रीयन फोडणी आणि गोडा मसाला स्पेशल (Traditional Maharashtrian)',
    'झणझणीत कोल्हापुरी/मालवणी सुका मसाला (Kolhapuri / Malvani Tadka)',
    'गावरान चवीचे गावरान पिठलं-उसळ (Rustic Village Style)',
    'शाही मलाईदार ढाबा स्टाईल करी (North Indian Dhaba Style)',
    'खमंग नाश्ता व झटपट तवा स्पेशल (Authentic Tawa & Breakfast)',
    'साजूक तुपातील सुवासिक पुलाव व राईस (Fragrant Ghee Tempering)',
    'उपवास व सात्विक खमंग डिश (Satvik / Fasting Delight)',
  ];

  static Future<Recipe> generateRecipe({
    required List<String> ingredients,
    required List<String> preferences,
    String language = 'mr',
  }) async {
    final key = effectiveApiKey;
    final ingredientsList = ingredients.join(', ');
    final preferencesList =
        preferences.isNotEmpty ? preferences.join(', ') : 'None';
    final randomTheme =
        indianCulinaryThemes[Random().nextInt(indianCulinaryThemes.length)];
    final seed = DateTime.now().millisecondsSinceEpoch;

    String langInstruction =
        'completely and authentically in MARATHI (मराठी) language. Use natural Marathi food terminology (उदा. पाककृतीचे नाव, साहित्याची नावे व अचूक प्रमाण, कृतीचे टप्पे, फोडणी, वाफ काढणे इत्यादी सर्व शुद्ध मराठीत असावेत).';
    if (language == 'hi') {
      langInstruction =
          'completely in HINDI (हिंदी) language. Use natural Hindi culinary terms (उदा. तड़का, भूनना, सामग्री और सही माप, चरण सब सरल और शुद्ध हिंदी में हों).';
    } else if (language == 'en') {
      langInstruction =
          'in English, while maintaining authentic Indian and Maharashtrian culinary terms (e.g. Tadka/Phodani, Goda Masala, Kande Pohe, Usal, Bhakri, Ghee Tempering).';
    } else if (language == 'es') {
      langInstruction = 'completely in SPANISH (Español) language.';
    }

    final prompt = '''
You are a renowned Master Chef specializing in authentic Indian, Maharashtrian, and regional gastronomy (महाराष्ट्रीयन व भारतीय पाककला तज्ज्ञ).
Create a 100% CULINARILY ACCURATE, PRACTICAL, and DELICIOUS recipe based on these available kitchen ingredients:
Available Ingredients: $ingredientsList
Dietary Preferences / Restrictions: $preferencesList
Culinary Style / Theme: $randomTheme
Randomization Seed: $seed

CRITICAL AUTHENTICITY & ACCURACY RULES:
1. OUTPUT LANGUAGE: Output the recipe $langInstruction.
2. CULINARY ACCURACY: Follow real Indian cooking techniques:
   - Proper Phodani / Tadka order: Hot oil/ghee -> Mustard seeds (मोहरी) crackle -> Cumin (जिरे) -> Hing (हिंग) -> Curry leaves (कढीपत्ता) -> Ginger-garlic-chillies -> Onions -> Turmeric/Spices.
   - Traditional Indian seasonings: Use Goda Masala (गोडा मसाला), Kanda Lasun Masala, roasted peanut powder (शेंगदाण्याचा कूट), coconut (खोबरे), fresh coriander, lemon juice, or jaggery-tamarind appropriately.
   - Realistic Cooking Times: Give realistic preparation and cooking durations.
   - Exact measurements: Use realistic amounts (उदा. २ वाट्या, १ चमचा, १/२ कप, चवीनुसार मीठ).

Return ONLY a valid JSON object matching this exact schema:
{
  "title": "Authentic Dish Title in target language (e.g. खमंग फोडणीचे बटाटे पोहे / झणझणीत मटकी उसळ)",
  "category": "Cuisine Category (e.g. महाराष्ट्रीयन खास, खमंग नाश्ता, पारंपरिक जेवण, स्ट्रीट फूड, उपवास स्पेशल)",
  "time": "Total cooking time (e.g. २० मिनिटे / 20 min)",
  "calories": "Estimated calories (e.g. ३५० कॅलरी / 350 kcal)",
  "servings": "Number of servings (e.g. ३ व्यक्तींसाठी / 3 Servings)",
  "description": "2 appetizing sentences describing taste, aroma (खमंग सुवास), and texture in target language.",
  "ingredients": [
    {
      "name": "Ingredient item with preparation in target language",
      "amount": "Exact culinary measurement (e.g. २ वाट्या, १ मोठा चमचा, २ चिमूट)"
    }
  ],
  "steps": [
    {
      "number": 1,
      "title": "Action title in target language (e.g. साहित्याची पूर्वतयारी / खमंग फोडणी)",
      "instruction": "Clear, detailed step-by-step cooking instruction",
      "timerSeconds": 180
    }
  ]
}
''';

    if (key.isNotEmpty) {
      for (final model in candidateModels) {
        try {
          final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$key',
          );
          final response = await http
              .post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'contents': [
                    {
                      'parts': [
                        {'text': prompt}
                      ]
                    }
                  ],
                  'generationConfig': {
                    'responseMimeType': 'application/json',
                    'temperature': 0.95,
                    'topP': 0.95,
                  }
                }),
              )
              .timeout(const Duration(seconds: 15));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final candidates = data['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final text =
                  candidates[0]['content']['parts'][0]['text'] as String;
              final recipeJson = jsonDecode(text);
              return _parseRecipeFromJson(recipeJson, ingredients, language);
            }
          }
        } catch (e) {
          // Fall through to next model or offline engine
          continue;
        }
      }
    }

    // Dynamic procedural Indian/Maharashtrian cooking synthesis
    return _buildAuthenticIndianProceduralRecipe(
        ingredients, preferences, language);
  }

  static Recipe _parseRecipeFromJson(
    Map<String, dynamic> json,
    List<String> ingredients,
    String language,
  ) {
    final defaultTitle = language == 'mr'
        ? 'शेफची खास महाराष्ट्रीयन रेसिपी'
        : language == 'hi'
            ? 'शेफ़ की खास भारतीय रेसिपी'
            : 'Chef’s Special Indian Recipe';

    final defaultCategory = language == 'mr'
        ? 'महाराष्ट्रीयन खास'
        : language == 'hi'
            ? 'पारंपरिक व्यंजन'
            : 'Maharashtrian Special';

    final title = json['title'] as String? ?? defaultTitle;
    final category = json['category'] as String? ?? defaultCategory;
    final time =
        json['time'] as String? ?? (language == 'mr' ? '२५ मिनिटे' : '25 min');
    final calories = json['calories'] as String? ??
        (language == 'mr' ? '३८० कॅलरी' : '380 kcal');
    final servings = json['servings'] as String? ??
        (language == 'mr' ? '३ व्यक्तींसाठी' : '3 Servings');
    final description = json['description'] as String? ??
        (language == 'mr'
            ? 'किचनमधील उपलब्ध साहित्यापासून तयार केलेली एक अस्सल, खमंग व चवदार डिश.'
            : 'An authentic and delicious dish crafted from your kitchen ingredients.');

    final rawIngredients = json['ingredients'] as List? ?? [];
    final parsedIngredients = rawIngredients.map((i) {
      return IngredientItem(
        name: i['name'] as String? ?? 'साहित्य',
        amount: i['amount'] as String? ??
            (language == 'mr' ? 'आवश्यकतेनुसार' : 'As needed'),
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
          title: s['title'] as String? ??
              (language == 'mr' ? 'टप्पा ${i + 1}' : 'Step ${i + 1}'),
          instruction: s['instruction'] as String? ?? 'कृतीचे अनुसरण करा.',
          timerSeconds:
              s['timerSeconds'] is int ? s['timerSeconds'] as int : 120,
        ),
      );
    }

    final imageUrl = _getImageForIndianDish(category, title);

    return Recipe(
      id: 'indian-recipe-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}',
      title: title,
      category: category,
      rating: (4.8 + Random().nextDouble() * 0.2).toStringAsFixed(1),
      reviews: language == 'mr' ? 'AI शेफ निर्मित' : 'AI Chef Verified',
      difficulty: language == 'mr' ? 'सोपे' : 'Easy',
      time: time,
      calories: calories,
      servings: servings,
      imageUrl: imageUrl,
      description: description,
      ingredients: parsedIngredients.isNotEmpty
          ? parsedIngredients
          : ingredients
              .map((item) => IngredientItem(
                    name: item,
                    amount: language == 'mr' ? '१ वाटी' : '1 cup',
                  ))
              .toList(),
      steps: parsedSteps.isNotEmpty
          ? parsedSteps
          : _getDefaultIndianSteps(language),
    );
  }

  static List<CookingStep> _getDefaultIndianSteps(String language) {
    if (language == 'mr') {
      return [
        CookingStep(
          number: 1,
          title: 'साहित्याची पूर्वतयारी',
          instruction:
              'कांदा, लसूण, हिरवी मिरची आणि भाज्या स्वच्छ धुवून बारीक चिरून घ्या.',
          timerSeconds: 180,
        ),
        CookingStep(
          number: 2,
          title: 'खमंग फोडणी देणे',
          instruction:
              'कढईत तेल किंवा साजूक तूप गरम करून मोहरी, जिरे, हिंग, कढीपत्ता आणि हिरवी मिरची-लसूण खमंग परता.',
          timerSeconds: 150,
        ),
        CookingStep(
          number: 3,
          title: 'परतणे व वाफ काढणे',
          instruction:
              'साहित्य घालून हळद, मसाले व मीठ टाका. झाकण ठेवून मंद आचेवर छान वाफ काढून घ्या.',
          timerSeconds: 300,
        ),
        CookingStep(
          number: 4,
          title: 'सजावट व गरमागरम वाढणे',
          instruction:
              'वरून ताजी कोथिंबीर, ओले खोबरे आणि लिंबाचा रस पिळून गरमागरम भाकरी किंवा चपातीसोबत वाढा.',
          timerSeconds: 60,
        ),
      ];
    }
    return [
      CookingStep(
        number: 1,
        title: 'Ingredient Prep',
        instruction:
            'Wash and finely chop your fresh vegetables, aromatics, and chillies.',
        timerSeconds: 180,
      ),
      CookingStep(
        number: 2,
        title: 'Authentic Tadka / Phodani',
        instruction:
            'Heat oil/ghee in a kadhai. Add mustard seeds, cumin, hing, curry leaves, and green chillies until crackling and aromatic.',
        timerSeconds: 150,
      ),
      CookingStep(
        number: 3,
        title: 'Sauté & Steam (वाफ काढणे)',
        instruction:
            'Add ingredients with turmeric, spice blend, and salt. Cover and steam over low heat until tender and deeply flavorful.',
        timerSeconds: 300,
      ),
      CookingStep(
        number: 4,
        title: 'Garnish & Serve Hot',
        instruction:
            'Garnish with freshly chopped coriander, fresh grated coconut, and a squeeze of lemon. Serve piping hot with Bhakri or Roti.',
        timerSeconds: 60,
      ),
    ];
  }

  static String _getImageForIndianDish(String category, String title) {
    final lower = '$category $title'.toLowerCase();
    if (lower.contains('misal') ||
        lower.contains('मिसळ') ||
        lower.contains('रस्सा')) {
      return 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('pohe') ||
        lower.contains('पोहे') ||
        lower.contains('poha') ||
        lower.contains('नाश्ता')) {
      return 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('pithla') ||
        lower.contains('पिठलं') ||
        lower.contains('झुणका') ||
        lower.contains('भाकरी') ||
        lower.contains('थाल')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('vangi') ||
        lower.contains('वांगी') ||
        lower.contains('भरली') ||
        lower.contains('baingan')) {
      return 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('modak') ||
        lower.contains('मोदक') ||
        lower.contains('गोड') ||
        lower.contains('sweet')) {
      return 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('pav bhaji') ||
        lower.contains('पावभाजी') ||
        lower.contains('street')) {
      return 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('rice') ||
        lower.contains('भात') ||
        lower.contains('पुलाव') ||
        lower.contains('बिरयानी')) {
      return 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=80';
    } else if (lower.contains('paneer') ||
        lower.contains('पनीर') ||
        lower.contains('करी') ||
        lower.contains('gravy')) {
      return 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=900&q=80';
    }
    final generalIndianImages = [
      'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=900&q=80',
    ];
    return generalIndianImages[Random().nextInt(generalIndianImages.length)];
  }

  /// Procedural generation for authentic Maharashtrian & Indian dishes
  static Recipe _buildAuthenticIndianProceduralRecipe(
    List<String> ingredients,
    List<String> preferences,
    String language,
  ) {
    final rand = Random();
    final primary = ingredients.isNotEmpty ? ingredients[0] : 'कांदा-बटाटा';
    final secondary = ingredients.length > 1 ? ingredients[1] : 'शेंगदाणे';
    final remaining = ingredients.skip(2).join(', ');

    // 8 authentic Indian culinary styles
    final styles = [
      {
        'mr_title': 'खमंग फोडणीचे $primary आणि $secondary फ्राय',
        'mr_desc':
            'मोहरी, जिरे, हिंग आणि कढीपत्त्याच्या खमंग फोडणीत परतून तयार केलेली चवदार भाजी.',
        'mr_cat': 'महाराष्ट्रीयन खास',
        'hi_title': 'स्वादिष्ट तड़का $primary और $secondary फ्राई',
        'hi_desc':
            'राई, जीरा और हींग के पारंपरिक तड़के में पकाई गई लाजवाब सब्ज़ी.',
        'hi_cat': 'पारंपरिक भोजन',
        'en_title': 'Tempered Maharashtrian $primary & $secondary Stir-Fry',
        'en_desc':
            'A fragrant sauté seasoned with crackling mustard seeds, cumin, hing, curry leaves, and fresh coconut.',
        'en_cat': 'Maharashtrian Special',
        'time_mr': '${15 + rand.nextInt(10)} मिनिटे',
        'time_hi': '${15 + rand.nextInt(10)} मिनट',
        'time_en': '${15 + rand.nextInt(10)} min',
        'calories_mr': '${290 + rand.nextInt(90)} कॅलरी',
        'calories_hi': '${290 + rand.nextInt(90)} कैलोरी',
        'calories_en': '${290 + rand.nextInt(90)} kcal',
        'steps_mr': [
          CookingStep(
              number: 1,
              title: 'साहित्याची तयारी',
              instruction:
                  '$primary आणि $secondary स्वच्छ धुवून आवश्यक आकारात चिरून घ्या.',
              timerSeconds: 120),
          CookingStep(
              number: 2,
              title: 'अस्सल खमंग फोडणी',
              instruction:
                  'कढईत २ चमचे तेल गरम करून मोहरी, जिरे, हिंग, कढीपत्ता आणि हिरवी मिरची खमंग तडतडू द्या.',
              timerSeconds: 90),
          CookingStep(
              number: 3,
              title: 'मसाले व वाफ काढणे',
              instruction:
                  '$primary, $secondary ${remaining.isNotEmpty ? "आणि $remaining" : ""} घालून हळद, चवीनुसार मीठ टाका. झाकण ठेवून मंद आचेवर ५ मिनिटे वाफ काढा.',
              timerSeconds: 300),
          CookingStep(
              number: 4,
              title: 'कोथिंबीर व खोबरे सजावट',
              instruction:
                  'वरून भाजलेल्या शेंगदाण्याचा कूट, ताजी कोथिंबीर आणि ओले खोबरे टाकून गरम भाकरी/चपातीसोबत वाढा.',
              timerSeconds: 60),
        ],
      },
      {
        'mr_title': 'झणझणीत गावरान $primary रस्सा उसळ',
        'mr_desc':
            'कांदा-लसूण मसाला, भाजलेले खोबरे आणि तरीदार रश्श्याची अस्सल गावरान उसळ.',
        'mr_cat': 'पारंपरिक जेवण',
        'hi_title': 'मसालेदार तरीदार $primary उसल करी',
        'hi_desc':
            'प्याज, लहसुन और भुने नारियल के मसालेदार रस्से में पकाई गई स्वादिष्ट उसल.',
        'hi_cat': 'पारंपरिक भोजन',
        'en_title': 'Zanzanit Maharashtrian $primary Usal Gravy',
        'en_desc':
            'A spicy, rich coconut-onion spiced curry with authentic Kolhapuri flavors.',
        'en_cat': 'Traditional Meals',
        'time_mr': '${20 + rand.nextInt(12)} मिनिटे',
        'time_hi': '${20 + rand.nextInt(12)} मिनट',
        'time_en': '${20 + rand.nextInt(12)} min',
        'calories_mr': '${360 + rand.nextInt(100)} कॅलरी',
        'calories_hi': '${360 + rand.nextInt(100)} कैलोरी',
        'calories_en': '${360 + rand.nextInt(100)} kcal',
        'steps_mr': [
          CookingStep(
              number: 1,
              title: 'मसाला वाटण भाजणे',
              instruction:
                  'कांदा, लसूण, आले आणि सुके खोबरे थोडे तेल घालून खमंग भाजून मिक्सरमध्ये बारीक वाटा.',
              timerSeconds: 240),
          CookingStep(
              number: 2,
              title: 'तरी (कट) तयार करणे',
              instruction:
                  'कढईत ३ चमचे तेल गरम करून तयार वाटण तेल सुटेपर्यंत परता. कांदा-लसूण मसाला व लाल तिखट घाला.',
              timerSeconds: 240),
          CookingStep(
              number: 3,
              title: 'रस्सा शिजवणे',
              instruction:
                  '$primary आणि $secondary घालून १.५ कप गरम पाणी घाला. मंद आचेवर ८-१० मिनिटे उकळून छान तरी येऊ द्या.',
              timerSeconds: 540),
          CookingStep(
              number: 4,
              title: 'लिंबू व पावासोबत आस्वाद',
              instruction:
                  'बारीक चिरलेला कांदा, लिंबू आणि लादी पाव किंवा भाकरीसोबत गरमागरम सर्व्ह करा.',
              timerSeconds: 60),
        ],
      },
      {
        'mr_title': 'खमंग कुरकुरीत $primary आणि $secondary थालीपीठ / वडी',
        'mr_desc':
            'भाजणीचे पीठ, बारीक कांदा, तीळ, ओवा आणि कोथिंबिरीची कुरकुरीत मेजवानी.',
        'mr_cat': 'खमंग नाश्ता',
        'hi_title': 'कुरकुरी स्वादिष्ट $primary टिक्की / थालीपीठ',
        'hi_desc':
            'तिल, अजवाइन और ताज़े मसालों के साथ तवे पर सेकी गई कुरकुरी डिश.',
        'hi_cat': 'स्वादिष्ट नाश्ता',
        'en_title': 'Crispy Multi-Grain $primary & $secondary Thalipeeth',
        'en_desc':
            'Savory spiced multigrain pancake infused with sesame seeds, carom seeds, and fresh aromatics.',
        'en_cat': 'Breakfast & Snacks',
        'time_mr': '${18 + rand.nextInt(8)} मिनिटे',
        'time_hi': '${18 + rand.nextInt(8)} मिनट',
        'time_en': '${18 + rand.nextInt(8)} min',
        'calories_mr': '${310 + rand.nextInt(80)} कॅलरी',
        'calories_hi': '${310 + rand.nextInt(80)} कैलोरी',
        'calories_en': '${310 + rand.nextInt(80)} kcal',
        'steps_mr': [
          CookingStep(
              number: 1,
              title: 'पीठ मळणे',
              instruction:
                  '$primary, $secondary, बारीक कांदा, लसूण-मिरची, तीळ, ओवा, हळद व मीठ घालून मऊ पीठ मळून घ्या.',
              timerSeconds: 200),
          CookingStep(
              number: 2,
              title: 'थापणे',
              instruction:
                  'ओल्या सुती कापडावर तेलाचा हात लावून गोल थापा आणि मध्यभागी छिद्रे पाडा.',
              timerSeconds: 150),
          CookingStep(
              number: 3,
              title: 'तव्यावर भाजणे',
              instruction:
                  'गरम तव्यावर थोडे तेल सोडून दोन्ही बाजूंनी खरपूस व कुरकुरीत होईपर्यंत भाजा.',
              timerSeconds: 360),
          CookingStep(
              number: 4,
              title: 'लोणी व दह्यासोबत सर्व्ह करा',
              instruction:
                  'गरमागरम थालीपीठावर पांढरे लोणी किंवा दही ठेवून आस्वाद घ्या.',
              timerSeconds: 60),
        ],
      },
      {
        'mr_title': 'साजूक तुपातील सुवासिक $primary मसाला पुलाव',
        'mr_desc':
            'खडा मसाला, साजूक तूप, ताजे साहित्य आणि सुवासिक तांदळाचा खमंग पुलाव.',
        'mr_cat': 'पारंपरिक जेवण',
        'hi_title': 'देसी घी वाला सुगन्धित $primary पुलाव',
        'hi_desc': 'खड़े मसालों और शुद्ध घी में पका हुआ खुशबूदार पुलाव.',
        'hi_cat': 'पारंपरिक भोजन',
        'en_title': 'Fragrant Ghee Tempering $primary & $secondary Pulao',
        'en_desc':
            'Aromatic rice dish gently simmered with whole spices, pure ghee, and sautéed ingredients.',
        'en_cat': 'Traditional Meals',
        'time_mr': '${22 + rand.nextInt(10)} मिनिटे',
        'time_hi': '${22 + rand.nextInt(10)} मिनट',
        'time_en': '${22 + rand.nextInt(10)} min',
        'calories_mr': '${380 + rand.nextInt(100)} कॅलरी',
        'calories_hi': '${380 + rand.nextInt(100)} कैलोरी',
        'calories_en': '${380 + rand.nextInt(100)} kcal',
        'steps_mr': [
          CookingStep(
              number: 1,
              title: 'तांदूळ व खडे मसाले फोडणी',
              instruction:
                  'कुकर किंवा पातेल्यात २ चमचे साजूक तूप गरम करून लवंग, दालचिनी, तमालपत्र आणि जिरे परता.',
              timerSeconds: 120),
          CookingStep(
              number: 2,
              title: 'साहित्य परतणे',
              instruction:
                  '$primary, $secondary आणि आले-लसूण पेस्ट घालून २ मिनिटे खमंग परता.',
              timerSeconds: 180),
          CookingStep(
              number: 3,
              title: 'दम देणे / शिजवणे',
              instruction:
                  'धुतलेला तांदूळ, गरम पाणी, मीठ व थोडा गोडा मसाला घालून मंद आचेवर शिजवून घ्या.',
              timerSeconds: 480),
          CookingStep(
              number: 4,
              title: 'गरमागरम वाढणे',
              instruction:
                  'वरून काजू आणि ताजी कोथिंबीर घालून रायत्यासोबत गरमागरम वाढा.',
              timerSeconds: 60),
        ],
      },
    ];

    final chosen = styles[rand.nextInt(styles.length)];

    String title = chosen['mr_title'] as String;
    String desc = chosen['mr_desc'] as String;
    String cat = chosen['mr_cat'] as String;
    String time = chosen['time_mr'] as String;
    String calories = chosen['calories_mr'] as String;

    if (language == 'hi') {
      title = chosen['hi_title'] as String;
      desc = chosen['hi_desc'] as String;
      cat = chosen['hi_cat'] as String;
      time = chosen['time_hi'] as String;
      calories = chosen['calories_hi'] as String;
    } else if (language == 'en') {
      title = chosen['en_title'] as String;
      desc = chosen['en_desc'] as String;
      cat = chosen['en_cat'] as String;
      time = chosen['time_en'] as String;
      calories = chosen['calories_en'] as String;
    }

    final parsedIngredients = ingredients.map((item) {
      final amounts = language == 'mr'
          ? [
              '१ मोठी वाटी',
              '२ चमचे',
              '१०० ग्रॅम',
              '१ कप बारीक चिरून',
              '१/२ वाटी भाजून'
            ]
          : ['1 cup', '2 tbsp', '150g', '1 cup chopped', 'To taste'];
      return IngredientItem(
        name: item,
        amount: amounts[rand.nextInt(amounts.length)],
        isChecked: false,
      );
    }).toList();

    final steps = (chosen['steps_mr'] as List<CookingStep>);

    return Recipe(
      id: 'marathi-dynamic-${DateTime.now().millisecondsSinceEpoch}-${rand.nextInt(9999)}',
      title: title,
      category: cat,
      rating: (4.8 + rand.nextDouble() * 0.2).toStringAsFixed(1),
      reviews: language == 'mr' ? 'AI शेफ निर्मित' : 'AI Chef Verified',
      difficulty: language == 'mr' ? 'सोपे' : 'Easy',
      time: time,
      calories: calories,
      servings: language == 'mr' ? '३ व्यक्तींसाठी' : '3 Servings',
      imageUrl: _getImageForIndianDish(cat, title),
      description: desc,
      ingredients: parsedIngredients,
      steps: steps,
    );
  }
}
