import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  Future<void> _autentication(
      String email, String password, String urlFragmet) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragmet?key=AIzaSyAJj5xj-Y9jBVeO8MCvhQb2XZE8ZdspE78';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      print(body['error']);
      throw AuthException(key: (body['error']['message']));
    }
  }

  Future<void> sigunp(String email, String password) async {
    return _autentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autentication(email, password, 'signInWithPassword');
  }
}
