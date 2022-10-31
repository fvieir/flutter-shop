import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/components/order_list_details.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({
    required this.order,
    super.key,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expand ? (widget.order.products.length * 24) + 90.00 : 80.00,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(widget.order.total.toStringAsFixed(2)),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            OrderListDetails(
              order: widget.order,
              expand: _expand,
            ),
          ],
        ),
      ),
    );
  }
}
