import 'package:Payrio/view/screens/payment_method_screen.dart';
import 'package:Payrio/view/screens/payment_method_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Payrio/theme/AppTheme.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/screens/add_money_screen.dart';
import 'package:Payrio/view/screens/authSection/otp_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/phone_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/setup_account_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/bottom_nav.dart';
import 'package:Payrio/view/screens/bottomNavSection/payment_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/scan_qr_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_access_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_screen.dart';
import 'package:Payrio/view/screens/kycSection/chooose_doc_screen.dart';
import 'package:Payrio/view/screens/kycSection/select_country_screen.dart';
import 'package:Payrio/view/screens/kycSection/verify_identity_screen.dart';
import 'package:Payrio/view/screens/kycSection/video_kyc_screen.dart';
import 'package:Payrio/view/screens/profileSection/account_detail_screen.dart';
import 'package:Payrio/view/screens/profileSection/address_screen.dart';
import 'package:Payrio/view/screens/profileSection/change_password_screen.dart';
import 'package:Payrio/view/screens/profileSection/forgot_password_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_data_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_info_screen.dart';
import 'package:Payrio/view/screens/profileSection/profile_screen.dart';
import 'package:Payrio/view/screens/profileSection/setting_screen.dart';
import 'package:Payrio/view/screens/profileSection/verify_email_screen.dart';
import 'package:Payrio/view_model/main_view_model.dart';

import 'package:Payrio/view/screens/authSection/get_started_screen.dart';
import 'package:Payrio/view/screens/level_benefit_screen.dart';
import 'package:Payrio/view/screens/authSection/money_safe_screen.dart';
import 'package:Payrio/view/screens/notification_detail_s%20reen.dart';
import 'package:Payrio/view/screens/notification_screen.dart';
import 'package:Payrio/view/screens/redeem_balance_screen.dart';
import 'package:Payrio/view/screens/redeem_screen.dart';
import 'package:Payrio/view/screens/authSection/signin_screen.dart';
import 'package:Payrio/view/screens/authSection/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/L10n.dart';
import 'model/services/PushNotificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  //await Firebase.initializeApp();

  //await PushNotificationService().setupInteractedMessage();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });

/*  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("FirebaseMessaging:: ${initialMessage}");
    // App received a notification when it was killed
  }
  await Permission.notification.isDenied.then(
        (bool value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );*/


}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MainViewModel()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Media Player',
          locale: _locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            // support localization string for Material Widget
            GlobalCupertinoLocalizations.delegate,
            // support localization string for Cupertino Widget
            GlobalWidgetsLocalizations.delegate,
            // support localization string for text format from right to left.
            // Add your generated localization delegate here
            AppLocalizationsDelegate()
          ],
          supportedLocales: L10n.all,
          theme: AppTheme.getAppTheme(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen()
            , '/GetStartedScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return GetStartedScreen();
            },
            '/MoneySafeScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return MoneySafeScreen();
            },
            '/PhoneVerifyScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return PhoneVerifyScreen();
            },
            '/OtpVerify': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return OTPVerifyScreen(data: args);
            },
            '/SetUpAccount': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return SetUpAccountScreen(userId: args);
            },
            '/SignInScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return SigninScreen(data: args);
            },
            '/BottomNav': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return BottomNav();
            },
            '/ProfileScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return ProfileScreen();
            },
            '/PersonalInfoScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return PersonalInformationScreen();
            },
            '/AccountDetailScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return AccountDetailScreen();
            },
            '/AddMoneyScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return AddMoneyScreen();
            },
            '/PaymentMethodScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return PaymentMethodScreen();
            },
            '/ChangePasswordScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return ChangePasswordScreen();
            },
            '/ForgotPasswordScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return ForgotPasswordScreen();
            },
            '/PersonalDataScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return PersonalDataScreen();
            },
            '/AddressScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return AddressScreen();
            },
            '/SettingScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return SettingScreen(
                setLocale: setLocale,
              );
            },
            '/VerifyEmail': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return VerifyEmailScreen();
            },
            '/VerifyIdentityScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return VerifyIdentityScreen();
            },
            '/ChooseDocScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return ChooseDocScreen();
            },
            '/SelectCountryScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return SelectCountryScreen();
            },
            '/LevelBenefitScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return LevelBenefitScreen();
            },
            '/NotificationScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return NotificationScreen();
            },
            '/NotificationDetailScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return NotificationDetailScreen();
            },
            '/RedeemBalScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return RedeemBalanceScreen();
            },
            '/RedeemBalance': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return RedeemScreen();
            },
            '/CameraAccessScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return CameraAccessScreen(data: args);
            },
            '/DocImageScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return DocImageScreen(data: args);
            }
            ,
            '/VideoKycScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return VideoKycScreen();
            },
            '/PaymentScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return PaymentScreen();
            },
            '/ScanQrScreen': (context) {
              final args =
              ModalRoute
                  .of(context)!
                  .settings
                  .arguments as String?;
              return ScanQrScreen();
            }
          }),
    );
  }


  void _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    var selectedLanguage = await Helper.getLocale();
    print(selectedLanguage.languageCode);

    // Ensure that setState is called synchronously after the async work is done
    if (mounted) {
      setState(() {
        _locale = Locale(selectedLanguage.languageCode);
      });
    }
  }
}

