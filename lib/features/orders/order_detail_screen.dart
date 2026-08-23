import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('OrderDetail')),
        body: const Center(child: Text('OrderDetail')),
      );
}
