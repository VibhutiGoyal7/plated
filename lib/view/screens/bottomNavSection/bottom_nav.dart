import 'package:Payrio/languageSection/Languages.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/screens/bottomNavSection/payment_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/reward_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/scan_qr_screen.dart';
import 'package:Payrio/view/screens/bottomNavSection/transferSection/transfer_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../utils/Helper.dart';
import 'dashboard_home_screen.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  bool _isAuthenticated = false;
  bool _authenticationAttempted = false; // Add this flag
  String _authorized = 'Not Authorized';
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _authOnResume = false;
  bool? isUserAuthenticated;
  static List<Widget> _widgetOptions = <Widget>[
    DashboardHomeScreen(),
    TransferContactScreen(),
    PaymentScreen(),
    RewardScreen(),
    ScanQrScreen(),
  ];

  @override
  void initState() {
    //_initializeBiometrics();
    super.initState();
    Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (!_authOnResume) {
        print("ResumeBio");
        setState(() {
          _authenticationAttempted = false;
        });

        _initializeBiometrics();
      }
      print("Resume");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: /*_selectedIndex != 0
            ? ScaleTransition(
                scale: _animation,
                child: _widgetOptions.elementAt(_selectedIndex))
            :*/ _widgetOptions.elementAt(_selectedIndex),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.WHITE,
        shape: CircleBorder(
            side: BorderSide(style: BorderStyle.solid, color: AppColor.WHITE)),
        onPressed: () {
          _onItemTapped(4);
        },
        child: const Icon(
          Icons.qr_code,
          size: 32,
          color: AppColor.BLACK,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: AppColor.BODY_COLOR,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => {_onItemTapped(0)},
              child: Row(
                children: [
                  SizedBox(width: 14),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: AppColor.WHITE,
                        size: 26,
                      ),
                      Text(
                        "${Languages.of(context)?.labelHome}",
                        style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {_onItemTapped(1)},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.transfer_within_a_station_sharp,
                    color: AppColor.WHITE,
                    size: 24,
                  ),
                  Text(
                    "${Languages.of(context)?.labelTransfer}",
                    style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () => {_onItemTapped(2)},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: AppColor.WHITE,
                    size: 26,
                  ),
                  Text(
                    "${Languages.of(context)?.labelPayBill}",
                    style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {_onItemTapped(3)},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_giftcard,
                    color: AppColor.WHITE,
                    size: 26,
                  ),
                  Text(
                    "${Languages.of(context)?.labelRewards}",
                    style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomBiometricScreen()),
          );*/
          //_authenticate(); // Only call authenticate if not attempted before
        }
      }
    }
  }

  Future<void> _authenticate() async {
    print("Called _authenticate()");
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        //useErrorDialogs: true,
        //stickyAuth: true,
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
      _authenticationAttempted = true; // Mark authentication attempted
    });

    if (authenticated) {
      await Helper.saveUserAuthenticated(true);
      print("User authenticated successfully.");
    } else {
      await Helper.saveUserAuthenticated(false);
      // User cancelled authentication
      print("User cancelled authentication.");
    }
  }
}
