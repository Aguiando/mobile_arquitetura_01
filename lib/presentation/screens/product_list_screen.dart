import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers.dart';
import '../../session/session_controller.dart';
import '../widgets/product_card.dart';
import 'login_page.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'profile_screen.dart';
 
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider);
    final favorites = ref.watch(favoritesProvider);
    final user = SessionController.instance.currentUser;
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        actions: [
          // Foto do usuário no AppBar + menu
          if (user != null)
            PopupMenuButton<String>(
              tooltip: 'Menu do usuário',
              offset: const Offset(0, 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: user.image.isNotEmpty
                          ? NetworkImage(user.image)
                          : null,
                      child: user.image.isEmpty
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text(user.firstName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              onSelected: (value) async {
                if (value == 'profile') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()));
                } else if (value == 'logout') {
                  await SessionController.instance.logout();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  );
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(children: const [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Meu Perfil'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          // Botão de recarregar manualmente
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
                onPressed: () => ref.read(productsProvider.notifier).reload(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        tooltip: 'Adicionar produto',
        child: const Icon(Icons.add),
      ),
    );
  }
 
  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir produto'),
        content: const Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
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