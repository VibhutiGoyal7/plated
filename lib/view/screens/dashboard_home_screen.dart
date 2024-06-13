import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_flutter_app/model/response/setUpAccountResponse.dart';

import '../../Strings/Languages.dart';
import '../../theme/AppColor.dart';
import '../../utils/Helper.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  double amount = 0.00;
  String name = "";
  bool isAmountVisible = false;
  bool isUSDVisible = false;

  @override
  void initState() {
    super.initState();
    isAmountVisible = true;
    isUSDVisible = false;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColor.WHITE,
                            backgroundImage:
                                AssetImage("assets/profile_user.png"),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/ProfileScreen');
                          },
                        ),
                        SizedBox(width: 4), // Add space between avatar and text
                        Text(
                          "${Languages.of(context)!.labelHi}, $name",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.notifications)
                      ],
                    ),
                    SizedBox(height: 6), // Add space between sections
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: Colors.lightGreen,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                              child: Text(
                                Languages.of(context)!.labelStandard,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            SizedBox(
                                width: 8), // Add space between text and card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Colors.black,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "100",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Add space between sections
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context)!.labelTotalBalance,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            isAmountVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: isDarkMode ? Colors.white60 : Colors.black45,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                isAmountVisible = !isAmountVisible;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // Add space between text and amount
                    Text(
                      "${Languages.of(context)!.labelINR} "
                      "${isAmountVisible ? amount : "**"}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Add space between sections
                    Row(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image(
                                    alignment: Alignment.topLeft,
                                    image: AssetImage(
                                        "assets/india_flag_icon.png"),
                                    width: 35,
                                    height: 60,
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${Languages.of(context)!.labelINR} "
                                        "${isAmountVisible ? amount : "**"}",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ),

                      SizedBox(width: 8), // Add space between cards
                      isUSDVisible
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.38,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image(
                                          alignment: Alignment.topLeft,
                                          image: AssetImage(
                                              "assets/united_states_flag_icon.png"),
                                          width: 35,
                                          height: 60,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${Languages.of(context)!.labelUSD} "
                                              "${isAmountVisible ? amount : "**"}",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 0,
                            ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Row(children: [
                                Icon(
                                  Icons.edit,
                                  size: 24,
                                )
                              ]),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/AddMoneyScreen');
                          },
                          child: Container(
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      Languages.of(context)!.labelAddMoney,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 16,
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        "Send",
                                        style: TextStyle(fontSize: 14.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Icon(
                                      Icons.send,
                                      size: 16,
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        Languages.of(context)!.labelExchange,
                                        style: TextStyle(fontSize: 14.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Icon(
                                      Icons.currency_exchange,
                                      size: 16,
                                    )
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      Languages.of(context)!.labelNews,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
          ),
        ));
  }
  Future<SetUpAccountResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    SetUpAccountResponse? userDetails = await Helper.getUserDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = userDetails!.firstName!;

      });
    });
    return userDetails;
  }
}
