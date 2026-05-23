class Product {
  final int? id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final String category;
  final List<String> images;
  final int? stock;
  final String? brand;
 
  const Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.category,
    this.images = const [],
    this.stock,
    this.brand,
  });
 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
      category: json['category'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      stock: json['stock'] as int?,
      brand: json['brand'] as String?,
    );
  }
 
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'price': price,
        'rating': rating,
        'thumbnail': thumbnail,
        'category': category,
        'images': images,
        if (stock != null) 'stock': stock,
        if (brand != null) 'brand': brand,
      };
 
  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    double? rating,
    String? thumbnail,
    String? category,
    List<String>? images,
    int? stock,
    String? brand,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
    );
  }
}