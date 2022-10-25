import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/forms/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 217, 255, 0.5),
                Color.fromRGBO(255, 188, 117, 0.9)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 70,
                ),
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                decoration: BoxDecoration(
                    color: Colors.deepOrange.shade900,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8.0,
                        color: Colors.black38,
                        offset: Offset(5, 0),
                      )
                    ]),
                child: Text(
                  'Minha Loja',
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Anton',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const AuthForm(),
            ],
          ),
        ),
      ],
    ));
  }
}
