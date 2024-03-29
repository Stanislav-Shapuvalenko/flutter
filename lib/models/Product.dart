class Product {
  final int id;
  final String name;
  final String countryName;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.countryName,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      countryName: json['country_name'],
      quantity: int.parse(json['quantity'])
    );
  }
}