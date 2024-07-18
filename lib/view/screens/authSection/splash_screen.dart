import 'dart:async';

import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:Payrio/utils/Helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = "";

  @override
  void initState() {
    super.initState();
    _fetchToken();
    Timer(Duration(seconds: 2), () {
      _navigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Text(
              "${Languages.of(context)!.appName}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchToken() async {
    await Future.delayed(Duration(milliseconds: 2));
    token = await Helper.getUserToken() as String;
  }

  void _navigation() {
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/GetStartedScreen");
    } else {
      Navigator.pushReplacementNamed(context, "/BottomNav");
    }
  }
}
