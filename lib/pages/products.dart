import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductList product = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: product.itemsCount,
          itemBuilder: (ctx, i) => Text(product.items[i].name),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
