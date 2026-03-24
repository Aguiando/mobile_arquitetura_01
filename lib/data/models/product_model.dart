class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;
  //final String rating;
  bool favorite = false;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    //required this.rating,
    this.favorite = false,
  
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: json["price"].toDouble(),
      category: json["category"],
      //rating: json["rating"],
      image: json["image"],
    );
  }
}