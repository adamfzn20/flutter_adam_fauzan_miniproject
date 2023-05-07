import 'package:e_vent/view/admin/screen/event_edit_screen.dart';
import 'package:e_vent/view/widget/card_detail_widget.dart';
import 'package:flutter/material.dart';

import '../../../model/event/event_model.dart';
import '../../../service/event_service.dart';

class EventDetailAdminScreen extends StatefulWidget {
  final String eventId;

  const EventDetailAdminScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  State<EventDetailAdminScreen> createState() => _EventDetailAdminScreenState();
}

class _EventDetailAdminScreenState extends State<EventDetailAdminScreen> {
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

  Future<void> _editEvent() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventEditScreen(event: _event!),
      ),
    );
  }

  void _deleteEvent() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Confirm you want to delete the event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _eventService.deleteEvent(_event!.id.toString());
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _openCloseRegistration() async {
    if (_event!.status == true) {
      Event updatedEvent = _event!.copyWith(status: false);
      await _eventService.updateEvent(updatedEvent);
      setState(() {
        _event = updatedEvent;
      });
    } else {
      Event updatedEvent = _event!.copyWith(status: true);
      await _eventService.updateEvent(updatedEvent);
      setState(() {
        _event = updatedEvent;
      });
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
                              size: 20,
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
                          "Participant",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_event!.currentAttendees}',
                          style: const TextStyle(fontSize: 14),
                        ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _deleteEvent,
                      child: const Text(
                        'Delete Event',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                    ),
                    TextButton(
                      onPressed: _editEvent,
                      child: const Text(
                        'Edit Event',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                    ),
                    TextButton(
                      onPressed: _openCloseRegistration,
                      child: Text(
                        _event!.status == true
                            ? 'Close Registration'
                            : 'Open Registration',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
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
