import 'package:BDPass/model/request/verifyOtpChangePass.dart';
import 'package:BDPass/model/webviewData.dart';
import 'package:BDPass/theme/AppTheme.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/toastMessage.dart';
import 'package:BDPass/view/screens/authSection/account_recovery_screen.dart';
import 'package:BDPass/view/screens/authSection/confirm_detail_screen.dart';
import 'package:BDPass/view/screens/authSection/create_account_screen.dart';
import 'package:BDPass/view/screens/authSection/enter_pin_screen.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/instruction_screen.dart';
import 'package:BDPass/view/screens/authSection/login_alert_screen.dart';
import 'package:BDPass/view/screens/authSection/otp_verification_screen.dart';
import 'package:BDPass/view/screens/authSection/phone_verification_screen.dart';
import 'package:BDPass/view/screens/authSection/proceed_as_screen.dart';
import 'package:BDPass/view/screens/authSection/signin_screen.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/slider_screen.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/splash_screen.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/terms_conditions_screen.dart';
import 'package:BDPass/view/screens/authSection/verification_screen.dart';
import 'package:BDPass/view/screens/authSection/visitor_name_screen.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/welcome_screen.dart';
import 'package:BDPass/view/screens/bottomNavSection/account_benefit_screen.dart';
import 'package:BDPass/view/screens/bottomNavSection/bottom_nav.dart';
import 'package:BDPass/view/screens/bottomNavSection/manage_devices_screen.dart';
import 'package:BDPass/view/screens/bottomNavSection/pinSection/pin_create_screen.dart';
import 'package:BDPass/view/screens/change_password_screen.dart';
import 'package:BDPass/view/screens/coming_soon_screen.dart';
import 'package:BDPass/view/screens/ml_kit/face_detector_view.dart';
import 'package:BDPass/view/screens/profileSection/changePinSection/change_pin_screen.dart';
import 'package:BDPass/view/screens/profileSection/changePinSection/new_pin_screen.dart';
import 'package:BDPass/view/screens/profileSection/changePinSection/verify_email_screen.dart';
import 'package:BDPass/view/screens/profileSection/changePinSection/verify_phone_screen.dart';
import 'package:BDPass/view/screens/scan_camera_text.dart';
import 'package:BDPass/view/screens/web_view_screen.dart';
import 'package:BDPass/view_model/main_view_model.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/L10n.dart';
import 'model/response/notificationOtpResponse.dart';

//GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  //await Firebase.initializeApp();
  await availableCameras();
  // Handle background messages
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup interaction with notifications
  //await PushNotificationService().setupInteractedMessage();

  // Request notification permissions
/*
  final permissionStatus = await Permission.notification.status;
  if (permissionStatus.isDenied) {
    await Permission.notification.request();
  }
*/

/*
  // Get initial message
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("FirebaseMessaging:: $initialMessage");
  }
*/

  // Set preferred orientations and run app
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp(initialMessage: null));
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;

  MyApp({this.initialMessage});

  @override
  _MyAppState createState() => _MyAppState(initialMessage);
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale _locale = const Locale('en');
  final RemoteMessage? initialMessage;

  _MyAppState(this.initialMessage);

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

  void setupNotificationHandlers(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ToastComponent.showToast(context: context, message: "$message");
      // Navigate to the ProfileScreen when the notification is clicked
      final notificationResponse =
          NotificationOtpResponse.fromJson(message.data);
      /* Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => NotificationOtpScreen(
              data: notificationResponse,
            )),
      );*/
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
          //  navigatorKey: navigatorKey,
          title: 'BD-Pass',
          locale: _locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            // support localization string for Material Widget
            GlobalCupertinoLocalizations.delegate,
            // support localization string for Cupertino Widget
            GlobalWidgetsLocalizations.delegate,
            // support localization string for text format from right to left.
            AppLocalizationsDelegate()
          ],
          supportedLocales: L10n.all,
          theme: AppTheme.getAppTheme(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) {
              NotificationOtpResponse? notificationResponse =
                  NotificationOtpResponse(otp: "", notificationType: "");
              if (initialMessage?.data != null) {
                notificationResponse =
                    NotificationOtpResponse.fromJson(initialMessage!.data);
              }
              return SplashScreen(data: notificationResponse);
            },
            '/SliderScreen': (context) {
              return SliderScreen();
            },
            '/WelcomeScreen': (context) {
              return WelcomeScreen();
            },
            '/InstructionScreen': (context) {
              return InstructionScreen();
            },
            '/CreateAccountScreen': (context) {
              return CreateAccountScreen();
            },
            '/TermsConditionsScreen': (context) {
              return TermsConditionsScreen();
            },
            '/ProceedAsScreen': (context) {
              return ProceedAsScreen();
            },
            '/VerificationScreen': (context) {
              return VerificationScreen();
            },
            '/PhoneVerificationScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return PhoneVerificationScreen(data: args,);
            },
            '/PinCreateScreen': (context) {
              return PinCreateScreen();
            },
            '/ChangePinScreen': (context) {
              return ChangePinScreen();
            },
            '/EnterPinScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as Function();
              return EnterPinScreen(onSuccess: args,);
            },
            '/NewPinScreen': (context) {
              return NewPinScreen();
            },
            '/LoginAlertScreen': (context) {
              return LoginAlertScreen();
            },
            '/VerifyPhoneScreen': (context) {
              return VerifyPhoneScreen();
            },
            '/VerifyEmailScreen': (context) {
              return VerifyEmailScreen();
            },
            '/BottomNav': (context) {
              return BottomNav();
            },
            '/OtpVerificationScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as String?;
              return OtpVerificationScreen(data: args,);
            },
            '/AccountRecoveryScreen': (context) {
              return AccountRecoveryScreen();
            },
            '/AccountBenefitScreen': (context) {
              return AccountBenefitScreen();
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
            '/VisitorNameScreen': (context) {
              return VisitorNameScreen();
            },
            '/WebViewScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as WebViewData?;
              return WebViewScreen(data: args);
            },
            '/ChangePasswordScreen': (context) {
              return ChangePasswordScreen();
            },
            '/ComingSoonScreen': (context) {
              return ComingSoonScreen();
            },
            '/ScanCameraTextScreen': (context) {
              return ScanCameraTextScreen();
            },
            '/FaceDetectorView': (context) {
              return FaceDetectorView();
            },
            '/ManageDevicesScreen': (context) {
              return ManageDevicesScreen();
            },
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
