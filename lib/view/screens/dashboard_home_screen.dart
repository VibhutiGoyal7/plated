import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';
import '../../theme/AppColor.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  double amount = 0.00;
  String name = "NAME";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                IconButton(
                  icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColor.WHITE,
                    backgroundImage: AssetImage("assets/profile_user.png"),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ProfileScreen');
                  },
                ),
                SizedBox(width: 4), // Add space between avatar and text
                Text(
                  "${Languages.of(context)!.labelHi}, $name",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
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
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
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
                    SizedBox(width: 8), // Add space between text and card
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
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
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
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.remove_red_eye_rounded),
              ],
            ),
            SizedBox(height: 8), // Add space between text and amount
            Text(
              "${Languages.of(context)!.labelINR} $amount",
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
                            image: AssetImage("assets/india_flag_icon.png"),
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
                                "${Languages.of(context)!.labelINR} $amount",
                                style: TextStyle(
                                  fontSize: 22.0,
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
              Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                "${Languages.of(context)!.labelUSD} $amount",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 10,
            ),
            Row(
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
                          size: 20,
                        )
                      ]),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
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
                            vertical: 8.0, horizontal: 6.0),
                        child: Row(children: [
                          Text(
                            Languages.of(context)!.labelAddMoney,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ]),
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text(
                          "Send",
                          style: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text(
                          Languages.of(context)!.labelExchange,
                          style: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  ),
                ))
              ],
            ),
            SizedBox(height: 5.0),
            Text(
              Languages.of(context)!.labelNews,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
