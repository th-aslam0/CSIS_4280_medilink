import 'package:flutter/material.dart';
import 'package:group02_medilink/homepageDoctorList.dart';
import 'package:group02_medilink/doctorDetail.dart';
import 'package:group02_medilink/doctorInfo.dart';
import 'package:group02_medilink/appointmentDetails.dart';
void main() {
  runApp(MaterialApp(
    home: AppointmentDetails(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/doctorPage': (context) => DoctorDetail(),
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<Map<String, dynamic>> doctors = [
    {
      "_id": "603d9f1f3f1c2b001f5a5bca",
      "first_name": "Dr. James",
      "last_name": "Taylor",
      "specialization": "General Practitioner",
      "email": "dr.james.taylor@email.com",
      "phone_number": "+1 555 123 4567",
      "office_address": {
        "street": "789 Health St",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V6B 1A1"
      },
      "availability": [
        {"day": "Monday", "hours": "09:00-12:00"},
        {"day": "Wednesday", "hours": "14:00-18:00"}
      ],
      "consultation_fee": 100,
      "created_at": "2025-01-15T10:00:00Z",
      "updated_at": "2025-02-20T16:00:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bcb",
      "first_name": "Dr. Sarah",
      "last_name": "Lee",
      "specialization": "Cardiologist",
      "email": "dr.sarah.lee@email.com",
      "phone_number": "+1 555 234 5678",
      "office_address": {
        "street": "321 Heart Ave",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V5T 2A2"
      },
      "availability": [
        {"day": "Tuesday", "hours": "10:00-13:00"},
        {"day": "Thursday", "hours": "15:00-18:00"}
      ],
      "consultation_fee": 150,
      "created_at": "2025-01-20T11:30:00Z",
      "updated_at": "2025-02-25T13:00:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bcc",
      "first_name": "Dr. Emily",
      "last_name": "Clark",
      "specialization": "Pediatrician",
      "email": "dr.emily.clark@email.com",
      "phone_number": "+1 555 345 6789",
      "office_address": {
        "street": "123 Family Rd",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V7X 1B1"
      },
      "availability": [
        {"day": "Monday", "hours": "10:00-14:00"},
        {"day": "Thursday", "hours": "09:00-12:00"}
      ],
      "consultation_fee": 120,
      "created_at": "2025-01-22T12:00:00Z",
      "updated_at": "2025-02-20T14:00:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bcd",
      "first_name": "Dr. Daniel",
      "last_name": "Roberts",
      "specialization": "Neurologist",
      "email": "dr.daniel.roberts@email.com",
      "phone_number": "+1 555 456 7890",
      "office_address": {
        "street": "567 Neuro Blvd",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V6P 2G3"
      },
      "availability": [
        {"day": "Tuesday", "hours": "11:00-15:00"},
        {"day": "Friday", "hours": "14:00-17:00"}
      ],
      "consultation_fee": 180,
      "created_at": "2025-01-18T13:30:00Z",
      "updated_at": "2025-02-22T10:30:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bce",
      "first_name": "Dr. Olivia",
      "last_name": "Miller",
      "specialization": "Orthopedic Surgeon",
      "email": "dr.olivia.miller@email.com",
      "phone_number": "+1 555 567 8901",
      "office_address": {
        "street": "678 Bone St",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V7P 3R9"
      },
      "availability": [
        {"day": "Monday", "hours": "08:00-12:00"},
        {"day": "Wednesday", "hours": "13:00-17:00"}
      ],
      "consultation_fee": 200,
      "created_at": "2025-01-30T14:00:00Z",
      "updated_at": "2025-02-25T11:00:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bcf",
      "first_name": "Dr. Thomas",
      "last_name": "Young",
      "specialization": "Dermatologist",
      "email": "dr.thomas.young@email.com",
      "phone_number": "+1 555 678 9012",
      "office_address": {
        "street": "789 Skin Ave",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V5T 4P1"
      },
      "availability": [
        {"day": "Monday", "hours": "09:00-12:00"},
        {"day": "Friday", "hours": "14:00-17:00"}
      ],
      "consultation_fee": 140,
      "created_at": "2025-02-05T15:30:00Z",
      "updated_at": "2025-02-20T12:30:00Z"
    },
    {
      "_id": "603d9f1f3f1c2b001f5a5bd0",
      "first_name": "Dr. Patricia",
      "last_name": "Harris",
      "specialization": "Psychiatrist",
      "email": "dr.patricia.harris@email.com",
      "phone_number": "+1 555 789 0123",
      "office_address": {
        "street": "123 Mind St",
        "city": "Vancouver",
        "province": "BC",
        "postal_code": "V6P 1N3"
      },
      "availability": [
        {"day": "Wednesday", "hours": "09:00-12:00"},
        {"day": "Friday", "hours": "13:00-17:00"}
      ],
      "consultation_fee": 220,
      "created_at": "2025-02-10T16:00:00Z",
      "updated_at": "2025-02-22T09:30:00Z"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> doctorData = doctors[index];
                return GestureDetector(
                  onTap: () {
                    Doctor doctor = Doctor(
                        doctorData['_id'],
                        doctorData['first_name'],
                        doctorData['last_name'],
                        doctorData['specialization'],
                        doctorData['email'],
                        doctorData['phone_number'],
                        doctorData['office_address'],
                        doctorData['availability'],
                        doctorData['consultation_fee'],
                        doctorData['created_at'],
                        doctorData['updated_at']);
                    Navigator.pushNamed(
                      context,
                      '/doctorPage',
                      arguments: doctor,
                    );
                  },
                  child: ListTile(
                    title: Text(doctorData['first_name']),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
