class ProductModel {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String category;
  final double rating;
  bool favorite;

  ProductModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.rating,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'description': description,
      'thumbnail': thumbnail,
      'category': category,
      'rating': rating,
    };
  }
}
