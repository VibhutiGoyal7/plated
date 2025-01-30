import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:flutter/material.dart';

class RideDriverDetailScreen extends StatefulWidget {
  @override
  _RideDriverDetailScreenState createState() => _RideDriverDetailScreenState();
}

class _RideDriverDetailScreenState extends State<RideDriverDetailScreen> {
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
              backgroundColor: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
              title: Text(
                "Driver Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              bottom: false,
              minimum: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDestinationScreen(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Reviews",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "(235 reviews)",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5),
                              child: Image(
                                  height: 40,
                                  image: AssetImage("assets/address.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mohammed",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "5.0",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  "Lorem ipsum dolor sit amet consectetur. Lectus in neque dolor non. Morbi diam arcu sit iaculis. Nibh fermentum curabitur magna commodo et turpis sagittis bibendum. Feugiat ut quis nec diam elit.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "2 hrs ago",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5),
                              child: Image(
                                  height: 40,
                                  image: AssetImage("assets/address.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mohammed",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "5.0",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  "Lorem ipsum dolor sit amet consectetur. Lectus in neque dolor non. Morbi diam arcu sit iaculis. Nibh fermentum curabitur magna commodo et turpis sagittis bibendum. Feugiat ut quis nec diam elit.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "2 hrs ago",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5),
                              child: Image(
                                  height: 40,
                                  image: AssetImage("assets/address.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mohammed",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "5.0",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  "Lorem ipsum dolor sit amet consectetur. Lectus in neque dolor non. Morbi diam arcu sit iaculis. Nibh fermentum curabitur magna commodo et turpis sagittis bibendum. Feugiat ut quis nec diam elit.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "2 hrs ago",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5),
                              child: Image(
                                  height: 40,
                                  image: AssetImage("assets/address.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mohammed",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "5.0",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  "Lorem ipsum dolor sit amet consectetur. Lectus in neque dolor non. Morbi diam arcu sit iaculis. Nibh fermentum curabitur magna commodo et turpis sagittis bibendum. Feugiat ut quis nec diam elit.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "2 hrs ago",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: screenWidth * 0.8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColor.PRIMARY_ACCENT),
                      child: Column(
                        children: [
                          Text(
                            "Contact",
                            style: TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildDestinationScreen() {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_filled,
            size: 60,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "America Airlines",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "5.0 (235 ratings)",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              )
            ],
          ),
          Container(
            height: 0,
            width: screenWidth * 0.85,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_car_filled,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2,674 KM",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Distance shared",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
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
