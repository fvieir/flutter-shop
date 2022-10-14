import 'package:flutter/material.dart';
import 'package:shop/pages/product_overview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(fontSize: 20),
            ),
      ),
      home: const ProductOverview(),
    );
  }
}
