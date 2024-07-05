import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';

class ComingSoonScreen extends StatefulWidget {
  @override
  _ComingSoonScreenState createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  double amount = 0.00;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelComingSoon,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
          child: Center(
              child: Text(
            Languages.of(context)!.labelComingSoon,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ))),
    ));
  }
}
