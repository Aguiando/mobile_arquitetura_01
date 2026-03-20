import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetailPage extends StatelessWidget {

  final String productName;
  final double price;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
      ),
      body: Column(
        children: [
          Text(productName),
          Text("R\$ ${price}"),
        ],
      ),
    );
  }
}