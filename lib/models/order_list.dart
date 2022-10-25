import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
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

  Future<void> loadOrder() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl.json'),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      _items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: orderId,
              productId: item['productId'] as String,
              name: item['name'] as String,
              quantity: item['quantity'] as int,
              price: item['price'] as double,
            );
          }).toList(),
          date: DateTime.parse(orderData['date']),
        ),
      );
    });

    notifyListeners();
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
