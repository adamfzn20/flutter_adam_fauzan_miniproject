import 'package:flutter/material.dart';

class TicketEventScreen extends StatefulWidget {
  const TicketEventScreen({super.key});

  @override
  State<TicketEventScreen> createState() => _TicketEventScreenState();
}

class _TicketEventScreenState extends State<TicketEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
      ),
    );
  }
}
