import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/view/screens/bottomNavSection/documents_screen.dart';
import 'package:BDOne/view/screens/bottomNavSection/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../utils/Helper.dart';
import 'travel_dashboard_screen.dart';

class TravelBottomNav extends StatefulWidget {
  @override
  _TravelBottomNavState createState() => _TravelBottomNavState();
}

class _TravelBottomNavState extends State<TravelBottomNav>
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
    TravelDashboardScreen(),
    DocumentsScreen(),/*
    NotificationScreen(),*/
    HistoryScreen(),
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
        setState(() {
          _authenticationAttempted = false;
        });

        _initializeBiometrics();
      }
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      extendBody: true,
      /* floatingActionButton: FloatingActionButton(
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
      ),*/
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 54,
            color:Colors.blue.shade900,// AppColor.BODY_COLOR,
            
            
            /* shape: const CircularNotchedRectangle(),
            notchMargin: 6,*/
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => {_onItemTapped(0)},
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      _selectedIndex == 0
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 22,
                                    color: AppColor.PRIMARY,
                                  ),
                                  SizedBox(width: 4,),
                                  Text(
                                    "${Languages.of(context)?.labelHome}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY, fontSize: 10),
                                  )
                                ],
                              ),
                            )
                          : Icon(
                            Icons.home,
                            color: AppColor.WHITE,
                            size: 24,
                          ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {_onItemTapped(1)},
                  child: _selectedIndex == 1
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Icon(
                                Icons.airplanemode_on_outlined,
                                size: 22,
                                color: AppColor.PRIMARY,
                              ),
                              SizedBox(width: 4,),
                              Text(
                                "Travel",
                                style: TextStyle(color: AppColor.PRIMARY, fontSize: 10),
                              )
                            ],
                          ),
                        )
                      : Icon(
                        Icons.delivery_dining_sharp,
                        color: AppColor.WHITE,
                        size: 24,
                      ),
                ),
                GestureDetector(
                  onTap: () => {_onItemTapped(2)},
                  child: Row(
                    children: [
                      _selectedIndex == 2
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal:8,vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 22,
                                    color: AppColor.PRIMARY,
                                  ),
                                  SizedBox(width: 4,),
                                  Text(
                                    "${Languages.of(context)?.labelProfile}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY, fontSize: 10),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                            Icons.person,
                            color: AppColor.WHITE,
                            size: 24,
                          ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeBiometrics() async {
    bool? retrievedBiometric = await Helper.getBiometric();

    bool? canCheckBiometric = retrievedBiometric;
    // print('Can CheckBiometric: $canCheckBiometric');
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
