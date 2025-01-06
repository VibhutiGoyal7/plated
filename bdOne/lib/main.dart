import 'package:BDOne/model/webviewData.dart';
import 'package:BDOne/theme/AppTheme.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:BDOne/view/screens/authSection/confirm_detail_screen.dart';
import 'package:BDOne/view/screens/authSection/create_account_screen.dart';
import 'package:BDOne/view/screens/authSection/otp_verification_screen.dart';
import 'package:BDOne/view/screens/authSection/phone_verification_screen.dart';
import 'package:BDOne/view/screens/authSection/signin_screen.dart';
import 'package:BDOne/view/screens/authSection/welcomeSection/instruction_screen.dart';
import 'package:BDOne/view/screens/authSection/welcomeSection/slider_screen.dart';
import 'package:BDOne/view/screens/authSection/welcomeSection/splash_screen.dart';
import 'package:BDOne/view/screens/authSection/welcomeSection/terms_conditions_screen.dart';
import 'package:BDOne/view/screens/authSection/welcomeSection/welcome_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/about_bdpass_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/change_email_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/change_phone_no_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/faq_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/personal_details_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/privacy_policy_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/accountSection/support_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/bottom_nav.dart';
import 'package:BDOne/view/screens/bottomNavSection/manage_devices_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/select_service_screen.dart';
import 'package:BDOne/view/screens/change_password_screen.dart';
import 'package:BDOne/view/screens/coming_soon_screen.dart';
import 'package:BDOne/view/screens/ml_kit/face_detector_view.dart';
import 'package:BDOne/view/screens/scan_camera_text.dart';
import 'package:BDOne/view/screens/transportationBottomNavSection/transportation_bottom_nav.dart';
import 'package:BDOne/view/screens/travelBottomNavSection/travel_bottom_nav.dart';
import 'package:BDOne/view/screens/web_view_screen.dart';
import 'package:BDOne/view_model/main_view_model.dart';
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
          title: 'BD-ONE',
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
          /*
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: ThemeMode.system,*/
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
            '/SelectServiceScreen': (context) {
              return SelectServiceScreen();
            },
            '/CreateAccountScreen': (context) {
              return CreateAccountScreen();
            },
            '/TermsConditionsScreen': (context) {
              return TermsConditionsScreen();
            },
            '/PhoneVerificationScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return PhoneVerificationScreen(
                data: args,
              );
            },
            '/BottomNav': (context) {
              return BottomNav();
            },
            '/TravelBottomNav': (context) {
              return TravelBottomNav();
            },
            '/TransportationBottomNav': (context) {
              return TransportationBottomNav();
            },
            '/AboutBDOneScreen': (context) {
              return AboutBDOneScreen();
            },
            '/SupportScreen': (context) {
              return SupportScreen();
            },
            '/FaqScreen': (context) {
              return FaqScreen();
            },
            '/PrivacyPolicyScreen': (context) {
              return PrivacyPolicyScreen();
            },
            '/PersonalDetailsScreen': (context) {
              return PersonalDetailsScreen();
            },
            '/ChangeEmailScreen': (context) {
              return ChangeEmailScreen();
            },
            '/ChangePhoneNoScreen': (context) {
              return ChangePhoneNoScreen();
            },
            '/OtpVerificationScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return OtpVerificationScreen(
                data: args,
              );
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
