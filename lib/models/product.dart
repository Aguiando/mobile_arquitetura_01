class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;
  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.favorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'stock': stock,
      'thumbnail': thumbnail,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    double? price,
    double? rating,
    int? stock,
    String? thumbnail,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      thumbnail: thumbnail ?? this.thumbnail,
      favorite: favorite ?? this.favorite,
    );
  }
}