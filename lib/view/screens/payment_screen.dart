import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double amount = 0.00;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
          child: Center(
              child: Text(
            Languages.of(context)!.labelPaymentScreen,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ))),
    ));
  }
}
