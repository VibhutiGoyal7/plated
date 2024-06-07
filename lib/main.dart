import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_flutter_app/view/screens/account_detail_screen.dart';
import 'package:mvvm_flutter_app/view/screens/add_money_screen.dart';
import 'package:mvvm_flutter_app/view/screens/bottom_nav.dart';
import 'package:mvvm_flutter_app/view/screens/dashboard_home_screen.dart';
import 'package:mvvm_flutter_app/view/screens/otp_verify_screen.dart';
import 'package:mvvm_flutter_app/view/screens/personal_info_screen.dart';
import 'package:mvvm_flutter_app/view/screens/phone_verify_screen.dart';
import 'package:mvvm_flutter_app/view/screens/profile_screen.dart';
import 'package:mvvm_flutter_app/view/screens/setup_account_screen.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MediaViewModel()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Media Player',
          theme: ThemeData(
            appBarTheme: AppBarTheme(),
            primarySwatch: Colors.purple,
            hintColor: Colors.deepOrange,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => PhoneVerifyScreen(),
            '/OtpVerify': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return OTPVerifyScreen(data: args);
            },
            '/SetUpAccount': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return SetUpAccountScreen(userId: args);
            },
            '/BottomNav': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return BottomNav();
            },
            '/ProfileScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return ProfileScreen();
            },
            '/PersonalInfoScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return PersonalInformationScreen();
            },
            '/AccountDetailScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return AccountDetailScreen();
            },
            '/AddMoneyScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return AddMoneyScreen();
            }
          }),
    );
  }
}
