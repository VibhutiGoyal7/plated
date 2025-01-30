import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:flutter/material.dart';

class RideAccountScreen extends StatefulWidget {
  @override
  _RideAccountScreenState createState() => _RideAccountScreenState();
}

class _RideAccountScreenState extends State<RideAccountScreen> {
  late double screenWidth;
  late double screenHeight;
  bool isDataAvail = true;
  bool isPinVerified = false;

  late bool isDarkMode;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNav");
      },
      child: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: Scaffold(
            appBar: AppBar(
              leading: SizedBox(),
              backgroundColor: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
              title: Text(
                "Account",
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
                bottom: false,
                minimum: EdgeInsets.only(bottom: 70),
                child: _buildNoDataScreen())),
      ),
    );
  }

  Widget _buildNoDataScreen() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Icon(
              Icons.history,
              size: 45,
              color: Theme.of(context).focusColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No data found!",
              style: TextStyle(fontSize: 12, color: Theme.of(context).focusColor,),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
