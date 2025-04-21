import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/controller/doctorController.dart';
import 'package:group02_medilink/controller/appointmentController.dart';
import 'package:group02_medilink/payment.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

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

  final DoctorController _doctorController = Get.find();
  final AppointmentController appointmentController = Get.find();

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

  List<double> getHourChoices(String range) {
    List<String> parts = range.split('-');
    double start = double.parse(parts[0]);
    double end = double.parse(parts[1]);

    List<double> choices = [];
    for (double hour = start; hour < end; hour++) {
      choices.add(hour);
    }

    return choices;
  }

  List<String> getAvailableDoctors() {
    if (_selectedType == null) return [];
    List<String> matchingSpecializations = typeToSpecialization[_selectedType!] ?? [];
    return _doctorController.doctorList
        .where((doc) => matchingSpecializations.contains(doc["specialization"]))
        .map((doc) => doc["firstName"] as String)
        .toList();
  }



  //new version based on real Doctor model
  List<String> getAvailableTimes(String doctor, DateTime date) {
    String weekday = DateFormat('EEEE').format(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    var doctorData = _doctorController.doctorList.firstWhere(
          (doc) => doc["firstName"] == doctor,
      orElse: () => {},
    );

    if (doctorData.isEmpty || doctorData["availability"] == null) return [];

    var availabilityForDay = doctorData["availability"].firstWhere(
          (slot) => slot["day"] == weekday,
      orElse: () => null,
    );

    if (availabilityForDay == null || availabilityForDay["hours"] == null) return [];

    var hours = availabilityForDay["hours"].split('-');

    DateTime startTime = DateFormat("HH:mm").parse(hours[0]);
    DateTime endTime = DateFormat("HH:mm").parse(hours[1]);

    List<String> timeSlots = [];
    while (startTime.isBefore(endTime)) {
      timeSlots.add(DateFormat("HH:mm").format(startTime));
      startTime = startTime.add(Duration(hours: 1));
    }

    // Filter out already booked appointments
    List<String> availableTimeSlots = filterBookedTimeSlots(
        timeSlots,
        doctorData["id"],
        formattedDate
    );

    return availableTimeSlots;
  }

  List<String> filterBookedTimeSlots(List<String> allTimeSlots, String doctorId, String date) {
    List<Map<String, dynamic>> bookedAppointments = appointmentController.appointmentList
        .where((appointment) {
      String appointmentDateStr = appointment["date"];
      List<String> parts = appointmentDateStr.split('-');
      if (parts.length >= 3) {
        String appointmentDate = "${parts[0]}-${parts[1]}-${parts[2]}";
        return appointment["doctorId"] == doctorId && appointmentDate == date;
      }
      return false;
    }).toList();

    // Get booked time
    List<String> bookedTimes = bookedAppointments.map((appointment) {
      List<String> parts = appointment["date"].split('-');
      if (parts.length >= 5) {
        // change to 09:00 format
        return "${parts[3]}:${parts[4]}";
      }
      return "";
    }).where((time) => time.isNotEmpty).toList();

    // Filter out booked time
    return allTimeSlots.where((slot) => !bookedTimes.contains(slot)).toList();
  }


  //new version based on real Doctor model
  bool isDateAvailable(DateTime date) {
    if (_selectedDoctor == null) return false;

    String weekday = DateFormat('EEEE').format(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    var doctorData = _doctorController.doctorList.firstWhere(
          (doc) => doc["firstName"] == _selectedDoctor,
      orElse: () => {},
    );

    if (doctorData.isEmpty || doctorData["availability"] == null) return false;

    bool isWeekdayAvailable = doctorData["availability"].any((slot) => slot["day"] == weekday);

    // No availble date at all
    if (!isWeekdayAvailable) return false;

    // check time slots for that day
    var availabilityForDay = doctorData["availability"].firstWhere(
          (slot) => slot["day"] == weekday,
      orElse: () => null,
    );

    if (availabilityForDay == null || availabilityForDay["hours"] == null) return false;

    var hours = availabilityForDay["hours"].split('-');
    DateTime startTime = DateFormat("HH:mm").parse(hours[0]);
    DateTime endTime = DateFormat("HH:mm").parse(hours[1]);

    List<String> timeSlots = [];
    while (startTime.isBefore(endTime)) {
      timeSlots.add(DateFormat("HH:mm").format(startTime));
      startTime = startTime.add(Duration(hours: 1));
    }

    // Filter out already booked time slots
    List<String> availableTimeSlots = filterBookedTimeSlots(
        timeSlots,
        doctorData["id"],
        formattedDate
    );

    // Disable date if no time slot
    return availableTimeSlots.isNotEmpty;
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

  //new version based on real Doctor model
  DateTime? getNearestAvailableDate(String doctor, DateTime fromDate) {
    var doctorData = _doctorController.doctorList.firstWhere(
          (doc) => doc["firstName"] == doctor,
      orElse: () => {},
    );

    if (doctorData.isEmpty || doctorData["availability"] == null) return null;

    for (int i = 0; i < 30; i++) {
      DateTime checkDate = fromDate.add(Duration(days: i));
      if (isDateAvailable(checkDate)) {
        return checkDate;
      }
    }

    //No avaible date in the next 30 days
    return null;
  }

  Future<bool> addAppointment(Map<String,dynamic> requestBody) async{
    //var ipAddress = '192.168.1.157';
    var ipAddress = '10.0.2.2';

    print('Request Body: ${requestBody}');

    try {
      final response = await http.post(
        Uri.parse('http://${ipAddress}:8080/api/appointments/book'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if(response.statusCode == 200 || response.statusCode == 201) {

        return true;
      }
      else {
        print('Error add: ${response.statusCode}');

        return false;
      }
    } catch (e) {
      print('Error add: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search or Asks AI',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

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

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Select Date",
                      hintText: _selectedDoctor == null ? "Please select a doctor first" : "",
                    ),
                    readOnly: true,
                    onTap: _selectedDoctor != null
                        ? () async {
                      // First, fetch the latest appointments
                      await appointmentController.fetchAppointment();

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
                        selectableDayPredicate: isDateAvailable,
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _selectedTime = null;
                        });
                      }
                    }
                        : null,
                    controller: TextEditingController(
                      text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please select a date' : null,
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

                  SizedBox(height: 50),

                  // submit
                  ElevatedButton(
                    onPressed: () async {
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

                        //Hardcode patient Id
                        final String _patientId = "67f368ba18e7ac37286aa89e";

                        var doctorData = _doctorController.doctorList.firstWhere(
                              (doc) => doc["firstName"] == _selectedDoctor,
                          orElse: () => {},
                        );


                        // Combine into a single string that can be parsed
                        String dateTimeString = "${DateFormat('yyyy-MM-dd').format(_selectedDate!)} $_selectedTime";

                        // Parse to DateTime object
                        DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeString);
                        // Format to desired output
                        String formattedDateTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(dateTime);


                        //build requestBody
                        final Map<String,dynamic> requestBody = {
                          "patientId": appointmentController.patientId.value,
                          "doctorId": doctorData["id"],
                          "date": formattedDateTime,
                          "patientDesc": _problemDescription,
                          "status": "Pending",
                          "fee": doctorData["consultationFee"],
                          "prescription": "Pending",
                          "specialization": doctorData["specialization"]
                        };

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
                          MaterialPageRoute(builder: (context) => Payment(requestBody)),
                        );

                        // if(await addAppointment(requestBody)){
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(SnackBar(content: Text('Successfully booked')));
                        //   // clear form
                        //   setState(() {
                        //     _selectedType = null;
                        //     _selectedDoctor = null;
                        //     _selectedDate = null;
                        //     _selectedTime = null;
                        //     _problemDescription = null;
                        //     _problemDescriptionController.clear();
                        //   });
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => Payment(requestBody)),
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context)
                        //       .showSnackBar(SnackBar(content: Text('Failed booking appointment')));
                        // }
                      }
                    },
                    child: Text("Book Appointment"),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
