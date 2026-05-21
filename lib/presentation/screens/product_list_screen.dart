import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers.dart';
import '../widgets/floating_home_button.dart';
import '../widgets/product_card.dart';
import 'product_page.dart';
import 'product_form_screen.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: () => ref.read(productsProvider.notifier).reload(),
          ),
        ],
      ),
      body: asyncProducts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Erro: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(productsProvider.notifier).reload(),
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }
          return ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemBuilder: (context, index) {
              final product = products[index];
              final isFav = favorites.contains(product.id.toString());
              return ProductCard(
                product: product,
                isFavorite: isFav,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                ),
                onFavorite: () => ref
                    .read(favoritesProvider.notifier)
                    .toggle(product.id.toString()),
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductFormScreen(product: product),
                  ),
                ),
                onDelete: () => _confirmDelete(context, ref, product.id!),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add_btn',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductFormScreen()),
            ),
            tooltip: 'Adicionar produto',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          const FloatingHomeButton(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir produto'),
        content:
            const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ref.read(productsProvider.notifier).delete(id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}