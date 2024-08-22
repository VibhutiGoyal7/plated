import 'dart:async';

import 'package:FlutterBasicStructure/languageSection/Languages.dart';
import 'package:FlutterBasicStructure/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:FlutterBasicStructure/utils/Helper.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../model/response/notificationOtpResponse.dart';
import '../CustomBiometricScreen.dart';

class SplashScreen extends StatefulWidget {

  final NotificationOtpResponse? data; // Define the 'data' parameter here

  SplashScreen({Key? key, this.data}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token = "";
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  bool _isAuthenticated = false;
  bool _authenticationAttempted = false; // Add this flag
  String _authorized = 'Not Authorized';
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _authOnResume = false;
  bool? isUserAuthenticated = false;
  NotificationOtpResponse? notificationOtpResponse;
  @override
  void initState() {
    super.initState();
    _fetchToken();
    notificationOtpResponse = widget.data;
    Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });
    Timer(Duration(seconds: 2), () {
      _navigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child:
            Image(
              //height: screenHeight * 0.35,
              image: AssetImage(
                  isDarkMode ? "assets/app_logo_dark.png" :"assets/app_logo.png"),
              fit: BoxFit.cover ,
            )/* Text(
              "${Languages.of(context)!.appName}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),*/
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

  Future<void> _initializeBiometrics() async {
    bool? retrievedBiometric = await Helper.getBiometric();
    bool? canCheckBiometric = retrievedBiometric;
    print('Can CheckBiometric: $canCheckBiometric');
    if (isUserAuthenticated != true) {
      if (canCheckBiometric != null && canCheckBiometric == true) {
        List<BiometricType> availableBiometric = [];
        try {
          canCheckBiometric = await auth.canCheckBiometrics;
          if (canCheckBiometric) {
            availableBiometric = await auth.getAvailableBiometrics();
          }
        } on PlatformException catch (e) {
          print(e);
        }

        if (!mounted) return;

        setState(() {
          _canCheckBiometric =
              canCheckBiometric! && availableBiometric.isNotEmpty;
        });
        print("_authenticationAttempted $_authenticationAttempted");

        if (_canCheckBiometric && !_authenticationAttempted) {
          print("Checking Number of times");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomBiometricScreen(data: notificationOtpResponse,)),
          );
          //_authenticate(); // Only call authenticate if not attempted before
        }
      }else{
        if(notificationOtpResponse?.otp?.isNotEmpty == true){
          //Navigator.pushReplacementNamed(context, "/NotificationOtpScreen", arguments: notificationOtpResponse);
          return;
        }else
        {
          Navigator.pushReplacementNamed(context, "/BottomNav");
        }
      }
    }
  }
  void _navigation() {
    print("token:::${widget.data}");
    //ToastComponent.showToast(context: context, message: "token:::${notificationOtpResponse?.otp}");
    if (token == null || token?.isEmpty == true) {
      Navigator.pushReplacementNamed(context, "/MoneySafeScreen");
    } else {

      if (isUserAuthenticated != true) {
        _initializeBiometrics();
      }else{
        if(notificationOtpResponse?.otp?.isNotEmpty == true){
          //Navigator.pushReplacementNamed(context, "/NotificationOtpScreen", arguments: notificationOtpResponse);
          return;
        }else
          {
            Navigator.pushReplacementNamed(context, "/BottomNav");
          }
      }
    }
  }

}
