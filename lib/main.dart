import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mvvm_flutter_app/theme/AppTheme.dart';
import 'package:mvvm_flutter_app/utils/Helper.dart';
import 'package:mvvm_flutter_app/view/screens/account_detail_screen.dart';
import 'package:mvvm_flutter_app/view/screens/add_money_screen.dart';
import 'package:mvvm_flutter_app/view/screens/address_screen.dart';
import 'package:mvvm_flutter_app/view/screens/bottom_nav.dart';
import 'package:mvvm_flutter_app/view/screens/change_password_screen.dart';
import 'package:mvvm_flutter_app/view/screens/chooose_doc_screen.dart';
import 'package:mvvm_flutter_app/view/screens/forgot_password_screen.dart';
import 'package:mvvm_flutter_app/view/screens/otp_verify_screen.dart';
import 'package:mvvm_flutter_app/view/screens/personal_data_screen.dart';
import 'package:mvvm_flutter_app/view/screens/personal_info_screen.dart';
import 'package:mvvm_flutter_app/view/screens/phone_verify_screen.dart';
import 'package:mvvm_flutter_app/view/screens/profile_screen.dart';
import 'package:mvvm_flutter_app/view/screens/select_country_screen.dart';
import 'package:mvvm_flutter_app/view/screens/setting_screen.dart';
import 'package:mvvm_flutter_app/view/screens/setup_account_screen.dart';
import 'package:mvvm_flutter_app/view/screens/signin_screen.dart';
import 'package:mvvm_flutter_app/view/screens/splash_screen.dart';
import 'package:mvvm_flutter_app/view/screens/verify_email_screen.dart';
import 'package:mvvm_flutter_app/view/screens/verify_identity_screen.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

import 'Strings/AppLocalizationsDelegate.dart';
import 'Strings/L10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
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
        ChangeNotifierProvider.value(value: MediaViewModel()),
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
            '/': (context) => SplashScreen(),
            '/PhoneVerifyScreen': (context){
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return PhoneVerifyScreen();
            },
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
            '/SignInScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return SigninScreen();
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
            },
            '/ChangePasswordScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ChangePasswordScreen();
            },
            '/ForgotPasswordScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ForgotPasswordScreen();
            },
            '/PersonalDataScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return PersonalDataScreen();
            },
            '/AddressScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return AddressScreen();
            },
            '/SettingScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return SettingScreen(setLocale: setLocale,);
            },
            '/VerifyEmail': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return VerifyEmailScreen();
            },
            '/VerifyIdentityScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return VerifyIdentityScreen();
            },
            '/ChooseDocScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return ChooseDocScreen();
            },
            '/SelectCountryScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return SelectCountryScreen();
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
