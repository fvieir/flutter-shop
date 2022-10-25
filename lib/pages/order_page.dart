import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    setState(() => isLoad = true);
    Provider.of<OrderList>(context, listen: false).loadOrder().then((value) {
      setState(() => isLoad = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pedidos'),
      ),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (ctx, i) {
                return OrderWidget(order: orders.items[i]);
              },
            ),
      drawer: const AppDrawer(),
    );
  }
}
