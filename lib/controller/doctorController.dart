import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoctorController extends GetxController {
  var doctorList = <Map<String,dynamic>>[
    {
      "first_name": "Dr. James",
      "last_name": "Taylor",
      "specialization": "General Practitioner",
      "email": "dr.james.taylor@email.com",
      "phone_number": "+1 555 123 4567",
      "office_address": { "street": "789 Health St", "city": "Vancouver", "province": "BC", "postal_code": "V6B 1A1" },
      "availability": [{ "day": "Monday", "hours": "09:00-12:00" }, { "day": "Wednesday", "hours": "14:00-18:00" }],
      "consultation_fee": 100,
      "created_at": "2025-01-15T10:00:00Z",
      "updated_at": "2025-02-20T16:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Sarah",
      "last_name": "Lee",
      "specialization": "Cardiologist",
      "email": "dr.sarah.lee@email.com",
      "phone_number": "+1 555 234 5678",
      "office_address": { "street": "321 Heart Ave", "city": "Vancouver", "province": "BC", "postal_code": "V5T 2A2" },
      "availability": [{ "day": "Tuesday", "hours": "10:00-13:00" }, { "day": "Thursday", "hours": "15:00-18:00" }],
      "consultation_fee": 150,
      "created_at": "2025-01-20T11:30:00Z",
      "updated_at": "2025-02-25T13:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Emily",
      "last_name": "Clark",
      "specialization": "Pediatrician",
      "email": "dr.emily.clark@email.com",
      "phone_number": "+1 555 345 6789",
      "office_address": { "street": "123 Family Rd", "city": "Vancouver", "province": "BC", "postal_code": "V7X 1B1" },
      "availability": [{ "day": "Monday", "hours": "10:00-14:00" }, { "day": "Thursday", "hours": "09:00-12:00" }],
      "consultation_fee": 120,
      "created_at": "2025-01-22T12:00:00Z",
      "updated_at": "2025-02-20T14:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Daniel",
      "last_name": "Roberts",
      "specialization": "Neurologist",
      "email": "dr.daniel.roberts@email.com",
      "phone_number": "+1 555 456 7890",
      "office_address": { "street": "567 Neuro Blvd", "city": "Vancouver", "province": "BC", "postal_code": "V6P 2G3" },
      "availability": [{ "day": "Tuesday", "hours": "11:00-15:00" }, { "day": "Friday", "hours": "14:00-17:00" }],
      "consultation_fee": 180,
      "created_at": "2025-01-18T13:30:00Z",
      "updated_at": "2025-02-22T10:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Olivia",
      "last_name": "Miller",
      "specialization": "Orthopedic Surgeon",
      "email": "dr.olivia.miller@email.com",
      "phone_number": "+1 555 567 8901",
      "office_address": { "street": "678 Bone St", "city": "Vancouver", "province": "BC", "postal_code": "V7P 3R9" },
      "availability": [{ "day": "Monday", "hours": "08:00-12:00" }, { "day": "Wednesday", "hours": "13:00-17:00" }],
      "consultation_fee": 200,
      "created_at": "2025-01-30T14:00:00Z",
      "updated_at": "2025-02-25T11:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Thomas",
      "last_name": "Young",
      "specialization": "Dermatologist",
      "email": "dr.thomas.young@email.com",
      "phone_number": "+1 555 678 9012",
      "office_address": { "street": "789 Skin Ave", "city": "Vancouver", "province": "BC", "postal_code": "V5T 4P1" },
      "availability": [{ "day": "Monday", "hours": "09:00-12:00" }, { "day": "Friday", "hours": "14:00-17:00" }],
      "consultation_fee": 140,
      "created_at": "2025-02-05T15:30:00Z",
      "updated_at": "2025-02-20T12:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Patricia",
      "last_name": "Harris",
      "specialization": "Psychiatrist",
      "email": "dr.patricia.harris@email.com",
      "phone_number": "+1 555 789 0123",
      "office_address": { "street": "123 Mind St", "city": "Vancouver", "province": "BC", "postal_code": "V6P 1N3" },
      "availability": [{ "day": "Wednesday", "hours": "09:00-12:00" }, { "day": "Friday", "hours": "13:00-17:00" }],
      "consultation_fee": 220,
      "created_at": "2025-02-10T16:00:00Z",
      "updated_at": "2025-02-22T09:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Victoria",
      "last_name": "Nelson",
      "specialization": "Gynecologist",
      "email": "dr.victoria.nelson@email.com",
      "phone_number": "+1 555 890 1234",
      "office_address": { "street": "45 Women's Rd", "city": "Vancouver", "province": "BC", "postal_code": "V8B 5C9" },
      "availability": [{ "day": "Tuesday", "hours": "10:00-14:00" }, { "day": "Thursday", "hours": "16:00-19:00" }],
      "consultation_fee": 160,
      "created_at": "2025-01-25T10:15:00Z",
      "updated_at": "2025-02-27T12:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Jason",
      "last_name": "Wright",
      "specialization": "Urologist",
      "email": "dr.jason.wright@email.com",
      "phone_number": "+1 555 901 2345",
      "office_address": { "street": "112 Urology Blvd", "city": "Vancouver", "province": "BC", "postal_code": "V9B 1L4" },
      "availability": [{ "day": "Monday", "hours": "10:00-13:00" }, { "day": "Thursday", "hours": "14:00-18:00" }],
      "consultation_fee": 180,
      "created_at": "2025-01-18T12:00:00Z",
      "updated_at": "2025-02-22T10:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Amanda",
      "last_name": "Garcia",
      "specialization": "Endocrinologist",
      "email": "dr.amanda.garcia@email.com",
      "phone_number": "+1 555 012 3456",
      "office_address": { "street": "678 Endo Rd", "city": "Vancouver", "province": "BC", "postal_code": "V6K 2H1" },
      "availability": [{ "day": "Tuesday", "hours": "09:00-12:00" }, { "day": "Friday", "hours": "14:00-17:00" }],
      "consultation_fee": 200,
      "created_at": "2025-02-01T14:00:00Z",
      "updated_at": "2025-02-25T13:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Henry",
      "last_name": "Martin",
      "specialization": "Oncologist",
      "email": "dr.henry.martin@email.com",
      "phone_number": "+1 555 123 9876",
      "office_address": { "street": "245 Cancer St", "city": "Vancouver", "province": "BC", "postal_code": "V6Z 3A1" },
      "availability": [{ "day": "Monday", "hours": "09:00-12:00" }, { "day": "Thursday", "hours": "13:00-16:00" }],
      "consultation_fee": 250,
      "created_at": "2025-02-03T12:00:00Z",
      "updated_at": "2025-02-26T10:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Clara",
      "last_name": "Jackson",
      "specialization": "Rheumatologist",
      "email": "dr.clara.jackson@email.com",
      "phone_number": "+1 555 234 8765",
      "office_address": { "street": "412 Rheumo Rd", "city": "Vancouver", "province": "BC", "postal_code": "V7P 1C8" },
      "availability": [{ "day": "Wednesday", "hours": "09:00-12:00" }, { "day": "Friday", "hours": "15:00-18:00" }],
      "consultation_fee": 220,
      "created_at": "2025-02-04T13:30:00Z",
      "updated_at": "2025-02-28T14:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Sophie",
      "last_name": "Lopez",
      "specialization": "Ophthalmologist",
      "email": "dr.sophie.lopez@email.com",
      "phone_number": "+1 555 345 9876",
      "office_address": { "street": "567 Vision St", "city": "Vancouver", "province": "BC", "postal_code": "V5X 2B3" },
      "availability": [{ "day": "Tuesday", "hours": "09:00-12:00" }, { "day": "Thursday", "hours": "13:00-16:00" }],
      "consultation_fee": 170,
      "created_at": "2025-02-08T14:30:00Z",
      "updated_at": "2025-02-27T15:30:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Lucas",
      "last_name": "Scott",
      "specialization": "Plastic Surgeon",
      "email": "dr.lucas.scott@email.com",
      "phone_number": "+1 555 456 1234",
      "office_address": { "street": "890 Beauty Blvd", "city": "Vancouver", "province": "BC", "postal_code": "V8T 3R9" },
      "availability": [{ "day": "Monday", "hours": "08:00-12:00" }, { "day": "Friday", "hours": "14:00-18:00" }],
      "consultation_fee": 280,
      "created_at": "2025-02-12T10:00:00Z",
      "updated_at": "2025-02-24T13:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Kate",
      "last_name": "Allen",
      "specialization": "Gastroenterologist",
      "email": "dr.kate.allen@email.com",
      "phone_number": "+1 555 567 4321",
      "office_address": { "street": "212 Stomach Rd", "city": "Vancouver", "province": "BC", "postal_code": "V5Y 1P2" },
      "availability": [{ "day": "Wednesday", "hours": "10:00-13:00" }, { "day": "Friday", "hours": "13:00-16:00" }],
      "consultation_fee": 200,
      "created_at": "2025-02-15T14:45:00Z",
      "updated_at": "2025-02-28T16:00:00Z",
      "image": "https://picsum.photos/80/80"
    },
    {
      "first_name": "Dr. Olivia",
      "last_name": "Morris",
      "specialization": "Hematologist",
      "email": "dr.olivia.morris@email.com",
      "phone_number": "+1 555 678 2345",
      "office_address": { "street": "324 Blood Blvd", "city": "Vancouver", "province": "BC", "postal_code": "V6W 1F5" },
      "availability": [{ "day": "Monday", "hours": "09:00-12:00" }, { "day": "Thursday", "hours": "14:00-17:00" }],
      "consultation_fee": 210,
      "created_at": "2025-02-18T11:15:00Z",
      "updated_at": "2025-02-26T15:30:00Z",
      "image": "https://picsum.photos/80/80"
    }
  ].obs;

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
    //fetchDoctor();
  }

  Future<void> fetchDoctor() async {

    final response = await http.get(
      Uri.parse('https://api.restful-api.dev/objects'),
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

}