class Product {
  final String id;
  final String name;
  final String vehicle; // e.g., "Toyota Corolla 2015-2018"
  final double price;
  final double? oldPrice;
  final double rating; // 0..5
  final String imageUrl;
  final String vendor; // e.g., "Autozone El Salvador"
  final String deliveryEta; // human text like "1 - 2 horas"
  final Map<String, String> attributes; // altura, diametro, rosca, tipo

  const Product({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.imageUrl,
    required this.vendor,
    required this.deliveryEta,
    this.attributes = const {},
  });
}
