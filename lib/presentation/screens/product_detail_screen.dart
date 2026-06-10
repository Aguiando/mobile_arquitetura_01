import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/providers.dart';
import '../../session/session_controller.dart';
import 'product_form_screen.dart';

final _productDetailProvider =
    FutureProvider.family<Product, int>((ref, id) async {
  final token = SessionController.instance.token;
  return ProductService().fetchProduct(id, token: token);
});

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(_productDetailProvider(product.id!));
    final favorites = ref.watch(favoritesProvider);

    return asyncProduct.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Detalhes do Produto')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Produto'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'Erro ao carregar produto:\n$err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.invalidate(_productDetailProvider(product.id!)),
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
      data: (p) {
        final isFav = favorites.contains(p.id.toString());
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do Produto'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null),
                tooltip: 'Favoritar',
                onPressed: () => ref
                    .read(favoritesProvider.notifier)
                    .toggle(p.id.toString()),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Editar',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductFormScreen(product: p),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Center(
                  child: Image.network(
                    p.thumbnail,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'R\$ ${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(p.rating.toStringAsFixed(1)),
                    const SizedBox(width: 8),
                    if (p.stock != null)
                      Text('${p.stock} em estoque',
                          style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                if (p.brand != null)
                  Text('Marca: ${p.brand}',
                      style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Categoria: ${p.category}',
                      style: const TextStyle(fontSize: 13)),
                ),
                const SizedBox(height: 16),
                const Text('Descricao',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(p.description,
                    style: const TextStyle(fontSize: 14, height: 1.5)),
                if (p.images.length > 1) ...[
                  const SizedBox(height: 16),
                  const Text('Galeria',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: p.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          p.images[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}
