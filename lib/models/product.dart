import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
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
  }

  Future<void> toggleFavorite(String token) async {
    try {
      _toggleFavorite();

      final response = await http.patch(
        Uri.parse('$_baseUrl/$id.json?auth=$token'),
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
    throw HttpException(msg: 'Algo deu errado!', statusCode: statusCode);
  }
}
