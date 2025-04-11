import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class AppointmentController extends GetxController {
  var appointmentList = <Map<String,dynamic>>[].obs;
  var singleAppointment = Rxn<Map<String, dynamic>>();
  var appointmentByPatientList = <Map<String,dynamic>>[].obs;
  var patientId = "67f368ba18e7ac37286aa89e".obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAppointment();
  }

  Future<void> fetchAppointment() async {

    final response = await http.get(
      Uri.parse('http://192.168.1.157:8080/api/appointments'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseArray = jsonDecode(response.body);

      appointmentList.value = responseArray.map((item)=>item as Map<String, dynamic>).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> fetchAppointmentById(String id) async {

    final response = await http.get(
      Uri.parse('http://192.168.1.157:8080/api/appointments/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      singleAppointment.value = Map<String, dynamic>.from(data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> fetchAppointmentByPatientId(String id) async {

    final response = await http.get(
      Uri.parse('http://192.168.1.157:8080/api/appointments/patient/$id'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseArray = jsonDecode(response.body);

      appointmentByPatientList.value = responseArray.map((item)=>item as Map<String, dynamic>).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load appointments');
    }
  }

  Future<bool> deleteAppointment(String id) async {

    developer.log("device clicked id: $id");

    final http.Response response = await http.delete(
      Uri.parse('http://192.168.1.157:8080/api/appointments/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {

      return true;

    } else {
      developer.log('${response.statusCode}');
      return false;

    }
  }






}