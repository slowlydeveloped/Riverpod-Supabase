class VendorModel {
  final String name;
  final String number;

  VendorModel({
    required this.name,
    required this.number,
  });

  VendorModel copyWith({
    String? name,
    String? number,
  }) {
    return VendorModel(
      name: name ?? this.name,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'vendorsname': name,
      'vendors_number': number,
    };
  }

  factory VendorModel.fromJson(Map<String, dynamic> map) {
    return VendorModel(
      name: map['vendorsname'] as String,
      number: map['vendors_number'] as String,
    );
  }
}
