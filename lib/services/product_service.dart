import 'dart:convert';
import '../models/product.dart';
import 'http_helper.dart';
 
class ProductService {
  /// GET /products — lista todos os produtos
  Future<List<Product>> fetchProducts({String? token}) async {
    final response = await HttpHelper.get(
      '/products',
      token: token,
      queryParams: {'limit': '100'},
    );
 
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = json['products'] as List<dynamic>;
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Falha ao carregar produtos (${response.statusCode}).');
    }
  }
 
  /// GET /products/{id} — detalhes de um produto
  Future<Product> fetchProduct(int id, {String? token}) async {
    final response = await HttpHelper.get('/products/$id', token: token);
 
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Produto não encontrado.');
    }
  }
 
  /// POST /products/add
  Future<Product> addProduct(Product product, {String? token}) async {
    final response = await HttpHelper.post(
      '/products/add',
      token: token,
      body: product.toJson(),
    );
 
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Falha ao criar produto.');
    }
  }
 
  /// PUT /products/{id}
  Future<Product> updateProduct(Product product, {String? token}) async {
    final response = await HttpHelper.put(
      '/products/${product.id}',
      token: token,
      body: product.toJson(),
    );
 
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Falha ao atualizar produto.');
    }
  }
 
  /// DELETE /products/{id}
  Future<void> deleteProduct(int id, {String? token}) async {
    final response = await HttpHelper.delete('/products/$id', token: token);
 
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir produto.');
    }
  }
}