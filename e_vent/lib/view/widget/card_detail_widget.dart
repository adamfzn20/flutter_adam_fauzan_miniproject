import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardDetail extends StatelessWidget {
  final DateTime date;
  final int price;
  final int availableAttendees;

  const CardDetail(
      {super.key,
      required this.date,
      required this.price,
      required this.availableAttendees});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 2,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_num_outlined,
                        size: 35,
                      ),
                      const SizedBox(width: 8),
                      Text('Ticket         \n$availableAttendees'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Date \n${DateFormat('yMMMd').format(date)}',
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 35,
                      ),
                      const SizedBox(width: 8),
                      price != 0
                          ? Text('Price \nRp $price')
                          : const Text('Price       \nGratis')
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_alarm_rounded,
                        size: 35,
                      ),
                      const SizedBox(width: 8),
                      date.minute == 0
                          ? Text(
                              'Time \n${date.hour}:${date.minute}${date.second}')
                          : Text('Time \n${date.hour}:${date.minute}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
