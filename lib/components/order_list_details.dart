import 'package:flutter/material.dart';

import '../models/order.dart';

class OrderListDetails extends StatelessWidget {
  const OrderListDetails({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (order.products.length * 24) + 10,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: ListView(
        children: order.products.map((product) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${product.quantity} x ${product.price}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
