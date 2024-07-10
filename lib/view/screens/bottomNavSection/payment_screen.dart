import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../languageSection/Languages.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double amount = 0.00;
  String name = "";

  @override
  Widget build(BuildContext context) {
    DateTime? lastBackPressed;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (kDebugMode) {
          print("$didPop");
          final now = DateTime.now();
          const maxDuration = Duration(seconds: 2);
          final isWarning = lastBackPressed == null ||
              now.difference(lastBackPressed!) > maxDuration;

          if (isWarning) {
            lastBackPressed = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: maxDuration,
              ),
            );
            SystemNavigator.pop();
            //return Future.value(false);
          } else {
            SystemNavigator.pop();
          }
          // return Future.value(true);
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
            child: Center(
                child: Text(
              Languages.of(context)!.labelComingSoon,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ))),
      )),
    );
  }
}
