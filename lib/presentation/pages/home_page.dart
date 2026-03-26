import 'package:flutter/material.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class HomePage extends StatelessWidget {
  final ProductViewModel viewModel;
  
  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                viewModel.loadProducts();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      viewModel: viewModel,
                    ),
                  ),
                );
              },
              label: const Text('Abrir lista de itens'),
              icon: const Icon(Icons.download),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class FloatingHomeButton extends StatelessWidget {
  const FloatingHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (HomePage) => false,
        );
      },
      child: const Icon(Icons.home),
      tooltip: 'Ir para Home',
    );
  }
}