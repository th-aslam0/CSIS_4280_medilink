import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/controller/doctorController.dart';
import 'package:group02_medilink/doctorInfo.dart';

class DoctorDetail extends StatelessWidget {

  final DoctorController doctorController = Get.find();

  @override
  Widget build(BuildContext context) {

    final String doctorId = ModalRoute.of(context)!.settings.arguments as String;
    doctorController.fetchDoctorById(doctorId);

    final doctor = doctorController.singleDoctor.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Doctor's Photo
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Icon(Icons.person, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Doctor's Name
              Center(
                child: Obx(() {
                  final doctor = doctorController.singleDoctor.value;

                  if (doctor == null) {
                    return const SizedBox(); // or a loading widget
                  }
                  return Text(
                    '${doctor?['firstName']} ${doctor?['lastName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  );
                })
              ),
              SizedBox(height: 8),

              // Specialization
              Center(
                child: Obx(() {
                  final doctor = doctorController.singleDoctor.value;

                  if (doctor == null) {
                    return const SizedBox(); // or a loading widget
                  }
                  return Text(
                    doctor?['specialization'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  );
                })
              ),
              SizedBox(height: 8),

              // Contact Information
              _buildSectionTitle('Contact Information'),
              SizedBox(height: 8),
              Obx(() {
                final doctor = doctorController.singleDoctor.value;

                if (doctor == null) {
                  return const SizedBox(); // or a loading widget
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.email, color: Colors.deepPurple),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          doctor?['email'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // _buildDetailRow(Icons.email, doctor?['email']),
              Obx(() {
                final doctor = doctorController.singleDoctor.value;

                if (doctor == null) {
                  return const SizedBox(); // or a loading widget
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.phone, color: Colors.deepPurple),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          doctor?['phoneNumber'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              //_buildDetailRow(Icons.phone, doctor?['phoneNumber']),
              SizedBox(height: 8),
              // Office Address
              _buildSectionTitle('Office Address'),
              SizedBox(height: 8),
              Obx(() {
                final doctor = doctorController.singleDoctor.value;

                if (doctor == null) {
                  return const SizedBox(); // or a loading widget
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.deepPurple),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${doctor?['officeAddress']['street']}, '
                              '${doctor?['officeAddress']['city']}, '
                              '${doctor?['officeAddress']['province']} '
                              '${doctor?['officeAddress']['postal_code']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 8),

              // Availability
              _buildSectionTitle('Availability'),
              SizedBox(height: 8),
              Obx(() {
                final doctor = doctorController.singleDoctor.value;

                if (doctor == null || doctor['availability'] == null) {
                  return const CircularProgressIndicator(); // Loading state
                }

                List<Widget> availabilityWidgets = [];
                doctor['availability'].forEach((availability) {
                  availabilityWidgets.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_today, color: Colors.deepPurple),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                '${availability['day']}: ${availability['hours']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )
                  );
                });
                return Column(
                  children: availabilityWidgets,
                );
              }),
              // ...doctor?['availability'].map((availability) => _buildDetailRow(
              //     Icons.calendar_today,
              //     '${availability['day']}: ${availability['hours']}')),
              SizedBox(height: 8),

              // Consultation Fee
              _buildSectionTitle('Consultation Fee'),
              SizedBox(height: 8),
              Obx(() {
                final doctor = doctorController.singleDoctor.value;

                if (doctor == null) {
                  return const SizedBox(); // or a loading widget
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.attach_money, color: Colors.deepPurple),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '\$${doctor?['consultationFee']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // _buildDetailRow(
              //     Icons.attach_money, '\$${doctor?['consultationFee']}'),
              SizedBox(height: 8),
              // _buildDetailRow(Icons.create, 'Created at: ${doctor.createdAt}'),
              // _buildDetailRow(Icons.update, 'Updated at: ${doctor.updatedAt}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/bookingPage');
                      },
                      child: Text(
                        "Book Appointment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      doctorController.fetchDoctor();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build section titles
  Widget _buildSectionTitle(String title) {

      return Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      );


  }

  // Helper function to build detail rows
  Widget _buildDetailRow(IconData icon, String text) {

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.deepPurple),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );

  }
}
