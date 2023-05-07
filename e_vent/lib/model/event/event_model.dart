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
    this.status = true,
    this.category,
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
      status: data['status'],
      category: data['Category'],
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
      'status': status,
      'category': category,
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
      status: status,
      category: category,
    );
  }
}
