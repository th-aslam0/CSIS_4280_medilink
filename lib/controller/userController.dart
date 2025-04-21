import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController{

  final String baseUrl = 'https://ccd8-2604-3d08-9b7e-6c00-d1df-4e63-6c97-a8d8.ngrok-free.app/api/auth/register';



  // These will be filled from the registration form later
  String firstName = '';
  String lastName = '';
  String email = '';
  String homeAddress = '';
  String dateOfBirth = '';
  String phoneNumber = '';
  String maritalStatus = '';
  String gender = '';
  String password = '';
  String confirmPassword = '';
  var isLoggedIn = false;

  Future<void> login() async {
    // need to add oauth2 login flow code
    print("login Called ");
    bool _authenticated = false;
    String _error = "";
    String _teams = "";

    final FlutterAppAuth _appAuth = const FlutterAppAuth();

    final String _clientId = "football-ui";
    final String _clientSecret = "SuperSuperSecret";
    final String _redirectUrl = "com.wongi5.demo:/oauthredirect";
    final String _issuer = "http://localhost:9000";
    final List<String> _scopes = <String>[
      'openid',
      'profile',
      'football:read',
      'football:admin'
    ];

    String? _accessToken;
    String? _refreshToken;
    String? _idToken;

    bool _isBusy = false;

    final AuthorizationServiceConfiguration _serviceConfiguration =
    const AuthorizationServiceConfiguration(
        authorizationEndpoint: "http://192.168.56.1:9000/oauth2/authorize",
        tokenEndpoint: "http://192.168.56.1:9000/oauth2/token",
        endSessionEndpoint: "http://192.168.56.1:9000/connect/logout");

    Future<void> _signInWithAutoCodeExchange(
        {ExternalUserAgent externalUserAgent =
            ExternalUserAgent.asWebAuthenticationSession}) async {
      try {


        final AuthorizationTokenResponse result =
        await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
            _clientId, _redirectUrl,
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            externalUserAgent: externalUserAgent,
            allowInsecureConnections: true,
            issuer: _issuer));

        print(result);
      } catch (e) {
        print(e);
      }
    }

    _signInWithAutoCodeExchange();
  }



  Future<void> register() async {
    print("register Called ");

    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "homeAddress": homeAddress,
      "dateOfBirth": dateOfBirth,
      "phoneNumber": phoneNumber,
      "maritalStatus": maritalStatus,
      "gender": gender,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("✅ Registration Successful");
      } else {
        print("❌ Registration Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

}

