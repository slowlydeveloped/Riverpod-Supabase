
class RecipeModel {
  final String recipeName;
  final int recipePrice;
  final double? usedItemQuantity;
  final String? itemName;

  RecipeModel(
      {required this.recipeName,
      required this.recipePrice,
      this.usedItemQuantity,
      this.itemName});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'recipe_name': recipeName,
      'recipe_price': recipePrice,
    };
  }

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      recipeName: map['recipe_name'] as String,
      recipePrice: map['recipe_price'] as int,
    );
  }

  

  RecipeModel copyWith({
    String? recipeName,
    int? recipePrice,
    double? usedItemQuantity,
    String? itemName,
  }) {
    return RecipeModel(
      recipeName: recipeName ?? this.recipeName,
      recipePrice: recipePrice ?? this.recipePrice,
      usedItemQuantity: usedItemQuantity ?? this.usedItemQuantity,
      itemName: itemName ?? this.itemName,
    );
  }
}
