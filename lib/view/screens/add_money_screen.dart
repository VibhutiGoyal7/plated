import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class AddMoneyScreen extends StatefulWidget {
  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  String amount = "";
  bool expanded = false;

  final List<Map<String, dynamic>> items = [
    {'icon': 'assets/united_states_flag_icon.svg', 'label': 'USD'},
    {'icon': 'assets/india_flag_icon.svg', 'label': 'INR'},
  ];

  Map<String, dynamic> selectedItem = {
    'icon': 'assets/united_states_flag_icon.svg',
    'label': 'USD'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelAddMoney,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 1.0,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter amount',
                /*style: TextStyle(
                  fontFamily: 'popins',
                )*/
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: Languages.of(context)!.labelZero,
                  //labelStyle: TextStyle(fontFamily: 'popins'),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
            ),
            Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: amount.isNotEmpty ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        /*primary: amount.isNotEmpty
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).colorScheme.onSecondary,*/
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                      ),
                      child: Text(
                        Languages.of(context)!.labelProceed,
                        style: TextStyle(fontFamily: 'popins'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

