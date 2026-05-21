import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/product_service.dart';

// ── Service ──────────────────────────────────────────────────────────────────

final productServiceProvider = Provider<ProductService>((_) => ProductService());

// ── Products (AsyncNotifier) ──────────────────────────────────────────────────

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return ref.read(productServiceProvider).fetchProducts();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productServiceProvider).fetchProducts(),
    );
  }

  Future<void> add(Product product) async {
    final service = ref.read(productServiceProvider);
    final created = await service.addProduct(product);
    state = AsyncData([...state.value ?? [], created]);
  }

  Future<void> updateProduct(Product product) async {
    final service = ref.read(productServiceProvider);
    final updated = await service.updateProduct(product);
    state = AsyncData(
      state.value!.map((p) => p.id == updated.id ? updated : p).toList(),
    );
  }

  Future<void> delete(int id) async {
    await ref.read(productServiceProvider).deleteProduct(id);
    state = AsyncData(state.value!.where((p) => p.id != id).toList());
  }

  void toggleFavorite(int id) {
    state = AsyncData(
      state.value!.map((p) {
        return p.id == id ? p.copyWith(favorite: !p.favorite) : p;
      }).toList(),
    );
  }
}

final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

// ── Favorites ─────────────────────────────────────────────────────────────────

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (_) => FavoritesNotifier(),
);