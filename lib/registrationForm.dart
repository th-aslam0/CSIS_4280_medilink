import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group02_medilink/bookingSuccessful.dart';
import 'package:group02_medilink/registerSuccessful.dart';

import 'controller/userController.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('First Name'),
                _buildTextField('Last Name'),
                _buildTextField('Email',
                    keyboardType: TextInputType.emailAddress),
                _buildTextField('Home Address'),
                _buildTextField('Date of Birth',
                    keyboardType: TextInputType.datetime),
                _buildTextField('Phone Number',
                    keyboardType: TextInputType.phone),
                _buildDropdownField('Marital Status',
                    ['Single', 'Married', 'Divorced', 'Widowed']),
                _buildDropdownField('Gender', ['Male', 'Female', 'Other']),
                _buildTextField('Password', obscureText: true),
                _buildTextField('Confirm Password', obscureText: true),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value!;
                        });
                      },
                    ),
                    Text('I agree to the terms and conditions')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Login Instead?'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        userController.register();
                        if (_formKey.currentState!.validate() &&
                            _agreeToTerms) {
                          // Handle form submission
                          userController.register();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => RegisterSuccessful(),
                          //     ));
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        onChanged: (value) {
          switch (label) {
            case 'First Name':
              userController.firstName = value;
              break;
            case 'Last Name':
              userController.lastName = value;
              break;
            case 'Email':
              userController.email = value;
              break;
            case 'Home Address':
              userController.homeAddress = value;
              break;
            case 'Date of Birth':
              userController.dateOfBirth = value;
              break;
            case 'Phone Number':
              userController.phoneNumber = value;
              break;
            case 'Password':
              userController.password = value;
              break;
            case 'Confirm Password':
              userController.confirmPassword = value;
              break;
          }
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    String? selectedValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue;
          });

          if (label == 'Marital Status') {
            userController.maritalStatus = newValue!;
          } else if (label == 'Gender') {
            userController.gender = newValue!;
          }
        },
        validator: (value) =>
            value == null ? 'Please select your $label' : null,
      ),
    );
  }
}
