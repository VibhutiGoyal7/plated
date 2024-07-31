import 'package:Payrio/model/documentData.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/model/response/initiateP2PResponse.dart';
import 'package:Payrio/theme/AppTheme.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/screens/add_money_screen.dart';
import 'package:Payrio/view/screens/authSection/get_started_screen.dart';
import 'package:Payrio/view/screens/authSection/money_safe_screen.dart';
import 'package:Payrio/view/screens/authSection/otp_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/phone_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/setup_account_screen.dart';
import 'package:Payrio/view/screens/authSection/signin_screen.dart';
import 'package:Payrio/view/screens/authSection/splash_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/bottom_nav.dart';
import 'package:Payrio/view/screens/bottomNavSection/payment_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/payment_successfull_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/scan_qr_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/tpin_create_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/tpin_verify_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transfer_contact_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transfer_otp_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transfer_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transfer_tpin_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/withdraw_screen.dart';
import 'package:Payrio/view/screens/coming_soon_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_access_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_screen.dart';
import 'package:Payrio/view/screens/kycSection/chooose_doc_screen.dart';
import 'package:Payrio/view/screens/kycSection/select_country_screen.dart';
import 'package:Payrio/view/screens/kycSection/verify_identity_screen.dart';
import 'package:Payrio/view/screens/kycSection/video_kyc_screen.dart';
import 'package:Payrio/view/screens/level_benefit_screen.dart';
import 'package:Payrio/view/screens/notification_detail_s%20reen.dart';
import 'package:Payrio/view/screens/notification_screen.dart';
import 'package:Payrio/view/screens/payment_method_screen.dart';
import 'package:Payrio/view/screens/payment_method_type_screen.dart';
import 'package:Payrio/view/screens/profileSection/account_detail_screen.dart';
import 'package:Payrio/view/screens/profileSection/address_screen.dart';
import 'package:Payrio/view/screens/profileSection/change_password_screen.dart';
import 'package:Payrio/view/screens/profileSection/change_tpin_screen.dart';
import 'package:Payrio/view/screens/profileSection/create_support_ticket_screen.dart';
import 'package:Payrio/view/screens/profileSection/forgot_password_screen.dart';
import 'package:Payrio/view/screens/profileSection/language_selection_screen.dart';
import 'package:Payrio/view/screens/profileSection/manage_applock_screen.dart';
import 'package:Payrio/view/screens/profileSection/new_forgot_pass_screen.dart';
import 'package:Payrio/view/screens/profileSection/otp_forgot_pass_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_data_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_info_screen.dart';
import 'package:Payrio/view/screens/profileSection/profile_screen.dart';
import 'package:Payrio/view/screens/profileSection/qr_scanner_screen.dart';
import 'package:Payrio/view/screens/profileSection/setting_screen.dart';
import 'package:Payrio/view/screens/profileSection/verify_email_otp_screen.dart';
import 'package:Payrio/view/screens/profileSection/verify_email_screen.dart';
import 'package:Payrio/view/screens/redeem_balance_screen.dart';
import 'package:Payrio/view/screens/redeem_screen.dart';
import 'package:Payrio/view/screens/request_qr_screen.dart';
import 'package:Payrio/view/screens/support_screen.dart';
import 'package:Payrio/view/screens/transactions_screen.dart';
import 'package:Payrio/view/screens/web_view_screen.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/L10n.dart';

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
            '/': (context) => SplashScreen(),
            '/GetStartedScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return GetStartedScreen();
            },
            '/MoneySafeScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return MoneySafeScreen();
            },
            '/PhoneVerifyScreen': (context) {
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
              return SigninScreen(data: args);
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
              return AddMoneyScreen(data: args);
            },
            '/WebViewScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return WebViewScreen(data: args);
            },
            '/PaymentMethodScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return PaymentMethodScreen();
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
            '/OtpForgotPassScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as CustomerVerifyOtpPass?;
              return OtpForgotPassScreen(data :args);
            },
            '/NewPassForgotPassScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as CustomerVerifyOtpPass?;
              return NewPassForgotPassScreen(data: args);
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
              return SettingScreen(
                setLocale: setLocale,
              );
            },
            '/VerifyEmail': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return VerifyEmailScreen();
            },
            '/VerifyEmailOtpScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return VerifyEmailOtpScreen();
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
            },
            '/LevelBenefitScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return LevelBenefitScreen();
            },
            '/NotificationScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return NotificationScreen();
            },
            '/NotificationDetailScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return NotificationDetailScreen();
            },
            '/RedeemBalScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return RedeemBalanceScreen();
            },
            '/RedeemBalance': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return RedeemScreen();
            },
            '/CameraAccessScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return CameraAccessScreen(data: args);
            },
            '/DocImageScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return DocImageScreen(data: args);
            },
            '/VideoKycScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as DocumentData?;
              return VideoKycScreen(data: args,);
            },
            '/PaymentScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return PaymentScreen();
            },
            '/ScanQrScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ScanQrScreen();
            },
            '/ManageAppLockScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ManageAppLockScreen();
            },
            '/TransactionsScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return TransactionsScreen();
            },
            '/QRScannerScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return QrScannerScreen();
            },
            '/ComingSoonScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ComingSoonScreen();
            },
            '/TransferScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as CheckCustomerResponse?;
              return TransferScreen(data: args,);
            },
            '/WithdrawScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return WithdrawScreen();
            },
            '/TpinCreateScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return TpinCreateScreen();
            },
            '/TpinVerifyScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return TpinVerifyScreen(data: args);
            },
            '/ChangeTPinScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return ChangeTpinScreen();
            },
            '/TransferTPINScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as CompleteP2PRequest?;
              return TransferTpinScreen(data: args );
            },
            '/TransferOtpScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as CompleteP2PRequest;
              return TransferOtpScreen(data: args,);
            },
            '/TransferContactScreen': (context) {
              return TransferContactScreen();
            },
            '/PaymentSuccessfulScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as CompleteP2PRequest?;
              return PaymentSuccessfulScreen(data : args);
            },
            '/LanguageSelectionScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as CompleteP2PRequest?;
              return LanguageSelectionScreen(
                setLocale: setLocale,
              );
            },
            '/SupportScreen': (context) {
              return SupportScreen();
            },
            '/CreateSupportTicketScreen': (context) {
              return CreateSupportTicketScreen();
            },
            '/PaymentMethodTypeScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return PaymentMethodTypeScreen(data: args);
            },
            '/RequestQrScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return RequestQrScreen();
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
