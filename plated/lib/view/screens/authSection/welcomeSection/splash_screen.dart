import 'dart:async';

import 'package:Plated/utils/Helper.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../model/response/notificationOtpResponse.dart';

class SplashScreen extends StatefulWidget {
  final NotificationOtpResponse? data; // Define the 'data' parameter here

  SplashScreen({Key? key, this.data}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token = "";
  final LocalAuthentication auth = LocalAuthentication();
  NotificationOtpResponse? notificationOtpResponse;

  @override
  void initState() {
    super.initState();
    _fetchToken();
    notificationOtpResponse = widget.data;
    Timer(Duration(seconds: 2), () {
      _navigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Center(
          child: Image(
            height: screenHeight * 0.1,
            image: AssetImage(isDarkMode
                ? "assets/app_logo_dark.png"
                : "assets/app_logo.png"),
            fit: BoxFit.cover,
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
    print("token:::${widget.data}");

      Navigator.pushReplacementNamed(context, "/BottomNav");
  }
}
