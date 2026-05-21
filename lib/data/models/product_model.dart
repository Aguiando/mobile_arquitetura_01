class ProductModel {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rate;
  final int ratingCount;
  bool favorite;

  ProductModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rate,
    required this.ratingCount,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: (json["price"] as num).toDouble(),
      category: json["category"],
      rate: (json["rating"]["rate"] as num).toDouble(),
      ratingCount: json["rating"]["count"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}