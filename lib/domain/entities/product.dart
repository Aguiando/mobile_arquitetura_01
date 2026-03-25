class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final double rate;
  final int ratingCount;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.rate,
    required this.ratingCount,
    required this.image,
  });
}