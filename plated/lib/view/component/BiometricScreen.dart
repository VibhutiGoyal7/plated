import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricScreen extends StatefulWidget {
  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticated = false;
  String _authStatus = "Not Authenticated";

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool isAuthenticated;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      isAuthenticated = false;
    }
    setState(() {
      _isAuthenticated = isAuthenticated;
      _authStatus = isAuthenticated ? "Authenticated" : "Failed to authenticate";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Biometric Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_canCheckBiometrics)
              Text(
                'Biometrics are available',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate'),
            ),
            SizedBox(height: 20),
            Text(
              _authStatus,
              style: TextStyle(fontSize: 18, color: _isAuthenticated ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
