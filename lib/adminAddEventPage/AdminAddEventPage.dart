import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/data/EventModel.dart';
import 'package:flutter/material.dart';

class AdminAddEventPage extends StatefulWidget {
  const AdminAddEventPage({Key? key}) : super(key: key);

  @override
  State<AdminAddEventPage> createState() => _AdminAddEventPageState();
}

class _AdminAddEventPageState extends State<AdminAddEventPage> {
  final _formKey = GlobalKey<FormState>();
  late String _eventName;

  // Controllers to show the selected values in the text fields
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  bool _isLimitedStudent = false;
  late int _studentLimit;
  late String _resourcePerson;
  late String _venue;
  late String _coordinator;
  late String _bannerImage;
  late String _logoImage;
  late String _id;

  // Function to show date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        String formattedDate =
            "${picked.toLocal()}".split(' ')[0]; // Format to YYYY-MM-DD
        if (isStartDate) {
          _startDateController.text = formattedDate;
        } else {
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        String formattedTime = picked.format(context);
        if (isStartTime) {
          _startTimeController.text = formattedTime;
        } else {
          _endTimeController.text = formattedTime;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create an instance of EventModel
      EventModel event = EventModel(
        id: "",
        eventName: _eventName,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        isLimitedStudent: _isLimitedStudent,
        studentLimit: _isLimitedStudent ? _studentLimit : 0,
        resourcePerson: _resourcePerson,
        venue: _venue,
        registered: [],
        coordinator: _coordinator,
        bannerImage: _bannerImage,
        logoImage: _logoImage,
      );

      try {
        // Sending event data to Firestore and getting the document reference
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('events')
            .add(event.toMap());

        // Update the event with the generated ID
        await docRef.update({'id': docRef.id});

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );

        // Optionally, clear the form or navigate back
        _formKey.currentState!.reset();
        _startDateController.clear();
        _endDateController.clear();
        _startTimeController.clear();
        _endTimeController.clear();
      } catch (e) {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _eventName = value!;
                  },
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date (YYYY-MM-DD)',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date (YYYY-MM-DD)',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time (HH:MM)',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context, false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'End Time (HH:MM)',
                      ),
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Limit Students'),
                  value: _isLimitedStudent,
                  onChanged: (bool value) {
                    setState(() {
                      _isLimitedStudent = value;
                    });
                  },
                ),
                if (_isLimitedStudent)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Student Limit'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter student limit';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _studentLimit = int.parse(value!);
                    },
                  ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Resource Person'),
                  onSaved: (value) {
                    _resourcePerson = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Venue'),
                  onSaved: (value) {
                    _venue = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Coordinator'),
                  onSaved: (value) {
                    _coordinator = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Banner Image URL'),
                  onSaved: (value) {
                    _bannerImage = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Logo Image URL'),
                  onSaved: (value) {
                    _logoImage = value!;
                  },
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
