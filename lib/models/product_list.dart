import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];
  final String _url = 'https://shop-cod3r-f5b93-default-rtdb.firebaseio.com/';

  // Retornando uma copia de items.
  // Quando usa return _items, esta passando a referencia, assim os valores
  // podem ser alterados dentro da classe;
  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_url/product'));

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, product) {
      _items.add(
        Product(
          id: productId,
          name: product['name'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: product['isFavorite'],
        ),
      );
    });

    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    final hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_url/product.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}
