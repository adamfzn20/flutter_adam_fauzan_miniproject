import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/model/ticket/ticket_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/service/ticket_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayTicketScreen extends StatefulWidget {
  final String ticketId;
  final String eventId;

  const PayTicketScreen(
      {super.key, required this.ticketId, required this.eventId});

  @override
  State<PayTicketScreen> createState() => _PayTicketScreenState();
}

class _PayTicketScreenState extends State<PayTicketScreen> {
  final TicketService _ticketService = TicketService();
  final EventService _eventService = EventService();

  Event? _event;
  Ticket? _ticket;
  late final DateTime? date;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // print(widget.ticketId);
    _loadEventData();
  }

  void _loadEventData() async {
    Ticket? ticket = await _ticketService.getTicketById(widget.ticketId);
    Event? event = await _eventService.getEventById(widget.eventId);
    setState(() {
      _event = event;
      _ticket = ticket;
      date = _ticket!.dateEvent;
    });
  }

  void _payment() async {
    Event updatedEvent = _event!.copyWithTwo();
    await _eventService.updateEvent(updatedEvent);
    Ticket updatedTicket = _ticket!.copyWith(payment: true);
    await _ticketService.updateTicket(updatedTicket);
    setState(() {
      _isLoading = true;
      _event = updatedEvent;
      _ticket = updatedTicket;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _ticket != null
        ? Scaffold(
            appBar: AppBar(
              leading: const BackButton(
                color: Color(0xffF1511B),
              ),
              title: const Text('Payment Event'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PayTicketScreen(
                                  ticketId: _ticket!.id.toString(),
                                  eventId: _ticket!.eventId.toString(),
                                ),
                              ),
                            );
                          },
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
                                        _ticket!.imageEvent.toString()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: 170,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_ticket!.titleEvent}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _ticket!.dateEvent!.minute == 0
                                          ? Text(
                                              '${DateFormat('yMMMd').format(date!)} - ${date!.hour}:${date!.minute}${date!.second}',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    172, 241, 80, 27),
                                                fontSize: 12,
                                              ),
                                            )
                                          : Text(
                                              '${DateFormat('yMMMd').format(date!)} - ${date!.hour}:${date!.minute}',
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
                                            _ticket!.locationEvent.toString(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      _ticket!.totalPrice != 0
                                          ? Text(
                                              'Rp ${_ticket!.totalPrice}',
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
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: const [
                        Icon(Icons.wallet),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Bank Payments'),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Row(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          child: Image.asset('assets/bni.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Bank BNI',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black54,
                                ),
                                Text(
                                  'No Rekening',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '88 08xxx xxxx xxx',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Divider(
                                  color: Colors.black54,
                                ),
                                Text(
                                  'Please make a payment with BNI bank then click pay',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Total Price",
                            style: TextStyle(fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _event!.price != 0
                              ? Text(
                                  _event!.price.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const Text(
                                  'Gratis',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
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
                  onPressed: _payment, //_isLoading ? null : _buyTicket,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Pay Ticket',
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
