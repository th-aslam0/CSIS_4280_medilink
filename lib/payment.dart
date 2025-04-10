import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:group02_medilink/bookingSuccessful.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = 'pk_test_51R9IrOIVC9q8XALuhPPx3FE1W1bseeXf0nbgHev5Nnb0zcIbaFPYZG3ijifvtamHgQaLLf9tuLZ28NifIKTzdilJ00dEx4QSd7';
    Stripe.instance.applySettings();
  }

  final List<Map<String, dynamic>> patient = [
    {
      "first_name": "John",
      "last_name": "Doe",
      "phone_number": "+1 123 456 7890",
      "email": "john.doe@email.com",
    }
  ];

  Future<Map<String, dynamic>?> createPaymentIntent() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51R9IrOIVC9q8XALuYODRwOef36Phkf6WajcY8fFdzpFpFY8TQpmwzXb9s2WZ6FYGjt1YEzc5XlPy0I4VFpxtWwP400gAxcQkhU',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': '1000',
          'currency': 'cad',
          'payment_method_types[]': 'card',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      print("error: $e");
      return null;
    }
  }

  Future<void> makePayment() async {
    try {

      final paymentIntentData = await createPaymentIntent();
      if (paymentIntentData == null) {
        print("Failed to create payment intent");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'CSIS',
        ),
      );


      await Stripe.instance.presentPaymentSheet();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingSuccessful()),
      );
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment"), backgroundColor: Colors.blue),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Contact Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
          SizedBox(height: 8),
          Text('Name'),
          Text('Tol'),
          Text('Email'),
          SizedBox(height: 24),
          Text('Appointment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
          SizedBox(height: 8),
          Text('General Practitioner:         10.00'),
          SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await makePayment();
              },
              child: Text("Checkout"),
            ),
          )

        ],
        ),
      )
    );
  }
}
