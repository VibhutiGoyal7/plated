import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  double amount = 0.00;
  String name = "";

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Languages.of(context)!.labelRewards, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Languages.of(context)!.availablePayario, style: TextStyle(fontSize: 11.0),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text("100",style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios_rounded)
                                  ],
                                ),
                              ),
                              Text("2000 ${Languages.of(context)!.labelPayarioPts}", style: TextStyle(fontSize: 10.0),),
                              SizedBox(height: 12.0,),
                              Container(color: isDarkMode? Colors.white60 :Colors.black54,child: SizedBox(width: double.infinity,height: 1.0)),
                              SizedBox(height: 12.0,),
                              Row(
                                children: [
                                  Text(Languages.of(context)!.labelStandard, style: TextStyle(fontSize: 12.0,),),
                                  Spacer(),
                                  Icon(Icons.info_outline_rounded, size: 18.0,)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child : Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Languages.of(context)!.labelRedeemBal, style: TextStyle(fontSize: 14.0)),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ]
                        )
                      )
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}