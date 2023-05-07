import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vent/model/ticket/ticket_model.dart';

class TicketService {
  final CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');

  Future<void> purchaseTicket(Ticket ticket) async {
    return await ticketsCollection
        .add(ticket.toFirestore())
        .then((value) => print('Ticket added'))
        .catchError((error) => print('Failed to add event: $error'));
  }

  Stream<List<Ticket>> getTicketsByUserAndEvent(String userId, String eventId) {
    return ticketsCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Ticket> tickets = [];
      query.docs.forEach((doc) {
        tickets.add(Ticket.fromFirestore(doc));
      });
      return tickets;
    });
  }

  Stream<List<Ticket>> getTicketsByUser(String userId) {
    return ticketsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Ticket> tickets = [];
      query.docs.forEach((doc) {
        tickets.add(Ticket.fromFirestore(doc));
      });
      return tickets;
    });
  }

  Stream<List<Ticket>> getTicketsByEvent(String eventId) {
    return ticketsCollection
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Ticket> tickets = [];
      query.docs.forEach((doc) {
        tickets.add(Ticket.fromFirestore(doc));
      });
      return tickets;
    });
  }

  Stream<List<Ticket>> getTicketsPaymentFalse(String userId) {
    return ticketsCollection
        .where('userId', isEqualTo: userId)
        .where('payment', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Ticket> tickets = [];
      query.docs.forEach((doc) {
        tickets.add(Ticket.fromFirestore(doc));
      });
      return tickets;
    });
  }

  Stream<List<Ticket>> getTicketsPaymentTrue(String userId) {
    return ticketsCollection
        .where('userId', isEqualTo: userId)
        .where('payment', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Ticket> tickets = [];
      query.docs.forEach((doc) {
        tickets.add(Ticket.fromFirestore(doc));
      });
      return tickets;
    });
  }

  Future<void> updateTicket(Ticket ticket) async {
    return await ticketsCollection
        .doc(ticket.id)
        .update(ticket.toFirestore())
        .then((value) => print('Ticket updated'))
        .catchError((error) => print('Failed to update ticket: $error'));
  }

  // Mengambil detail event dari Firestore berdasarkan ID
  Future<Ticket> getTicketById(String ticketId) {
    return ticketsCollection.doc(ticketId).get().then((doc) {
      return Ticket.fromFirestore(doc);
    });
  }
}
