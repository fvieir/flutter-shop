import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];
  final _baseUrl = Constants.orderBaseUrl;

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final DateTime date = DateTime.now();

    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'products': cart.items.values
              .map((cartItem) => {
                    'name': cartItem.name,
                    'productId': cartItem.productId,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
          'date': date.toIso8601String(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );

    notifyListeners();
  }
}
