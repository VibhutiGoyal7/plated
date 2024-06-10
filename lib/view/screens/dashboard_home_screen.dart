import 'package:flutter/material.dart';

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
                    backgroundImage: AssetImage("assets/profile_user.png"),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ProfileScreen');
                  },
                ),
                SizedBox(width: 4), // Add space between avatar and text
                Text(
                  "HI, $name",
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
                        "Standard",
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
                  "TOTAL BALANCE",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.remove_red_eye_rounded),
              ],
            ),
            SizedBox(height: 8), // Add space between text and amount
            Text(
              "INR $amount",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5), // Add space between sections
            Row(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Spacer(),
                      Text(
                        "INR $amount",
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ]),
                  ),
                ),
              ),

              SizedBox(width: 8), // Add space between cards
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.17,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Spacer(),
                      Text(
                        "USD $amount",
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ]),
                  ),
                ),
              ),
            ]),
            Row(
              children: [
                Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(children: [Icon(Icons.edit)]),
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
                            "Add Money",
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.black),
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
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
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
                          "Exchange",
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
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
              "NEWS & PROMOTIONS",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
