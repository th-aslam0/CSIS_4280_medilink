import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/appointmentDetails.dart';
import 'package:group02_medilink/controller/appointmentController.dart';
import 'package:group02_medilink/controller/doctorController.dart';
import 'package:group02_medilink/dataLists.dart';
import 'package:group02_medilink/doctorDetail.dart';
import 'package:group02_medilink/doctorInfo.dart';
import 'package:group02_medilink/registrationForm.dart';

import 'manageAppointments.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Startup Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/doctorPage': (context) => DoctorDetail(),
        '/bookingPage': (context) => AppointmentDetails(),
        '/registerPage': (context) => RegistrationPage()
      },
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final DoctorController _doctorController = Get.put(DoctorController());
  final AppointmentController _appointmentController = Get.put(AppointmentController());

  void _bookDoctorAppointment() {}

  void _bookServiceAppointment() {}

  final TextEditingController _searchingInputController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MediLink Home Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Welcome to MediLink',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text('Login',
                    style: TextStyle(
                      color: Colors.blue, // Make it look clickable
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/registerPage');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blue, // Make it look clickable
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextField(
              controller: _searchingInputController,
              decoration: InputDecoration(
                hintText: 'Search or ask AI assistant',
                prefixIcon: Icon(Icons.search),
                // Search icon inside TextField
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onSubmitted: (value) {
                // Handle search input here
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Searching $value")));
                _searchingInputController.clear();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(()=>Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _doctorController.services.length,
                itemBuilder: (context, index) {
                  final service = _doctorController.services[index];
                  return Container(
                    width: 185,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Text(service['service_name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/bookingPage');
                              },
                              child: Text(
                                "Book Appointment",
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    ),
                  );
                },
              ))
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Doctors",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() =>Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _doctorController.doctorList.length,
                itemBuilder: (context, index) {
                  final doctor = _doctorController.doctorList[index];
                  return Container(
                    width: 185,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final String doctorId = doctor["id"];

                            Navigator.pushNamed(
                              context,
                              '/doctorPage',
                              arguments: doctorId,
                            );
                          },
                          child: Column(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  doctor['image'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                doctor['firstName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                doctor['specialization'],
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/bookingPage');
                              },
                              child: Text(
                                "Book Appointment",
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    ),
                  );
                },
              ))
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageAppointments()),
                  );
                },
                child: Text(
                  "Manage Appointments",
                  textAlign: TextAlign.center,
                )),
          )
        ],
      )),
    );
  }
}
