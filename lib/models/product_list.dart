import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import '../utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;
  final String _baseUrl = Constants.productBaseUrl;
  final String _userFavoritesUrl = Constants.userFavoritesUrl;

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

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
    _items.clear();

    final response = await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));

    if (response.body == 'null') {
      return;
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final responsefavorites = await http.get(
      Uri.parse('$_userFavoritesUrl/$_userId.json?auth=$_token'),
    );

    final Map<String, dynamic> favData = responsefavorites.body == 'null'
        ? {}
        : jsonDecode(responsefavorites.body);

    data.forEach((productId, product) {
      bool isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: product['name'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: isFavorite,
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
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
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
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http
          .delete(
        Uri.parse('$_baseUrl/${product.id}.json'),
      )
          .catchError(
        (e) {
          _errorRequest(index, product);
        },
      );

      if (response.statusCode >= 400) {
        _errorRequest(index, product, response.statusCode);
      }
    }
  }

  void _errorRequest(int index, Product product, [response]) {
    _items.insert(index, product);
    notifyListeners();

    throw HttpException(
      msg: 'Algo deu errado! N??o foi poss??vel excluir.',
      statusCode: response,
    );
  }
}
