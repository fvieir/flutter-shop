import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';
import 'package:shop/utils/constants.dart';

import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final String _token;
  List<Order> _items;
  final _baseUrl = Constants.orderBaseUrl;

  OrderList([
    this._token = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrder(String userId) async {
    List<Order> items = [];

    final response = await http.get(
      Uri.parse('$_baseUrl.json?auth=$_token'),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    data[userId].forEach((orderId, orderData) {
      items.add(
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

    _items = items.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(Cart cart, String userId) async {
    final DateTime date = DateTime.now();

    final response = await http.post(
      Uri.parse('$_baseUrl/$userId.json?auth=$_token'),
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


// {
//   iqWP5cRaG9fRb6ywjbsJH8EaAus1: 
//   {
//     -NFPWzj3PfTkkpKVtoTX: 
//       {date: 2022-10-27T14:40:29.991, 
//       products: [{name: Air Jordan 1 Retro, price: 599.99, productId: -NF8xWJPJZDEvbXJ2cjD, quantity: 2}, 
//       {name: Cacharrel Blusa , price: 59.99, productId: -NF8xp7O2ONt4hCo6wAy, quantity: 1}], 
//       total: 1259.97}
//   }, 
//   j2z5jIkXXsaaTcHMCde4Vy166Zr1: 
//     {
//       -NFPWMFOYfHvYUCLFVa6: 
//         {date: 2022-10-27T14:37:44.186, 
//         products: [{name: Scarf, price: 29.99, productId: -NF8x0P_sFo4JFZwTEHZ, quantity: 1}, 
//         {name: Tênis Masculino Caminhada, price: 219.99, productId: -NF8xLlGjtMX5_PwMzqp, quantity: 1}], 
//         total: 249.98000000000002},
//     -NFPWdthKoGV_sb9KHLp: 
//       {date: 2022-10-27T14:39:00.360, 
//         products: [{name: Panela com alça, price: 99.99, productId: -NF8x8no_fwCgI5yG7Ll, quantity: 1}, 
//         {name: Air Jordan 1 Retro, price: 599.99, productId: -NF8xWJPJZDEvbXJ2cjD, quantity: 1}, 
//         {name: Cacharrel Blusa , price: 59.99, productId: -NF8xp7O2ONt4hCo6wAy, quantity: 1}], 
//         total: 759.97}
//     }
// }