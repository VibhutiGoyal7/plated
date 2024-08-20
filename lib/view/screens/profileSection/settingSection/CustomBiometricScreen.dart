import 'dart:io'; // Import this for exit(0)
import 'dart:ui';

import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../utils/Helper.dart';

class CustomBiometricScreen extends StatefulWidget {
  @override
  _CustomBiometricScreenState createState() => _CustomBiometricScreenState();
}

class _CustomBiometricScreenState extends State<CustomBiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _authOnResume = false;
  bool _authenticationAttempted = false;
  String _authorized = 'Not Authorized';

  Future<void> _authenticate() async {
    print("Called _authenticate()");
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );
      print("authenticated $authenticated");
    } on PlatformException catch (e) {
      print('Error authenticating: $e');
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticated = authenticated;
      _authOnResume = authenticated;
      print("_authOnResume $_authOnResume");
      _authorized = authenticated ? 'Authorized' : 'Failed to authenticate';
      _authenticationAttempted = true;
    });

    if (authenticated) {
      await Helper.saveUserAuthenticated(true);
      print("User authenticated successfully.");
      Navigator.pushReplacementNamed(context, "/BottomNav");
    } else {
      await Helper.saveUserAuthenticated(false);
      print("User cancelled authentication.");
      //SystemNavigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _authenticate(); // Trigger biometric after a short delay
      });
    });
  }

  Future<bool> _onWillPop() async {
    exit(0); // Forcefully close the app
    return false; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            // Background image or color
            Container(
              decoration: BoxDecoration(
                  color: isDarkMode ? AppColor.BG_COLOR : AppColor.DARK_BG_COLOR
              ),
            ),

            // Blurred effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color:
                    Colors.black.withOpacity(0.5), // Dark overlay with opacity
              ),
            ),

            // Authentication prompt
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Authenticate with Fingerprint',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (!_isAuthenticated)
                    ElevatedButton(
                      onPressed: _authenticate,
                      child: Text('Try Again'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
