import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/controller/appointmentController.dart';
import 'package:group02_medilink/controller/doctorController.dart';
import 'package:group02_medilink/payment.dart';
import 'package:group02_medilink/videoCall.dart';
import 'package:intl/intl.dart';

class ManageAppointments extends StatelessWidget {
  final AppointmentController appointmentController = Get.find();
  final DoctorController doctorController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Fetch appointments for each appointment
    appointmentController.fetchAppointmentByPatientId(appointmentController.patientId.value);

    if (doctorController.doctorList.isEmpty) {
      doctorController.fetchDoctor();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Appointments"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (appointmentController.appointmentByPatientList.isEmpty) {
          return Center(child: Text("No appointments yet"));
        }

        //
        var sortedAppointments = List.from(appointmentController.appointmentByPatientList);

        DateTime now = DateTime.now();

        // Sort appointments
        sortedAppointments.sort((a, b) {
          String dateA = a["date"]!;
          String dateB = b["date"]!;

          DateTime dateTimeA;
          DateTime dateTimeB;

          try {
            dateTimeA = DateFormat('yyyy-MM-dd').parse(dateA.split(' ')[0]);
            dateTimeB = DateFormat('yyyy-MM-dd').parse(dateB.split(' ')[0]);
          } catch (e) {
            return 0;
          }

          bool isPastA = dateTimeA.isBefore(now);
          bool isPastB = dateTimeB.isBefore(now);

          // past go bottom, near date go up
          if (isPastA && !isPastB) return 1;
          if (!isPastA && isPastB) return -1;

          // if both not past, newest go up
          if (!isPastA && !isPastB) {
            return dateTimeA.compareTo(dateTimeB);
          }

          // if both past, newest go down
          return dateTimeB.compareTo(dateTimeA);
        });
        //
        return ListView.builder(
          //itemCount: appointmentController.appointmentByPatientList.length,
          itemCount: sortedAppointments.length,
          itemBuilder: (context, index) {
            //final appointment = appointmentController.appointmentByPatientList[index];
            final appointment = sortedAppointments[index];
            String formattedDate = appointment["date"]!;
            String doctorId = appointment['doctorId'];

            //past appointment become grey
            DateTime appointmentDate;
            try {
              appointmentDate = DateFormat('yyyy-MM-dd').parse(formattedDate.split(' ')[0]);
            } catch (e) {
              appointmentDate = DateTime.now();
              print("Error parsing: $e");
            }

            // Check if appointment is in the past
            bool isPastAppointment = appointmentDate.isBefore(DateTime.now());

            //match doctor name with id
            var doctor = doctorController.doctorList.firstWhere(
                    (doc) => doc['id'].toString() == doctorId,
                orElse: () => {'firstName': 'Unknown', 'lastName': 'Doctor'}
            );

            String doctorName = "${doctor['firstName']} ${doctor['lastName']}";

            return Card(
              margin: EdgeInsets.all(10),
              color: isPastAppointment ? Colors.grey[250] : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(doctorName),
                      subtitle: Text(
                        "Date & Time: $formattedDate\nDescription: ${appointment['patientDesc']}",
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: isPastAppointment ? Colors.grey[400] : Colors.red),
                        onPressed: () async {
                          if (await appointmentController.deleteAppointment(appointment['id'])) {
                            appointmentController.fetchAppointmentByPatientId(
                                appointmentController.patientId.value);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Appointment deleted')));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Failed to delete appointment')));
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VideoCall(doctorName: doctorName,
                              patientId: appointmentController.patientId.value,
                              doctorId: doctorId,)),
                          );
                        },
                        child: Text("Proceed to appointment call"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}