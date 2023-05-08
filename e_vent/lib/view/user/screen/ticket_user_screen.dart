import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/ticket/ticket_model.dart';
import 'package:e_vent/model/user/user_model.dart';
import 'package:e_vent/service/ticket_service.dart';
import 'package:e_vent/view/user/screen/ticket_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketEventScreen extends StatefulWidget {
  const TicketEventScreen({super.key});

  @override
  State<TicketEventScreen> createState() => _TicketEventScreenState();
}

class _TicketEventScreenState extends State<TicketEventScreen> {
  final TicketService _ticketService = TicketService();
  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  String? role;
  String? id;
  String? name;
  String? image;

  Stream<List<Ticket>>? _ticketsStream;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          const CircularProgressIndicator();
          loggedInUser = UserModel.fromMap(value.data()!);
          setState(() {
            email = loggedInUser.email.toString();
            role = loggedInUser.wrole.toString();
            id = loggedInUser.uid.toString();
            name = loggedInUser.name.toString();
            image = loggedInUser.name.toString();
            _ticketsStream = _ticketService.getTicketsPaymentTrue(id!);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: _ticketsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              final tickets = snapshot.data ?? [];
              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  final DateTime? date = ticket.dateEvent;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                      ticket.imageEvent.toString()),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${ticket.titleEvent}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ticket.dateEvent!.minute == 0
                                        ? Text(
                                            '${DateFormat('yMMMd').format(date!)} - ${date.hour}:${date.minute}${date.second}',
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  172, 241, 80, 27),
                                              fontSize: 12,
                                            ),
                                          )
                                        : Text(
                                            '${DateFormat('yMMMd').format(date!)} - ${date.hour}:${date.minute}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    172, 241, 80, 27),
                                                fontSize: 12),
                                          ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                        ),
                                        Text(
                                          ticket.locationEvent.toString(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ticket.totalPrice != 0
                                        ? Text(
                                            'Rp ${ticket.totalPrice}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Text(
                                            'Gratis',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
