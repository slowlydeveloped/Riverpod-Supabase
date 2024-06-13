class AvailableStockModel {
  final String itemName;
  final double inwardStock;
  final double outwardStock;
  final double remainingStock;

  AvailableStockModel({
    required this.itemName,
    required this.inwardStock,
    required this.outwardStock,
    required this.remainingStock,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items_name': itemName,
      'inward_stock': inwardStock,
      'outward_stock': outwardStock,
      'remainig_stock': remainingStock,
    };
  }

  factory AvailableStockModel.fromJson(Map<String, dynamic> map) {
    return AvailableStockModel(
      itemName: map['items_name'] as String,
      inwardStock: map['inward_stock'] as double,
      outwardStock: map['outward_stock'] as double,
      remainingStock: map['remainig_stock'] as double,
    );
  }
}
