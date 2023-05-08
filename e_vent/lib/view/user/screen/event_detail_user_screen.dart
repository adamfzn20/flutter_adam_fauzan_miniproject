import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/ticket/ticket_model.dart';
import 'package:e_vent/model/user/user_model.dart';
import 'package:e_vent/service/ticket_service.dart';
import 'package:e_vent/view/widget/card_detail_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../model/event/event_model.dart';
import '../../../service/event_service.dart';

class EventDetailUserScreen extends StatefulWidget {
  final String eventId;

  const EventDetailUserScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<EventDetailUserScreen> createState() => _EventDetailUserScreenState();
}

class _EventDetailUserScreenState extends State<EventDetailUserScreen> {
  final EventService _eventService = EventService();

  bool _isLoading = false;

  Event? _event;
  DateTime? _date;
  int? _availableAttendees;
  int? _price;

  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  var role;
  String? id;
  String? name;
  String? image;

  int? _currentIndex;

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
            image = loggedInUser.image.toString();
          });
        }
      });
    }
    _loadEventData();
  }

  void _loadEventData() async {
    Event? event = await _eventService.getEventById(widget.eventId);
    setState(() {
      _event = event;
      _date = _event!.date;
      _availableAttendees = _event!.availableAttendees;
      _price = _event!.price;
    });
  }

  Future<void> _buyTicket() async {
    setState(() {
      _isLoading = true;
    });
    final newTicket = Ticket(
        userId: id,
        eventId: widget.eventId,
        titleEvent: _event!.title,
        descriptionEvent: _event!.description,
        dateEvent: _date,
        locationEvent: _event!.location,
        totalPrice: _price,
        imageEvent: _event!.image,
        payment: false);
    try {
      await TicketService().purchaseTicket(newTicket);
      Navigator.popUntil(context, ModalRoute.withName('/homePage'));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An Error Occurred!'),
          content: const Text('Something went wrong. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _event != null
        ? Scaffold(
            appBar: AppBar(
              leading: const BackButton(
                color: Color(0xffF1511B),
              ),
              title: const Text('Event Detail'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 16, left: 16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage('${_event!.image}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_event!.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_event!.location}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: CardDetail(
                              availableAttendees: _availableAttendees!,
                              date: _date!,
                              price: _price!,
                            )),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_event!.description}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          "Event Creator",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_event!.imageAdmin.toString()),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_event!.emailAdmin}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 50,
              color: const Color(0xffF1511B),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: _buyTicket,
                  child: const Text(
                    'Buy Ticket',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
