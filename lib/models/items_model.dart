// ignore_for_file: non_constant_identifier_names

class ItemModel {
  final String items_name;
  final double items_price;
  final double items_quantity;
  final int vendor_id;
  final String? vendorname;

  ItemModel({
    required this.items_name,
    required this.items_price,
    required this.items_quantity,
    required this.vendor_id,
    this.vendorname,
  });
  

  ItemModel copyWith({
    String? items_name,
    double? items_price,
    double? items_quantity,
    int? vendor_id,
    String? vendorname,
  }) {
    return ItemModel(
      items_name: items_name ?? this.items_name,
      items_price: items_price ?? this.items_price,
      items_quantity: items_quantity ?? this.items_quantity,
      vendor_id: vendor_id ?? this.vendor_id,
      vendorname: vendorname ?? this.vendorname,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items_name': items_name,
      'items_price': items_price,
      'items_quantity': items_quantity,
      'vendor_id': vendor_id,
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> map) {
    return ItemModel(
      items_name: map['items_name'] as String,
      items_price: (map['items_price'] as num).toDouble(),  // Ensure double conversion
      items_quantity: (map['items_quantity'] as num).toDouble(),  // Ensure double conversion
      vendor_id: map['vendor_id'] as int,
     
    );
  }
}
