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
                title: Text("Tela inicial"),
            ),
            body: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                  ),
                  onPressed: () {
                    viewModel.loadProducts();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(viewModel: viewModel),
                      ),
                    );
                  },
                  label: const Text('Abir lista de itens'),
                  icon: const Icon(Icons.download),
                ),
            ),
        );
    }
}