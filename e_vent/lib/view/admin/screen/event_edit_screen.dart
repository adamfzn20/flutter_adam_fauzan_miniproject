import 'dart:io';

import 'package:e_vent/model/event/event_model.dart';
import 'package:e_vent/service/event_service.dart';
import 'package:e_vent/view/admin/provider/event_provider.dart';
import 'package:e_vent/view/admin/screen/event_detail_admin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventEditScreen extends StatefulWidget {
  final Event event;

  const EventEditScreen({super.key, required this.event});

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _availableAttendeesController = TextEditingController();
  final _priceController = TextEditingController();

  late DateTime _date;
  bool _isLoading = false;

  File? _imageFile;
  String? imageUrl;
  final picker = ImagePicker();

  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.event.title.toString();
    _descriptionController.text = widget.event.description.toString();
    _locationController.text = widget.event.location.toString();
    _availableAttendeesController.text =
        widget.event.availableAttendees.toString();
    _priceController.text = widget.event.price.toString();
    _date = widget.event.date!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.year + 1),
    );

    if (selectedDate == null) return;

    const initialTime = TimeOfDay(hour: 00, minute: 00);

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime.minute,
    );

    setState(() {
      _date = newDateTime;
    });
  }

  Future<void> _selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_imageFile != null) {
      if (_imageFile!.lengthSync() > 2 * 1024 * 1024) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('File too large'),
              content: const Text('File size cannot exceed 2 MB'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        imageUrl = await EventService().uploadImageEvent(_imageFile!);
      }
    }

    final editedEvent = Event(
      id: widget.event.id,
      adminId: widget.event.adminId,
      emailAdmin: widget.event.emailAdmin,
      imageAdmin: widget.event.imageAdmin,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _date,
      location: _locationController.text,
      availableAttendees: int.parse(_availableAttendeesController.text),
      currentAttendees: widget.event.currentAttendees,
      price: int.parse(_priceController.text),
      status: widget.event.status,
      image: imageUrl ?? widget.event.image,
    );

    if (_isLoading == true) {
      //await eventService.updateEvent(editedEvent);
      await Provider.of<EventProvider>(context, listen: false)
          .updateEvent(editedEvent);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                EventDetailAdminScreen(eventId: widget.event.id.toString()),
          ),
          ModalRoute.withName('/homePage'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color(0xffF1511B),
        ),
        title: const Text('Edit Event'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Tittle Event',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Tittle cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description Event',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date And Time: '),
                      _date.minute == 0
                          ? Text(
                              '${DateFormat('yMMMd').format(_date)} - ${_date.hour}:${_date.minute}${_date.second}',
                              style: const TextStyle(
                                color: Color.fromARGB(172, 241, 80, 27),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              '${DateFormat('yMMMd').format(_date)} - ${_date.hour}:${_date.minute}',
                              style: const TextStyle(
                                color: Color.fromARGB(172, 241, 80, 27),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Location Event',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Location cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _availableAttendeesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number of participants',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Number of participants cannot be empty.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Must be a number.';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Must be greater than 0.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ticket Price',
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ticket price cannot be empty.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Must be a number.';
                  }
                  if (int.parse(value) < 0) {
                    return "can't be negative.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectImage,
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.file(
                          _imageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Image.network(
                          widget.event.image.toString(),
                          height: 200,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      elevation: 3.0,
                      height: 50,
                      minWidth:
                          BouncingScrollSimulation.maxSpringTransferVelocity,
                      onPressed: _submitForm,
                      color: const Color(0xffF1511B),
                      textColor: Colors.white,
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
