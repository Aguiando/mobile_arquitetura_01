import 'package:flutter/material.dart';
import '../widgets/floating_home_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Bem-vindo à Product App!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/products'),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Abrir lista de produtos'),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}