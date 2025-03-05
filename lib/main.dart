import 'package:flutter/material.dart';
import 'package:group02_medilink/homepageDoctorList.dart';
import 'package:group02_medilink/doctorDetail.dart';
import 'package:group02_medilink/doctorInfo.dart';

void main() {
  runApp(Homepage());
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
