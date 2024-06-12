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
  final int itemId;
  final int quantity;
  final int price;
  final String? recipeName;

  OrderItemModel({
    this.orderId,
    required this.itemId,
    required this.quantity,
    required this.price,
    this.recipeName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': orderId,
      'item_id': itemId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> map) {
    return OrderItemModel(
      orderId: map['order_id'] != null ? map['order_id'] as int : null,
      itemId: map['item_id'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
    );
  }

  OrderItemModel copyWith({
    int? orderId,
    int? itemId,
    int? quantity,
    int? price,
    String? recipeName,
  }) {
    return OrderItemModel(
      orderId: orderId ?? this.orderId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      recipeName: recipeName ?? this.recipeName,
    );
  }
}
