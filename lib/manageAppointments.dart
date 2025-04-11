import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/controller/appointmentController.dart';
import 'package:group02_medilink/controller/doctorController.dart';

class ManageAppointments extends StatelessWidget {


  final AppointmentController appointmentController = Get.find();
  final DoctorController doctorController = Get.find();

  @override
  Widget build(BuildContext context) {
    appointmentController.fetchAppointmentByPatientId(appointmentController.patientId.value);
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Appointments"),
        backgroundColor: Colors.blue,
      ),
      body: appointmentController.appointmentByPatientList.isEmpty
          ? Center(child: Text("No appointments yet"))
          : ListView.builder(
        itemCount: appointmentController.appointmentByPatientList.length,
        itemBuilder: (context, index) {
          final appointment = appointmentController.appointmentByPatientList[index];
          String formattedDate = appointment["date"]!;  // Full ISO format with time

          doctorController.fetchDoctorById(appointment['doctorId']);
          String doctorName = "${doctorController.singleDoctor.value?['firstName']} "
              "${doctorController.singleDoctor.value?['lastName']}";

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text("$doctorName"),
              subtitle: Text("Date & Time: $formattedDate\nDescription: ${appointment['patientDesc']}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  //delete handler
                  // if(await appointmentController.deleteAppointment(appointment['id'])) {
                  //   appointmentController.fetchAppointmentByPatientId(appointmentController.patientId.value);
                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(SnackBar(content: Text('Appointment deleted')));
                  // } else {
                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(SnackBar(content: Text('Failed to delete appointment')));
                  //
                  // }

                },
              ),
            ),
          );
        },
      ),
    );
  }
}
