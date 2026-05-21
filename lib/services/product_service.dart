import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/products';
  
  // In-memory cache
  List<Product>? _cache;

  ProductService({http.Client? client}) : client = client ?? http.Client();

  // ---------- GET (Lista de Produtos) ----------

  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['products'];
        final products = productsJson.map((item) => Product.fromJson(item)).toList();
        
        _cache = products;
        return products;
      }
      
      throw Exception('Erro ao carregar produtos: ${response.statusCode}');
    } catch (e) {
      if (_cache != null && _cache!.isNotEmpty) return _cache!;
      throw Exception('Falha na conexão: $e');
    }
  }

  // ---------- GET (Produto por ID) ----------

  Future<Product> getProductById(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      }
      
      throw Exception('Erro ao carregar produto: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // ---------- GET (Buscar produtos por categoria) ----------

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/category/$category'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((item) => Product.fromJson(item)).toList();
      }
      
      throw Exception('Erro ao carregar produtos da categoria: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // ---------- GET (Buscar produtos com termo) ----------

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/search?q=$query'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((item) => Product.fromJson(item)).toList();
      }
      
      throw Exception('Erro ao buscar produtos: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // ---------- POST (Adicionar Produto - simulado) ----------

  Future<Product> addProduct(Product product) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final created = Product.fromJson(jsonDecode(response.body));
        
        // Update cache
        if (_cache != null) {
          _cache = [..._cache!, created];
        }
        
        return created;
      }
      
      throw Exception('Erro ao criar produto: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha ao criar produto: $e');
    }
  }

  // ---------- PUT (Atualizar Produto) ----------

  Future<Product> updateProduct(Product product) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      
      if (response.statusCode == 200) {
        final updated = Product.fromJson(jsonDecode(response.body));
        
        // Update cache
        if (_cache != null) {
          final idx = _cache!.indexWhere((p) => p.id == updated.id);
          if (idx != -1) {
            _cache = List.from(_cache!)..[idx] = updated;
          }
        }
        
        return updated;
      }
      
      throw Exception('Erro ao atualizar produto: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha ao atualizar produto: $e');
    }
  }

  // ---------- DELETE (Deletar Produto) ----------

  Future<void> deleteProduct(int id) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode == 200) {
        // Remove from cache
        _cache?.removeWhere((p) => p.id == id);
        return;
      }
      
      throw Exception('Erro ao deletar produto: ${response.statusCode}');
    } catch (e) {
      throw Exception('Falha ao deletar produto: $e');
    }
  }

  // ---------- Métodos Utilitários ----------

  // Limpar cache
  void clearCache() {
    _cache = null;
  }

  // Obter cache atual
  List<Product>? getCache() => _cache;

  // Fechar client
  void dispose() {
    client.close();
  }
}