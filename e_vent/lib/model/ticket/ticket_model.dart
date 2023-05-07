import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String? id;
  String? userId;
  String? eventId;
  String? titleEvent;
  String? descriptionEvent;
  DateTime? dateEvent;
  String? locationEvent;
  int? totalPrice;
  String? imageEvent;
  bool payment;
  DateTime? purchasedAt;

  Ticket({
    this.id,
    this.userId,
    this.eventId,
    this.titleEvent,
    this.descriptionEvent,
    this.dateEvent,
    this.locationEvent,
    this.totalPrice,
    this.imageEvent,
    this.payment = false,
    this.purchasedAt,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return Ticket(
      id: doc.id,
      userId: data['userId'],
      eventId: data['eventId'],
      titleEvent: data['titleEvent'],
      descriptionEvent: data['descriptionEvent'],
      dateEvent: data['dateEvent'].toDate(),
      locationEvent: data['locationEvent'],
      totalPrice: data['totalPrice'],
      imageEvent: data['imageEvent'],
      payment: data['payment'],
      purchasedAt: data['purchasedAt'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'titleEvent': titleEvent,
      'descriptionEvent': descriptionEvent,
      'dateEvent': dateEvent,
      'locationEvent': locationEvent,
      'totalPrice': totalPrice,
      'imageEvent': imageEvent,
      'payment': payment,
      'purchasedAt': DateTime.now(),
    };
  }

  Ticket copyWith({required bool payment}) {
    return Ticket(
      id: id,
      userId: userId,
      eventId: eventId,
      titleEvent: titleEvent,
      descriptionEvent: descriptionEvent,
      dateEvent: dateEvent,
      locationEvent: locationEvent,
      totalPrice: totalPrice,
      imageEvent: imageEvent,
      payment: payment,
      purchasedAt: purchasedAt,
    );
  }
}
