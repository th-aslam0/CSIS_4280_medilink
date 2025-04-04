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
    Stripe.publishableKey = 'pk_test_51R9IrOIVC9q8XALuhPPx3FE1W1bseeXf0nbgHev5Nnb0zcIbaFPYZG3ijifvtamHgQaLLf9tuLZ28NifIKTzdilJ00dEx4QSd7'; // Replace with your Stripe publishable key
    Stripe.instance.applySettings();
  }

  Future<Map<String, dynamic>?> createPaymentIntent() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51R9IrOIVC9q8XALuYODRwOef36Phkf6WajcY8fFdzpFpFY8TQpmwzXb9s2WZ6FYGjt1YEzc5XlPy0I4VFpxtWwP400gAxcQkhU', // Replace with your actual Stripe Secret Key
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'amount': '1000',
          'currency': 'cad',
          'payment_method_types[]': 'card',
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      print("Error creating PaymentIntent: $e");
      return null;
    }
  }

  Future<void> makePayment() async {
    try {

      final paymentIntentData = await createPaymentIntent();
      if (paymentIntentData == null) {
        print("Failed to create PaymentIntent");
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
      print("Payment Successful!");
    } catch (e) {
      print("Payment Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment"), backgroundColor: Colors.blue),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Button Clicked: Attempting Payment...");
            await makePayment();
          },
          child: Text("Pay with Stripe"),
        ),
      ),
    );
  }
}
