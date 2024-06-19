import 'package:flutter/material.dart';
import 'package:payrio/theme/AppColor.dart';
import 'package:payrio/view/screens/bottomNavSection/payment_screen.dart';
import 'package:payrio/view/screens/bottomNavSection/reward_screen.dart';
import 'package:payrio/view/screens/bottomNavSection/transfer_screen.dart';
import 'dashboard_home_screen.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardHomeScreen(),
    TransferScreen(),
    PaymentScreen(),
    RewardScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.WHITE,
        shape: CircleBorder(
            side: BorderSide(style: BorderStyle.solid, color: AppColor.WHITE)),
        onPressed: () {},
        child: const Icon(
          Icons.qr_code,
          size: 32,
          color: AppColor.BLACK,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 55,
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
                        "Home",
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
                    "Transfer",
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
                    "Payment",
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
                    "Rewards",
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
}
