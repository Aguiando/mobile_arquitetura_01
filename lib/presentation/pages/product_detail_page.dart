import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetailPage extends StatelessWidget {

  final String productName;
  final double price;
  final String description;
  final String image;
  final String category;
  final double rate;
  final int ratingCount;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.rate,
    required this.ratingCount,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        )
      ),
      body: Column(
        children: [
          Text(productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
          SizedBox(height: 8),
          Expanded(
            child: Image(image: NetworkImage(image),
            fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8),
          Text("R\$ ${price}", 
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold,
                color: Colors.green)
              ),
          Row(children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            SizedBox(width: 4),
            Text(rate.toStringAsFixed(1),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            SizedBox(width: 8),
          Text(
            '($ratingCount ratings)',
            style: TextStyle(fontSize: 14, color:Colors.grey),
          ),
        ],
      ),
          SizedBox(height: 8),   
          Text(description),
          SizedBox(height: 8),
          Row(children:[Text("Category:${category}")
          ]
        ),
          SizedBox(height: 16),
        ],
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