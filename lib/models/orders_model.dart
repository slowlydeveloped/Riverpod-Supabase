// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final double totalPrice;

  OrderModel({required this.totalPrice});

  Map<String, dynamic> toJson() {
    return {
      'total_price': totalPrice,
    };
  }
}

class OrderItemModel {
  int? orderId;
  final int recipeId;
  final int quantity;
  final int price;
  final String? recipeName;

  OrderItemModel({
    this.orderId,
    required this.recipeId,
    required this.quantity,
    required this.price,
    this.recipeName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': orderId,
      'recipe_id': recipeId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> map) {
    return OrderItemModel(
      orderId: map['order_id'] != null ? map['order_id'] as int : null,
      recipeId: map['recipe_id'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
    );
  }

  OrderItemModel copyWith({
    int? orderId,
    int? recipeId,
    int? quantity,
    int? price,
    String? recipeName,
  }) {
    return OrderItemModel(
      orderId: orderId ?? this.orderId,
      recipeId: recipeId ?? this.recipeId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      recipeName: recipeName ?? this.recipeName,
    );
  }
}
