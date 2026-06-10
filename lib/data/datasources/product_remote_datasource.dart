import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['products'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na conexao: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao carregar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na conexao: $e');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao criar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao criar produto: $e');
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao atualizar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao atualizar produto: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Erro ao deletar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao deletar produto: $e');
    }
  }
}
