class ProductRemoteDatasource{
  final HttpClient client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      "http://fakestoreapi.com/products"
    );
    final List data = response.data;
    return data
      .map((json) => ProductModel.fromJson(json))
      .toList();
  }
}