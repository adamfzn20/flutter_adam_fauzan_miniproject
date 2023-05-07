import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/event/event_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventService {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  //Upload image
  Future<String> uploadImageEvent(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('event/$fileName');
    UploadTask uploadTask = ref.putFile(File(image.path));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Menambahkan event ke Firestore
  Future<void> addEvent(Event event, File? imageFile) async {
    String imageUrl = await uploadImageEvent(imageFile!);
    event.image = imageUrl;
    return await eventsCollection
        .add(event.toFirestore())
        .then((value) => print('Event added'))
        .catchError((error) => print('Failed to add event: $error'));
  }

  // Mengupdate event di Firestore
  Future<void> updateEvent(Event event) async {
    return await eventsCollection
        .doc(event.id)
        .update(event.toFirestore())
        .then((value) => print('Event updated'))
        .catchError((error) => print('Failed to update event: $error'));
  }

  // Menghapus event dari Firestore
  Future<void> deleteEvent(String eventId) async {
    return await eventsCollection
        .doc(eventId)
        .delete()
        .then((value) => print('Event deleted'))
        .catchError((error) => print('Failed to delete event: $error'));
  }

  // Mengambil daftar event dari Firestore untuk admin tertentu
  Stream<List<Event>> getEventsForAdmin(String adminId) {
    return eventsCollection
        .where('adminId', isEqualTo: adminId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Event> events = [];
      query.docs.forEach((doc) {
        events.add(Event.fromFirestore(doc));
      });
      return events;
    });
  }

  Stream<List<Event>> getEventsForAdminAndTitle(String adminId, String title) {
    return eventsCollection
        .where('adminId', isEqualTo: adminId)
        .where('title', isEqualTo: title.toLowerCase())
        .snapshots()
        .map((QuerySnapshot query) {
      List<Event> events = [];
      query.docs.forEach((doc) {
        events.add(Event.fromFirestore(doc));
      });
      return events;
    });
  }

  // Mengambil daftar event dari Firestore yang masih terbuka
  Stream<List<Event>> getOpenEvents() {
    return eventsCollection
        .where('status', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Event> events = [];
      query.docs.forEach((doc) {
        events.add(Event.fromFirestore(doc));
      });
      return events;
    });
  }

  // Mengambil daftar seluruh event dari Firestore
  Stream<List<Event>> getAllEvents() {
    return eventsCollection.snapshots().map((QuerySnapshot query) {
      List<Event> events = [];
      query.docs.forEach((doc) {
        events.add(Event.fromFirestore(doc));
      });
      return events;
    });
  }

  // Mengambil detail event dari Firestore berdasarkan ID
  Future<Event> getEventById(String eventId) {
    return eventsCollection.doc(eventId).get().then((doc) {
      return Event.fromFirestore(doc);
    });
  }
}
