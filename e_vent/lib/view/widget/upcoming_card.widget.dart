import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/view/user/screen/event_detail_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: EventService().getUpcomingEvents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final events = snapshot.data!;

        return SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final DateTime? date = event.date;
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetailUserScreen(eventId: event.id.toString()),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            event.image.toString(),
                            fit: BoxFit.cover,
                            width: 200.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            event.title.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          event.price != 0
                              ? Text(
                                  'Rp ${event.price}',
                                )
                              : const Text(
                                  'Gratis',
                                )
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      date!.minute == 0
                          ? Text(
                              '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}${date.second}',
                              style: const TextStyle(
                                color: Color.fromARGB(172, 241, 80, 27),
                              ),
                            )
                          : Text(
                              '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}',
                              style: const TextStyle(
                                color: Color.fromARGB(172, 241, 80, 27),
                              ),
                            ),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.location_on,
                      //       size: 16,
                      //     ),
                      //     Text(
                      //       event.location.toString(),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
