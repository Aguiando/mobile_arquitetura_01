import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../services/providers.dart';
import '../widgets/floating_home_button.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(product.id.toString());

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
                .toggle(product.id.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductFormScreen(product: product),
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
            Text(
              product.title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.network(
                product.thumbnail,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(product.rating.toStringAsFixed(1)),
                const SizedBox(width: 8),
                Text(
                  '(${product.rating} avaliações)',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Categoria: ${product.category}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: const FloatingHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}