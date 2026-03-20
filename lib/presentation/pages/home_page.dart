import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_imp.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Tela inicial"),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPage(
                                    viewModel: ProductViewModel(
                                        ProductRepositoryImpl(
                                            ProductRemoteDatasource(http.Client()),
                                            ProductCacheDatasource(),
                                        ),
                                    ),
                                ),
                            ),
                        );
                    },
                    child: const Icon(Icons.download),
                ),
            ),
        );
    }
}