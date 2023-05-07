import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardSearch extends StatelessWidget {
  final String title;
  final DateTime date;
  final String location;
  final int price;
  final String image;
  final bool status;

  const CardSearch({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.image,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: status == true
          ? Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        image,
                        height: 200,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            price != 0
                                ? Text(
                                    'Rp $price',
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
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        date.minute == 0
                            ? Text(
                                '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}${date.second}',
                                style: const TextStyle(
                                  color: Color.fromARGB(172, 241, 80, 27),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}',
                                style: const TextStyle(
                                  color: Color.fromARGB(172, 241, 80, 27),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            Text(
                              location,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Card(
              color: Colors.white24,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        image,
                        height: 200,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Event Closed',
                              style: TextStyle(
                                color: Color.fromARGB(255, 173, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            price != 0
                                ? Text(
                                    'Rp $price',
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
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        date.minute == 0
                            ? Text(
                                '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}${date.second}',
                                style: const TextStyle(
                                  color: Color.fromARGB(172, 241, 80, 27),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                '${DateFormat('yMMMd').format(date)} - ${date.hour}:${date.minute}',
                                style: const TextStyle(
                                  color: Color.fromARGB(172, 241, 80, 27),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            Text(
                              location,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
