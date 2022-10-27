import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/config/auth_config.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiresDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiresDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _autentication(
      String email, String password, String urlFragmet) async {
    String key = AuthConfig.apiKey;
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragmet?key=$key';

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
      throw AuthException(key: (body['error']['message']));
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiresDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
    }

    notifyListeners();
    autoLogout();
  }

  Future<void> sigunp(String email, String password) async {
    return _autentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autentication(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiresDate = null;

    _clearLogoutTimer();
    notifyListeners();
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void autoLogout() {
    _clearLogoutTimer();
    var timeToLogout = _expiresDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), () => logout());
  }
}
