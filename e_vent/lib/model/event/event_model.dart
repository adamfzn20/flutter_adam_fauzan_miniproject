import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  String? title;
  String? description;
  DateTime? date;
  String? location;
  int? availableAttendees;
  int? currentAttendees;
  int? price;
  String? image;
  String? adminId;
  String? emailAdmin;
  String? imageAdmin;
  bool status;
  String? category;

  Event({
    this.id,
    this.title,
    this.description,
    this.date,
    this.location,
    this.availableAttendees,
    this.currentAttendees,
    this.price,
    this.image,
    this.adminId,
    this.emailAdmin,
    this.imageAdmin,
    this.status = true,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Event(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      location: data['location'],
      availableAttendees: data['availableAttendees'],
      currentAttendees: data['currentAttendees'],
      price: data['price'],
      image: data['image'],
      adminId: data['adminId'],
      emailAdmin: data['emailAdmin'],
      imageAdmin: data['imageAdmin'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'availableAttendees': availableAttendees,
      'currentAttendees': currentAttendees,
      'price': price,
      'image': image,
      'adminId': adminId,
      'emailAdmin': emailAdmin,
      'imageAdmin': imageAdmin,
      'status': status,
    };
  }

  Event copyWith({required bool status}) {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      availableAttendees: availableAttendees,
      currentAttendees: currentAttendees,
      price: price,
      image: image,
      adminId: adminId,
      emailAdmin: emailAdmin,
      imageAdmin: imageAdmin,
      status: status,
    );
  }

  Event copyWithTwo() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      availableAttendees: availableAttendees! - 1,
      currentAttendees: currentAttendees! + 1,
      price: price,
      image: image,
      adminId: adminId,
      emailAdmin: emailAdmin,
      imageAdmin: imageAdmin,
      status: status,
    );
  }
}
