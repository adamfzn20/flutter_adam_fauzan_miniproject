import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/model/user/user_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/view/widget/upcoming_card.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  final EventService _eventService = EventService();
  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  String? role;
  String? id;
  String? name;
  String? image;

  // late Stream<List<Event>> _eventsBannerStream;
  late Stream<List<Event>> _eventsUpcomingStream;

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
            // _eventsBannerStream = _eventService
            //     .getUpcomingEventsBanner()
            //     .asStream()
            //     .asBroadcastStream();
            _eventsUpcomingStream = _eventService
                .getUpcomingEvents()
                .asStream()
                .asBroadcastStream();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: id != null
          ? Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Image.asset('assets/logo_warna.png'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Event>>(
                    stream: _eventsUpcomingStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final events = snapshot.data ?? [];
                      if (events.isEmpty) {
                        return const Center(
                          child: Text('No Events yet'),
                        );
                      }

                      return Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index, realIndex) {
                              final event = events[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 16),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    event.image.toString(),
                                    height: 200,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: true,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        top: 16,
                                      ),
                                      child: Text(
                                        'Upcoming Event',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const UpcomingEventsList(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
