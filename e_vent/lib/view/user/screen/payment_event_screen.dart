import 'package:flutter/material.dart';

class PaymentEventScreen extends StatefulWidget {
  const PaymentEventScreen({super.key});

  @override
  State<PaymentEventScreen> createState() => _PaymentEventScreenState();
}

class _PaymentEventScreenState extends State<PaymentEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
    );
  }
}
