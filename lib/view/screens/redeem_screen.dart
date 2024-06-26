import 'package:flutter/material.dart';

import '../../languageSection/Languages.dart';

class RedeemScreen extends StatefulWidget {
  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  double amount = 0.00;
  String name = "";
  final List<RedeemBalanceData> data = [
    RedeemBalanceData(
        redeemData: "Redeem INR400",
        astroPoints:
            "12,000"), /*
    RedeemBalanceData(redeemData: "Redeem INR800", astroPoints: "20,000"),
    RedeemBalanceData(redeemData: "Redeem INR1600", astroPoints: "35,000"),
    RedeemBalanceData(redeemData: "Redeem INR2400", astroPoints: "50,000"),*/
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(Languages.of(context)!.labelRedeem),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: screenHeight * 0.35,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(Icons.person, size: 125.0),
                  //SizedBox(height: 8.0),
                  Text(data[0].redeemData),
                  //SizedBox(height: 4.0),
                  Text(data[0].astroPoints),
                ],
              ),
            ),
          ),
        )));
  }
}

class RedeemBalanceData {
  final String redeemData;
  final String astroPoints;

  RedeemBalanceData({required this.redeemData, required this.astroPoints});
}
