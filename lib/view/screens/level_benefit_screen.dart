import 'package:flutter/material.dart';
import 'package:Payrio/languageSection/Languages.dart';
import 'package:Payrio/theme/AppColor.dart';

class LevelBenefitScreen extends StatefulWidget {
  @override
  _LevelBenefitScreenState createState() => _LevelBenefitScreenState();
}

class _LevelBenefitScreenState extends State<LevelBenefitScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelLevelBenefit,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.white,),
              onPressed: () {
                Navigator.pushNamed(context, "/NotificationScreen");
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Languages.of(context)!.labelStandard,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '100 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                Languages.of(context)!.labelAccumulated,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                '2900',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                Languages.of(context)!.labelPtsToSilver,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(text: Languages.of(context)!.labelStandard),
                  Tab(text: Languages.of(context)!.labelSilver),
                  Tab(text: Languages.of(context)!.labelGOld),
                ],
                /*labelColor: AppColor.WHITE,
                unselectedLabelColor: AppColor.WHITE,
                indicatorColor: AppColor.WHITE,*/
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Standard(),
                    Silver(),
                    Gold(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Standard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                Languages.of(context)!.labelLevelExclusives,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                /*decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(18),
                ),*/
                child: Text(
                  Languages.of(context)!.labelExclusiveBenefits,
                  style: TextStyle(
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                Languages.of(context)!.labelMultipliers,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(6),
                /*decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),*/
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'x',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            Languages.of(context)!.labelOnlinePayments,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        Languages.of(context)!.labelEarnPayarioPts,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Silver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Text(
                      Languages.of(context)!.labelLockedLvl,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Text(
                      Languages.of(context)!.labelUnlockWith,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '3,000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Text(
                Languages.of(context)!.labelLevelExclusives,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                 
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  Languages.of(context)!.labelPreviousBenefits,
                  style: TextStyle(
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 4),
              child: Text(
                Languages.of(context)!.labelMultipliers,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                              color: Color(0xFF20e7a6),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'x',
                            style: TextStyle(
                              color: Color(0xFF20e7a6),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            Languages.of(context)!.labelOnlinePayments,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        Languages.of(context)!.labelEarnPayarioPtsWithMin1670,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Text(
                      Languages.of(context)!.labelLockedLvl,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Text(
                      Languages.of(context)!.labelUnlockWith,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '10,000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 4),
              child: Text(
                Languages.of(context)!.labelLevelExclusives,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                 
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  Languages.of(context)!.labelPreviousBenefits,
                  style: TextStyle(
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Text(
                Languages.of(context)!.labelMultipliers,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Text(
                            '2',
                            style: TextStyle(
                              color: Color(0xFF20e7a6),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'x',
                            style: TextStyle(
                              color: Color(0xFF20e7a6),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            Languages.of(context)!.labelOnlinePayments,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        Languages.of(context)!.label2xEarnPayarioPtsWithMin1670,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
