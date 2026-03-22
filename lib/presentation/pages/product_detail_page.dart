import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetailPage extends StatelessWidget {

  final String productName;
  final double price;
  final String description;
  final String image;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.price,
    required this.description,
    required this.image,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
      ),
      body: Column(
        children: [
          Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Expanded(
            child: Image(image: NetworkImage(image),
            fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8),
          Text("R\$ ${price}", style: TextStyle(color: Colors.green)),
          SizedBox(height: 8),   
          Text(description),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Voltar"),
          ),
        ],
      ),
    );
  }
}