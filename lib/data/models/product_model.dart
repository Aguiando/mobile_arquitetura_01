class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool favorite = false;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.favorite = false,
  
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: json["price"].toDouble(),
      image: json["image"],
    );
  }
}