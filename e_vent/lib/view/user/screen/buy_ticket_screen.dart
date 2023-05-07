import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/model/ticket/ticket_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/service/ticket_service.dart';
import 'package:flutter/material.dart';

class BuyTicketScreen extends StatefulWidget {
  final String ticketId;
  final String eventId;

  const BuyTicketScreen(
      {super.key, required this.ticketId, required this.eventId});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  final TicketService _ticketService = TicketService();
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();

  Event? _event;
  Ticket? _ticket;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.ticketId);
    _loadEventData();
  }

  void _loadEventData() async {
    Ticket? ticket = await _ticketService.getTicketById(widget.ticketId);
    Event? event = await _eventService.getEventById(widget.eventId);
    setState(() {
      _event = event;
      _ticket = ticket;
    });
  }

  void _payment() async {
    Event updatedEvent = _event!.copyWithTwo();
    await _eventService.updateEvent(updatedEvent);
    Ticket updatedTicket = _ticket!.copyWith(payment: true);
    await _ticketService.updateTicket(updatedTicket);
    setState(() {
      _event = updatedEvent;
      _ticket = updatedTicket;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beli Tiket'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _payment, //_isLoading ? null : _buyTicket,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Beli Tiket'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _buyTicket() async {
  //   final isValid = _formKey.currentState!.validate();

  //   if (isValid) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     try {
  //       final eventDoc = FirebaseFirestore.instance.collection('events').doc(widget.eventId);

  //       await FirebaseFirestore.instance.runTransaction((transaction) async {
  //         final eventSnapshot = await transaction.get(eventDoc);

  //         if (eventSnapshot.exists) {
  //           final event = eventSnapshot.data() as Map<String, dynamic>;

  //           if (event['availableAttendees'] - _ticketCount >= 0) {
  //             final batch = FirebaseFirestore.instance.batch();

  //             batch.update(eventDoc, {
  //               'availableAttendees': event['availableAttendees'] - _ticketCount,
  //               'currentAttendees': event['currentAttendees'] + _ticketCount,
  //             });

  //             final user = FirebaseAuth.instance.currentUser!;

  //             final ticket = {
  //               'eventId': widget.eventId,
  //               'userId': user.uid,
  //               'ticketCount': _ticketCount,
  //               'totalPrice': event['price'] * _ticketCount,
  //             };

  //             batch.set(FirebaseFirestore.instance.collection('tickets').doc(), ticket);

  //             await batch.commit();

  //             Navigator.pop(context);
  //           } else {
  //             showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 title: Text('Gagal Membeli Tiket'),
  //                 content: Text('Jumlah tiket yang tersedia tidak mencukupi.'),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('OK'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //         } else {
  //           showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: Text('Gagal Membeli Tiket'),
  //               content
}
