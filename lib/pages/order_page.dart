import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

import '../models/auth.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pedidos'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false)
            .loadOrder(auth.userId ?? ''),
        builder: ((ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Algo deu errado! ${snapshot.error}'),
            );
          } else {
            return Consumer<OrderList>(
              builder: (context, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) {
                  return OrderWidget(order: orders.items[i]);
                },
              ),
            );
          }
        }),
      ),
      drawer: const AppDrawer(),
    );
  }
}
