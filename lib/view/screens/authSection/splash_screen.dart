import 'dart:async';

import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:Payrio/utils/Helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token = "";

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
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchToken() async {
    await Helper.saveUserAuthenticated(false);
    await Future.delayed(Duration(milliseconds: 2));
    token = await Helper.getUserToken();
    print(token);

  }

  void _navigation() {
    print("token:::${token} ${token?.isEmpty}");
    if (token == null || token?.isEmpty == true) {
      Navigator.pushReplacementNamed(context, "/MoneySafeScreen");
    } else {
      Navigator.pushReplacementNamed(context, "/BottomNav");
    }
  }
}
