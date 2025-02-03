import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/view/screens/rideSection/RequestSection/request_history_screen.dart';
import 'package:BDOne/view/screens/rideSection/ride_account_screen.dart';
import 'package:BDOne/view/screens/rideSection/ride_history_screen.dart';
import 'package:BDOne/view/screens/rideSection/ride_home_screen.dart';
import 'package:BDOne/view/screens/rideSection/ride_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../utils/Helper.dart';

class RideBottomNav extends StatefulWidget {
  @override
  _RideBottomNavState createState() => _RideBottomNavState();
}

class _RideBottomNavState extends State<RideBottomNav>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool? isUserAuthenticated;
  static List<Widget> _widgetOptions = <Widget>[
    RideHomeScreen(),
    RideServicesScreen(),
    RequestHistoryScreen(),
    RideAccountScreen(),
  ];

  @override
  void initState() {
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
      backgroundColor: Colors.white,
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
                                    "${Languages.of(context)?.labelBookCab}",
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
                                Icons.menu,
                                size: 22,
                                color: AppColor.PRIMARY_ACCENT,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${Languages.of(context)?.labelServices}",
                                style: TextStyle(
                                    color: AppColor.PRIMARY_ACCENT,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      : Icon(
                          Icons.menu,
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
                                    Icons.wallet,
                                    size: 22,
                                    color: AppColor.PRIMARY_ACCENT,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelRideHistory}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY_ACCENT,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.wallet,
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
                                    Icons.person,
                                    size: 22,
                                    color: AppColor.PRIMARY_ACCENT,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelAccount}",
                                    style: TextStyle(
                                        color: AppColor.PRIMARY_ACCENT,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Icon(
                              Icons.person,
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
}
