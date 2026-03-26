import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_imp.dart';
import 'package:product_app/presentation/pages/home_page.dart';
import 'package:product_app/presentation/pages/product_detail_page.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

void main() {
  final cache = ProductCacheDatasource();
  final remote = ProductRemoteDatasource(http.Client());
  final repository = ProductRepositoryImpl(remote, cache);
  final viewModel = ProductViewModel(repository);

  runApp(
    ProviderScope(
      child: MyApp(viewModel: viewModel),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(viewModel: viewModel),
        '/products': (context) => ProductPage(viewModel: viewModel),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return ProductDetailPage(
                productName: args['productName'],
                price: args['price'],
                description: args['description'],
                image: args['image'],
                category: args['category'],
                rate: args['rate'],
                ratingCount: args['ratingCount'],
              );
            },
          );
        }
        return null;
      },
    );
  }
}