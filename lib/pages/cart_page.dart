import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/order_list.dart';

import '../models/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();
    final OrderList orderList = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartButtonBuy(cart: cart, orderList: orderList),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButtonBuy extends StatefulWidget {
  const CartButtonBuy({
    super.key,
    required this.cart,
    required this.orderList,
  });

  final Cart cart;
  final OrderList orderList;

  @override
  State<CartButtonBuy> createState() => _CartButtonBuyState();
}

class _CartButtonBuyState extends State<CartButtonBuy> {
  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return TextButton(
      onPressed: widget.cart.itemCount == 0
          ? null
          : () async {
              setState(() => _isLoad = true);
              await widget.orderList.addOrder(widget.cart, auth.userId ?? '');
              widget.cart.clear();
              setState(() => _isLoad = false);
            },
      style: TextButton.styleFrom(
          textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      )),
      child:
          _isLoad ? const CircularProgressIndicator() : const Text('COMPRAR'),
    );
  }
}
