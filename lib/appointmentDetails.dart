import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bookingSuccessful.dart';

void main() {
  runApp(MaterialApp(
    home: AppointmentDetails(),
  ));
}

class AppointmentDetails extends StatefulWidget {
  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String? _selectedDoctor;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _problemDescription;
  TextEditingController _problemDescriptionController = TextEditingController();

  @override
  void dispose() {
    _problemDescriptionController.dispose();
    super.dispose();
  }

  final Map<String, List<String>> typeToSpecialization = {
    "General Consultation": ["General Practitioner"],
    "Cardiology Checkup": ["Cardiologist"],
    "Pediatric Consultation": ["Pediatrician"],
    "Neurology Consultation": ["Neurologist"],
    "Orthopedic Examination": ["Orthopedic Surgeon"],
    "Dermatology Checkup": ["Dermatologist"],
    "Psychiatric Assessment": ["Psychiatrist"]
  };

  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. James Taylor",
      "specialization": "General Practitioner",
      "availability": {"Monday": "09:00-12:00", "Wednesday": "14:00-18:00"}
    },
    {
      "name": "Dr. Sarah Lee",
      "specialization": "Cardiologist",
      "availability": {"Tuesday": "10:00-13:00", "Thursday": "15:00-18:00"}
    },
    {
      "name": "Dr. Emily Clark",
      "specialization": "Pediatrician",
      "availability": {"Monday": "10:00-14:00", "Thursday": "09:00-12:00"}
    },
    {
      "name": "Dr. Daniel Roberts",
      "specialization": "Neurologist",
      "availability": {"Tuesday": "11:00-15:00", "Friday": "14:00-17:00"}
    },
    {
      "name": "Dr. Olivia Miller",
      "specialization": "Orthopedic Surgeon",
      "availability": {"Monday": "08:00-12:00", "Wednesday": "13:00-17:00"}
    },
    {
      "name": "Dr. Thomas Young",
      "specialization": "Dermatologist",
      "availability": {"Monday": "09:00-12:00", "Friday": "14:00-17:00"}
    },
    {
      "name": "Dr. Patricia Harris",
      "specialization": "Psychiatrist",
      "availability": {"Wednesday": "09:00-12:00", "Friday": "13:00-17:00"}
    }
  ];

  List<String> getAvailableDoctors() {
    if (_selectedType == null) return [];
    List<String> matchingSpecializations = typeToSpecialization[_selectedType!] ?? [];
    return doctors
        .where((doc) => matchingSpecializations.contains(doc["specialization"]))
        .map((doc) => doc["name"] as String)
        .toList();
  }

  List<String> getAvailableTimes(String doctor, DateTime date) {
    String weekday = DateFormat('EEEE').format(date);
    var doctorData = doctors.firstWhere((doc) => doc["name"] == doctor, orElse: () => {});
    if (doctorData.isEmpty || !doctorData["availability"].containsKey(weekday)) return [];
    return doctorData["availability"][weekday].split('-');
  }

  bool isDateAvailable(DateTime date) {
    if (_selectedDoctor == null) return false;
    String weekday = DateFormat('EEEE').format(date);
    var doctorData = doctors.firstWhere((doc) => doc["name"] == _selectedDoctor, orElse: () => {});
    return doctorData.isNotEmpty && doctorData["availability"].containsKey(weekday);
  }

  Future<void> _selectDate(BuildContext context) async {
    //disable before select doctor
    if (_selectedDoctor == null) return;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),

      //disable unavailable date
      selectableDayPredicate: (date) => isDateAvailable(date),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = null;
      });
    }
  }

  //check nearest available day to prevent datepicker error
  DateTime? getNearestAvailableDate(String doctor, DateTime fromDate) {
    var doctorData = doctors.firstWhere(
            (doc) => doc["name"] == doctor,
        orElse: () => {});

    if (doctorData.isEmpty) return null;

    for (int i = 0; i < 30; i++) {
      DateTime checkDate = fromDate.add(Duration(days: i));
      String weekday = DateFormat('EEEE').format(checkDate);

      if (doctorData["availability"].containsKey(weekday)) {
        return checkDate;
      }
    }
    // no date found
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment"),backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // appointment type
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Appointment Type"),
                value: _selectedType,
                items: typeToSpecialization.keys.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value as String?;
                    _selectedDoctor = null;
                    _selectedDate = null;
                    _selectedTime = null;
                  });
                },
                validator: (value) => value == null ? 'Please select an appointment type' : null,
              ),

              // doctor select
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Select Doctor"),
                value: _selectedDoctor,
                items: getAvailableDoctors()
                    .map((doc) => DropdownMenuItem(value: doc, child: Text(doc)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value as String?;
                    _selectedDate = null;
                    _selectedTime = null;
                  });
                },
                validator: (value) => value == null ? 'Please select a doctor' : null,
                disabledHint: Text("Select a appointment type first"),
              ),

              // date pciker
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Select Date",
                  hintText: _selectedDate == null ? "Please select a date" : "",
                ),
                readOnly: true,
                onTap: _selectedDoctor != null
                    ? () async {
                  DateTime now = DateTime.now();
                  DateTime? nearestAvailableDate = getNearestAvailableDate(_selectedDoctor!, now);

                  if (nearestAvailableDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No available dates for this doctor!")),
                    );
                    return;
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: nearestAvailableDate,
                    firstDate: now,
                    lastDate: DateTime(2030),
                    selectableDayPredicate: (DateTime day) {
                      String weekday = DateFormat('EEEE').format(day);
                      var doctorData = doctors.firstWhere(
                              (doc) => doc["name"] == _selectedDoctor,
                          orElse: () => {});

                      return doctorData.isNotEmpty && doctorData["availability"].containsKey(weekday);
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _selectedTime = null;
                    });
                  }
                }
                    //no doctor select
                    : null,
                controller: TextEditingController(
                  text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
              ),

              // time select
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Available Time"),
                value: _selectedTime,
                items: (_selectedDoctor != null && _selectedDate != null
                    ? getAvailableTimes(_selectedDoctor!, _selectedDate!)
                    : [])
                    .map((time) => DropdownMenuItem(value: time, child: Text(time)))
                    .toList(),
                onChanged: (_selectedDoctor != null && _selectedDate != null)
                    ? (value) => setState(() => _selectedTime = value as String?)
                    : null,
                validator: (value) => value == null ? 'Please select a time slot' : null,
                disabledHint: Text("Select a date first"),
              ),

              // problem desc
              TextFormField(
                controller: _problemDescriptionController,
                decoration: InputDecoration(labelText: "Problem Description"),
                maxLines: 3,
                onChanged: (value) => _problemDescription = value,
              ),

              SizedBox(height: 20),

              // submit
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Appointment Type: $_selectedType");
                    print("Doctor: $_selectedDoctor");
                    print("Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Not selected'}");
                    print("Time: $_selectedTime");
                    print("Problem Description: ${_problemDescription ?? 'Not provided'}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Thank you for booking!"),
                      ),
                    );

                    // clear form
                    setState(() {
                      _selectedType = null;
                      _selectedDoctor = null;
                      _selectedDate = null;
                      _selectedTime = null;
                      _problemDescription = null;
                      _problemDescriptionController.clear();
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingSuccessful()),
                    );
                  }
                },
                child: Text("Book Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
