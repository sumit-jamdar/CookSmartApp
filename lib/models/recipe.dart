class IngredientItem {
  final String name;
  final String amount;
  bool isChecked;

  IngredientItem({
    required this.name,
    required this.amount,
    this.isChecked = false,
  });

  IngredientItem copyWith({String? name, String? amount, bool? isChecked}) {
    return IngredientItem(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class CookingStep {
  final int number;
  final String title;
  final String instruction;
  final int timerSeconds;

  CookingStep({
    required this.number,
    required this.title,
    required this.instruction,
    required this.timerSeconds,
  });
}

class Recipe {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String time;
  final String calories;
  final String servings;
  final String rating;
  final String reviews;
  final String difficulty;
  final String description;
  final List<IngredientItem> ingredients;
  final List<CookingStep> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.time,
    required this.calories,
    required this.servings,
    required this.rating,
    required this.reviews,
    required this.difficulty,
    required this.description,
    required this.ingredients,
    required this.steps,
  });
}
