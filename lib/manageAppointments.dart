import 'package:flutter/material.dart';

class ManageAppointments extends StatelessWidget {
  final List<Map<String, String>> appointments = [
    {
      "type": "General Consultation",
      "first_name": "Dr. James",
      "last_name": "Taylor",
      "date": "2025-01-15T10:00:00Z",
      "description": "Routine checkup"
    },
    {
      "type": "Cardiology Checkup",
      "first_name": "Dr. Sarah",
      "last_name": "Lee",
      "date": "2025-02-12T14:30:00Z",
      "description": "Heart checkup"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Appointments"),
        backgroundColor: Colors.blue,
      ),
      body: appointments.isEmpty
          ? Center(child: Text("No appointments yet"))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          String formattedDate = appointment["date"]!;  // Full ISO format with time
          String doctorName = "${appointment['first_name']} ${appointment['last_name']}";

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text("$doctorName"),
              subtitle: Text("Date & Time: $formattedDate\nDescription: ${appointment['description']}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  //delete handler
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment deleted')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
