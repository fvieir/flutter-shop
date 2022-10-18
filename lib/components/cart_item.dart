import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cart;
  const CartItemWidget({required this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(cart.name);
  }
}
