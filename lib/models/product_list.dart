import 'package:flutter/cupertino.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  // Retornando uma copia de items.
  // Quando usa return _items, esta passando a referencia, assim os valores
  // podem ser alterados dentro da classe;
  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
