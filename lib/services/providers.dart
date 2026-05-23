import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../session/session_controller.dart';
import 'product_service.dart';
 
// ── Favorites ────────────────────────────────────────────────────────────────
 
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});
 
  void toggle(String id) {
    state = state.contains(id) ? (state..remove(id)) : {...state, id};
  }
}
 
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (_) => FavoritesNotifier(),
);
 
// ── Products ──────────────────────────────────────────────────────────────────
 
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _service;
  final String? _token;
 
  ProductsNotifier(this._service, this._token) : super(const AsyncLoading()) {
    _load();
  }
 
  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final products = await _service.fetchProducts(token: _token);
      state = AsyncData(products);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
 
  Future<void> reload() => _load();
 
  Future<void> add(Product product) async {
    final created = await _service.addProduct(product, token: _token);
    state.whenData((list) => state = AsyncData([...list, created]));
  }
 
  Future<void> update(List<Product> Function(List<Product>) updater) async {
    state.whenData((list) => state = AsyncData(updater(list)));
  }
 
  Future<void> delete(int id) async {
    await _service.deleteProduct(id, token: _token);
    state.whenData(
      (list) => state = AsyncData(list.where((p) => p.id != id).toList()),
    );
  }
}
 
final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final token = SessionController.instance.token;
  return ProductsNotifier(ProductService(), token);
});