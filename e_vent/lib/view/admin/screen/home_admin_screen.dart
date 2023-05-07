import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/model/user/user_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/view/admin/screen/event_detail_admin_screen.dart';
import 'package:e_vent/view/widget/card_search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  final EventService _eventService = EventService();
  late User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser = UserModel();
  late String? email;
  String? role;
  String? id;
  String? name;
  String? image;

  late Stream<List<Event>>? _eventsStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
            _eventsStream =
                _eventService.getEventsForAdmin(loggedInUser.uid.toString());
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String newText) {
    setState(() {
      _searchText = newText;
    });
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black54),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 15.0),
                      filled: true,
                      fillColor: const Color(0xffD9D9D9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search your event',
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: const Color.fromARGB(172, 241, 80, 27),
                    ),
                    onChanged: _onSearchTextChanged,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Event>>(
                    stream: _eventsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final events = snapshot.data;

                      if (events!.isEmpty) {
                        return const Center(
                          child: Text('No Events yet'),
                        );
                      }

                      final filteredEvents = events
                          .where((event) => event.title!
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailAdminScreen(
                                            eventId: event.id.toString()),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: CardSearch(
                                  title: event.title.toString(),
                                  date: event.date!,
                                  location: event.location.toString(),
                                  price: event.price!,
                                  image: event.image.toString(),
                                  status: event.status,
                                ),
                              ),
                            ),
                          );
                        },
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
