import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/login_page.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/product_list_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ProductApp(),
    ),
  );
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Produtos com Autenticação',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomeScreen(),
        '/products': (_) => const ProductListScreen(),
      },
    );
  }
}