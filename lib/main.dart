import 'package:Payrio/model/documentData.dart';
import 'package:Payrio/model/request/completeP2PRequest.dart';
import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/request/verifyOtpChangePass.dart';
import 'package:Payrio/model/response/allSupportTicketResponse.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/model/response/p2PTransactionListReponse.dart';
import 'package:Payrio/model/response/transactionListReponse.dart';
import 'package:Payrio/model/webviewData.dart';
import 'package:Payrio/theme/AppTheme.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:Payrio/view/screens/addMoneySection/add_money_screen.dart';
import 'package:Payrio/view/screens/addMoneySection/payment_method_screen.dart';
import 'package:Payrio/view/screens/addMoneySection/payment_method_type_screen.dart';
import 'package:Payrio/view/screens/addMoneySection/web_view_screen.dart';
import 'package:Payrio/view/screens/authSection/forgot_password_screen.dart';
import 'package:Payrio/view/screens/authSection/get_started_screen.dart';
import 'package:Payrio/view/screens/authSection/money_safe_screen.dart';
import 'package:Payrio/view/screens/authSection/new_forgot_pass_screen.dart';
import 'package:Payrio/view/screens/authSection/notification_otp_screen.dart';
import 'package:Payrio/view/screens/authSection/otp_forgot_pass_screen.dart';
import 'package:Payrio/view/screens/authSection/otp_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/phone_verify_screen.dart';
import 'package:Payrio/view/screens/authSection/setup_account_screen.dart';
import 'package:Payrio/view/screens/authSection/signin_screen.dart';
import 'package:Payrio/view/screens/authSection/splash_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/TransactionSection/p2p_transaction_overview_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/TransactionSection/p2p_transaction_receipt_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/TransactionSection/transactions_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/bottom_nav.dart';
import 'package:Payrio/view/screens/bottomNavSection/payment_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/request_qr_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/scan_qr_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/tpinSection/tpin_create_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/tpinSection/tpin_verify_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/TransactionSection/transaction_overview_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/TransactionSection/transaction_receipt_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/payment_receipt_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/payment_successfull_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_contact_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_otp_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_overview_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_tpin_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/withdrawSection/withdraw_method_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/withdrawSection/withdraw_method_type_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/withdrawSection/withdraw_screen.dart';
import 'package:Payrio/view/screens/coming_soon_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_access_screen.dart';
import 'package:Payrio/view/screens/kycSection/camera_screen.dart';
import 'package:Payrio/view/screens/kycSection/chooose_doc_screen.dart';
import 'package:Payrio/view/screens/kycSection/select_country_screen.dart';
import 'package:Payrio/view/screens/kycSection/verify_identity_screen.dart';
import 'package:Payrio/view/screens/kycSection/video_kyc_screen.dart';
import 'package:Payrio/view/screens/notificationSection/notification_detail_s%20reen.dart';
import 'package:Payrio/view/screens/notificationSection/notification_screen.dart';
import 'package:Payrio/view/screens/profileSection/account_detail_screen.dart';
import 'package:Payrio/view/screens/profileSection/address_screen.dart';
import 'package:Payrio/view/screens/profileSection/edit_info_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_data_screen.dart';
import 'package:Payrio/view/screens/profileSection/personal_info_screen.dart';
import 'package:Payrio/view/screens/profileSection/profile_screen.dart';
import 'package:Payrio/view/screens/profileSection/qr_scanner_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/CustomBiometricScreen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/change_password_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/change_tpin_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/language_selection_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/manage_applock_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/setting_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/create_support_ticket_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/live_chat_list_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/support_chat_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/support_list_details.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/support_screen.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/supportSection/support_selection_screen.dart';
import 'package:Payrio/view/screens/profileSection/verify_email_otp_screen.dart';
import 'package:Payrio/view/screens/profileSection/verify_email_screen.dart';
import 'package:Payrio/view/screens/redeemSection/level_benefit_screen.dart';
import 'package:Payrio/view/screens/redeemSection/redeem_balance_screen.dart';
import 'package:Payrio/view/screens/redeemSection/redeem_screen.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/L10n.dart';
import 'model/response/initiateP2PResponse.dart';
import 'model/response/notificationOtpResponse.dart';
import 'model/services/PushNotificationService.dart';

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
  await Firebase.initializeApp();

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup interaction with notifications
  await PushNotificationService().setupInteractedMessage();

  // Request notification permissions
  final permissionStatus = await Permission.notification.status;
  if (permissionStatus.isDenied) {
    await Permission.notification.request();
  }

  // Get initial message
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("FirebaseMessaging:: $initialMessage");
  }

  // Set preferred orientations and run app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp(initialMessage: initialMessage));
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
      final notificationResponse = NotificationOtpResponse.fromJson(message.data);
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => NotificationOtpScreen(
              data: notificationResponse,
            )),
      );
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
          navigatorKey: navigatorKey,
          title: 'Payorio',
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
              NotificationOtpResponse? notificationResponse = NotificationOtpResponse(otp: "", notificationType: "");
              if(initialMessage?.data != null){
                notificationResponse = NotificationOtpResponse.fromJson(initialMessage!.data);
              }
              return SplashScreen(data : notificationResponse);
            },
            '/GetStartedScreen': (context) {
              return GetStartedScreen();
            },
            '/MoneySafeScreen': (context) {
              return MoneySafeScreen();
            },
            '/PhoneVerifyScreen': (context) {
              return PhoneVerifyScreen();
            },
            '/OtpVerify': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return OTPVerifyScreen(data: args);
            },
            '/NotificationOtpScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as NotificationOtpResponse?;
              return NotificationOtpScreen(data: args);
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
              return BottomNav();
            },
            '/ProfileScreen': (context) {
              return ProfileScreen();
            },
            '/PersonalInfoScreen': (context) {
              return PersonalInformationScreen();
            },
            '/EditInformationScreen': (context) {
              return EditInformationScreen();
            },
            '/AccountDetailScreen': (context) {
              return AccountDetailScreen();
            },
            '/AddMoneyScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return AddMoneyScreen(data: args);
            },
            '/WebViewScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as WebViewData?;
              return WebViewScreen(data: args);
            },
            '/PaymentMethodScreen': (context) {
              return PaymentMethodScreen();
            },
            '/ChangePasswordScreen': (context) {
              return ChangePasswordScreen();
            },
            '/ForgotPasswordScreen': (context) {
              return ForgotPasswordScreen();
            },
            '/OtpForgotPassScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as CustomerVerifyOtpPass?;
              return OtpForgotPassScreen(data: args);
            },
            '/NewPassForgotPassScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as CustomerVerifyOtpPass?;
              return NewPassForgotPassScreen(data: args);
            },
            '/PersonalDataScreen': (context) {
              return PersonalDataScreen();
            },
            '/AddressScreen': (context) {
              return AddressScreen();
            },
            '/SettingScreen': (context) {
              return SettingScreen(
                setLocale: setLocale,
              );
            },
            '/VerifyEmail': (context) {
              return VerifyEmailScreen();
            },
            '/VerifyEmailOtpScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return VerifyEmailOtpScreen(
                data: args,
              );
            },
            '/VerifyIdentityScreen': (context) {
              return VerifyIdentityScreen();
            },
            '/ChooseDocScreen': (context) {
              return ChooseDocScreen();
            },
            '/SelectCountryScreen': (context) {
              return SelectCountryScreen();
            },
            '/LevelBenefitScreen': (context) {
              return LevelBenefitScreen();
            },
            '/NotificationScreen': (context) {
              return NotificationScreen();
            },
            '/NotificationDetailScreen': (context) {
              return NotificationDetailScreen();
            },
            '/RedeemBalScreen': (context) {
              return RedeemBalanceScreen();
            },
            '/RedeemBalance': (context) {
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
              return VideoKycScreen(
                data: args,
              );
            },
            '/PaymentScreen': (context) {
              return PaymentScreen();
            },
            '/ScanQrScreen': (context) {
              return ScanQrScreen();
            },
            '/ManageAppLockScreen': (context) {
              return ManageAppLockScreen();
            },
            '/TransactionsScreen': (context) {
              return TransactionsScreen();
            },
            '/QRScannerScreen': (context) {
              return QrScannerScreen();
            },
            '/ComingSoonScreen': (context) {
              return ComingSoonScreen();
            },
            '/TransferScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as CheckCustomerResponse?;
              return TransferScreen(
                data: args,
              );
            },
            '/TransactionOverviewScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as TransactionDetails?;
              return TransactionOverviewScreen(
                data: args,
              );
            },
            '/P2PTransactionOverviewScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as P2PTransactionDetails?;
              return P2PTransactionOverviewScreen(
                data: args,
              );
            },
            '/WithdrawScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return WithdrawScreen(data: args);
            },
            '/TpinCreateScreen': (context) {
              return TpinCreateScreen();
            },
            '/TpinVerifyScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return TpinVerifyScreen(data: args);
            },
            '/ChangeTPinScreen': (context) {
              return ChangeTpinScreen();
            },
            '/TransferTPINScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as InitiateP2PRequest?;
              return TransferTpinScreen(data: args);
            },
            '/TransferOtpScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as CompleteP2PRequest;
              return TransferOtpScreen(
                data: args,
              );
            },
            '/TransferContactScreen': (context) {
              return TransferContactScreen();
            },
            '/PaymentSuccessfulScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as InitiateP2PResponse?;
              return PaymentSuccessfulScreen(data: args);
            },
            '/LanguageSelectionScreen': (context) {
              return LanguageSelectionScreen(
                setLocale: setLocale,
              );
            },
            '/SupportScreen': (context) {
              return SupportScreen();
            },
            '/SupportListDetails': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as AllSupportTicketsDetails?;
              return SupportListDetailScreen(
                data: args,
              );
            },
            '/SupportChatScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as AllSupportTicketsDetails;
              return SupportChatScreen(details: args);
            },
            '/LiveChatListScreen': (context) {
              return LiveChatListScreen();
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
              return RequestQrScreen();
            },
            '/WithdrawMethodScreen': (context) {
              return WithdrawMethodScreen();
            },
            '/SupportSelectionScreen': (context) {
              return SupportSelectionScreen();
            },
            '/WithdrawMethodTypeScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return WithdrawMethodTypeScreen(data: args);
            },
            '/TransferOverviewScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as InitiateP2PRequest?;
              return TransferOverviewScreen(data: args);
            },
            '/PaymentReceiptScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as InitiateP2PResponse?;
              return PaymentReceiptScreen(data: args);
            },
            '/P2PTransactionReceiptScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as P2PTransactionDetails?;
              return P2PTransactionReceiptScreen(data: args);
            },
            '/TransactionReceiptScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as TransactionDetails?;
              return TransactionReceiptScreen(data: args);
            },
            '/CustomBiometricScreen': (context) {
              final args =
              ModalRoute.of(context)!.settings.arguments as NotificationOtpResponse?;
              return CustomBiometricScreen(data: args);
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
