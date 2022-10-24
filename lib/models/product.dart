import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  final String _baseUrl = Constants.productBaseUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();

    toggleFavorite();
  }

  Future<void> toggleFavorite() async {
    try {
      _toggleFavorite();

      final response = await http.patch(
        Uri.parse('$_baseUrl/$id.json'),
        body: jsonEncode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
        errorToggleFavorite();
      }
    } catch (e) {
      _toggleFavorite();
      errorToggleFavorite();
    }
  }

  errorToggleFavorite([statusCode]) {
    throw HttpExceptions(msg: 'Algo deu errado!', statusCode: statusCode);
  }
}
