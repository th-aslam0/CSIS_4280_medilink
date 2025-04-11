import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/controller/appointmentController.dart';

import 'appointmentDetails.dart';
import 'manageAppointments.dart';

class BookingSuccessful extends StatelessWidget {

  final AppointmentController appointmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    final String patientId = appointmentController.patientId.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Successful"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 80),

              // success text
              Text(
                "Thank you for your booking!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 60),

              // buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Home Page"),
              ),

              SizedBox(height: 30),

              // manage appontments button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  appointmentController.fetchAppointmentByPatientId(patientId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageAppointments()),
                  );
                },
                child: Text("Manage Appointments"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
