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

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http
        .patch(
      Uri.parse('$_baseUrl/$id.json'),
      body: jsonEncode(
        {
          "isFavorite": isFavorite,
        },
      ),
    )
        .catchError(
      (error) {
        errorToggleFavorite(isFavorite);
      },
    );

    if (response.statusCode >= 400) {
      errorToggleFavorite(isFavorite);
    }
  }

  errorToggleFavorite(isFavoriteReceveid, [statusCode]) {
    isFavorite = !isFavoriteReceveid;
    notifyListeners();

    throw HttpExceptions(msg: 'Algo deu errado!', statusCode: statusCode);
  }
}
