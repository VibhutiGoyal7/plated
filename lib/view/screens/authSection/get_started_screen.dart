import 'package:flutter/material.dart';
import 'package:payrio/theme/AppColor.dart';

import '../../../languageSection/Languages.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String token = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Payrio",
            style: TextStyle(fontSize: 28,
                fontWeight: FontWeight.bold,
            color: Colors.blueAccent),
          ),
          Image(
            alignment: Alignment.topLeft,
            image: AssetImage("assets/payment_image.png"),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Add your money and manage",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "The application for reaching your saving goal , send and receive money. Use QR codes and payment links to accept cards",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          _buildFooter(context)
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/MoneySafeScreen');
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.blueAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
