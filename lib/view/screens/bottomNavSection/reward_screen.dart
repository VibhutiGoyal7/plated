import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../languageSection/Languages.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  double amount = 0.00;
  String name = "";
  bool isComingSoon = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    DateTime? lastBackPressed;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if(didPop)
        {
          return;
        }
        Navigator.pushNamed(context, "/BottomNav");
      },
      child: Scaffold(
          body: SafeArea(
        child: isComingSoon ? Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.labelRewards,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Languages.of(context)!.availablePayario,
                              style: TextStyle(fontSize: 11.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                 /* Navigator.pushNamed(
                                      context, "/LevelBenefitScreen");*/
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("100",
                                        style: TextStyle(
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,
                                        size: 22.0)
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "2000 ${Languages.of(context)!.labelPayarioPts}",
                              style: TextStyle(fontSize: 10.0),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Container(
                                color:
                                    isDarkMode ? Colors.white60 : Colors.black54,
                                child: SizedBox(
                                    width: double.infinity, height: 1.0)),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  Languages.of(context)!.labelStandard,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/RedeemBalScreen");
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Languages.of(context)!.labelRedeemBal,
                                      style: TextStyle(fontSize: 14.0)),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      size: 16.0)
                                ]))),
                  ),
                )
              ],
            )) :
            Center(
              child: Text(Languages.of(context)!.labelComingSoon,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),),
            ),
      )),
    );
  }
}
