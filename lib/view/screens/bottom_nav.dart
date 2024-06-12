import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/view/screens/RewardScreen.dart';
import 'package:mvvm_flutter_app/view/screens/Transfer_screen.dart';
import 'package:mvvm_flutter_app/view/screens/dashboard_home_screen.dart';
import 'package:mvvm_flutter_app/view/screens/payment_screen.dart';

import '../../Strings/Languages.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardHomeScreen(),
    TransferScreen(),
    RewardScreen(),
    PaymentScreen()
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Languages.of(context)!.labelHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: Languages.of(context)!.labelTransfer,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: Languages.of(context)!.labelRewards,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: Languages.of(context)!.labelPayment,
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: isDarkMode ? Colors.blue[500] : Colors.blue[500],
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
