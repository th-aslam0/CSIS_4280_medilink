import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoctorController extends GetxController {
  var doctorList = <Map<String,dynamic>>[].obs;
  var singleDoctor = Rxn<Map<String, dynamic>>();

  var services = <Map<String,dynamic>>[
    { "service_name": "General Consultation", "specialization": "General Practitioner" },
    { "service_name": "Pediatric Consultation", "specialization": "Pediatrician" },
    { "service_name": "Cardiology Checkup", "specialization": "Cardiologist" },
    { "service_name": "Dermatology Consultation", "specialization": "Dermatologist" },
    { "service_name": "Orthopedic Consultation", "specialization": "Orthopedic Surgeon" },
    { "service_name": "Neurology Consultation", "specialization": "Neurologist" },
    { "service_name": "Endocrinology Consultation", "specialization": "Endocrinologist" },
    { "service_name": "Gastroenterology Consultation", "specialization": "Gastroenterologist" },
    { "service_name": "Psychiatric Consultation", "specialization": "Psychiatrist" },
    { "service_name": "Psychology Counseling", "specialization": "Psychologist" },
    { "service_name": "Ophthalmology Consultation", "specialization": "Ophthalmologist" },
    { "service_name": "ENT Consultation", "specialization": "Otolaryngologist" },
    { "service_name": "Urology Consultation", "specialization": "Urologist" },
    { "service_name": "Nephrology Consultation", "specialization": "Nephrologist" },
    { "service_name": "Allergy & Immunology Consultation", "specialization": "Allergist/Immunologist" },
    { "service_name": "Rheumatology Consultation", "specialization": "Rheumatologist" },
    { "service_name": "Pulmonology Consultation", "specialization": "Pulmonologist" },
    { "service_name": "Gynecology Consultation", "specialization": "Gynecologist" },
    { "service_name": "Dietitian/Nutritionist Consultation", "specialization": "Dietitian/Nutritionist" },
    { "service_name": "Physical Therapy Session", "specialization": "Physiotherapist" }
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDoctor();
  }

  Future<void> fetchDoctor() async {

    final response = await http.get(
      Uri.parse('http://192.168.1.157:8080/api/doctors'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseArray = jsonDecode(response.body);

      doctorList.value = responseArray.map((item)=>item as Map<String, dynamic>).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load doctors');
    }
  }

  Future<void> fetchDoctorById(String id) async {

    final response = await http.get(
      Uri.parse('http://192.168.1.157:8080/api/doctors/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      singleDoctor.value = Map<String, dynamic>.from(data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load doctor');
    }
  }



}