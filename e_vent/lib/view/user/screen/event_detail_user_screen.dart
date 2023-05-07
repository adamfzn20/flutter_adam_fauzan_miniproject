import 'package:e_vent/view/admin/screen/event_edit_screen.dart';
import 'package:e_vent/view/widget/card_detail_widget.dart';
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

  Event? _event;
  DateTime? _date;
  int? _availableAttendees;
  int? _price;

  @override
  void initState() {
    super.initState();
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

  Future<void> _daftarEvent() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Detail'),
      ),
      body: _event != null
          ? SingleChildScrollView(
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
                            const CircleAvatar(
                              backgroundColor: Color(0xFFEADDFF),
                              child: Text("A"),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_event!.emailAdmin}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _daftarEvent,
                          child: const Text('Daftar Event'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
