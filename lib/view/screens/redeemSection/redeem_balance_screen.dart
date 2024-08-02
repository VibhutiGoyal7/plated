import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';

class RedeemBalanceScreen extends StatefulWidget {
  @override
  _RedeemBalanceScreenState createState() => _RedeemBalanceScreenState();
}

class _RedeemBalanceScreenState extends State<RedeemBalanceScreen> {
  final List<RedeemBalanceData> data = [
    RedeemBalanceData(redeemData: "Redeem INR400", astroPoints: "12,000"),
    RedeemBalanceData(redeemData: "Redeem INR800", astroPoints: "20,000"),
    RedeemBalanceData(redeemData: "Redeem INR1600", astroPoints: "35,000"),
    RedeemBalanceData(redeemData: "Redeem INR2400", astroPoints: "50,000"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(Languages.of(context)!.labelBalance),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  //childAspectRatio: 1.0,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    data: data[index],
                    onTap: () {
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final RedeemBalanceData data;
  final VoidCallback onTap;

  const ListItem({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/RedeemBalance");

      },
      child: Container(
        padding: EdgeInsets.only(top: 0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 40.0),
              //SizedBox(height: 8.0),
              Text(data.redeemData,
              style: TextStyle(fontSize: 14),),
              //SizedBox(height: 4.0),
              Text(data.astroPoints,
                style: TextStyle(fontSize: 14),),
            ],
          ),
        ),
      ),
    );
  }
}

class RedeemBalanceData {
  final String redeemData;
  final String astroPoints;

  RedeemBalanceData({required this.redeemData, required this.astroPoints});
}
