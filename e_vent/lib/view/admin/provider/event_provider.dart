import 'dart:io';

import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await EventService().deleteEvent(eventId);
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event, File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await EventService().addEvent(event, imageFile);
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await EventService().updateEvent(event);
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
