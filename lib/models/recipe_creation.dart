class RecipeCreationModel {
  int? recipeId;
  final String recipeName;
  final String itemName;
  final double itemQuantity;

  RecipeCreationModel({
    this.recipeId,
    required this.recipeName,
    required this.itemName,
    required this.itemQuantity, 
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'recipe_name': recipeName,
      'item_name': itemName,
      'item_quantity': itemQuantity,
    };
  }

  factory RecipeCreationModel.fromJson(Map<String, dynamic> map) {
    return RecipeCreationModel(
      recipeName: map['recipe_name'] as String,
      itemName: map['item_name'] as String,
      itemQuantity: map['item_quantity'] as double,
    );
  }

  RecipeCreationModel copyWith({
    String? recipeName,
    String? itemName,
    double? itemQuantity,
  }) {
    return RecipeCreationModel(
      recipeName: recipeName ?? this.recipeName,
      itemName: itemName ?? this.itemName,
      itemQuantity: itemQuantity ?? this.itemQuantity,
    );
  }
}
