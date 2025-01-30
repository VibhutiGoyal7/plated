import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/view/screens/retaurantSection/restaurant_cart_screen.dart';
import 'package:BDOne/view/screens/retaurantSection/restaurant_favourite_screen.dart';
import 'package:BDOne/view/screens/retaurantSection/restaurant_shop_screen.dart';
import 'package:BDOne/view/screens/retaurantSection/restaurant_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../utils/Helper.dart';

class RestaurantBottomNav extends StatefulWidget {

  final int? data;

  RestaurantBottomNav({Key? key, required this.data}) : super(key: key);
  @override
  _RestaurantBottomNavState createState() => _RestaurantBottomNavState();
}

class _RestaurantBottomNavState extends State<RestaurantBottomNav>
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
    RestaurantHomeScreen(),
    RestaurantShopScreen(),
    RestaurantCartScreen(),
    RestaurantFavouriteScreen(),
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

    if (widget.data != null) {
      setState(() {
        _selectedIndex = widget.data!;
      });
      // _widgetOptions.elementAt(int.parse("${widget.data}"));
    }

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
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 0.5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 54,
            color: Theme.of(context).cardColor,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.transparent),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 22,
                                    color: AppColor.PRIMARY_ACCENT,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelHome}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY_ACCENT,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )
                          : Icon(
                              Icons.home,
                              color: Theme.of(context).focusColor,
                              size: 24,
                            ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {_onItemTapped(1)},
                  child: _selectedIndex == 1
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.transparent),
                          child: Column(
                            children: [
                              Icon(
                                Icons.store_mall_directory_outlined,
                                size: 22,
                                color: AppColor.PRIMARY_ACCENT,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${Languages.of(context)?.labelShop}",
                                style: TextStyle(
                                    color: AppColor.PRIMARY_ACCENT,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      : Icon(
                          Icons.store_mall_directory_outlined,
                          color: Theme.of(context).focusColor,
                          size: 24,
                        ),
                ),
                GestureDetector(
                  onTap: () => {_onItemTapped(2)},
                  child: Row(
                    children: [
                      _selectedIndex == 2
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.transparent),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 22,
                                    color: AppColor.PRIMARY_ACCENT,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelCart}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY_ACCENT,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).focusColor,
                              size: 24,
                            ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {_onItemTapped(3)},
                  child: Row(
                    children: [
                      _selectedIndex == 3
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.transparent),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 22,
                                    color: AppColor.PRIMARY_ACCENT,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelFavourite}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY_ACCENT,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).focusColor,
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
