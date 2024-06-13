import 'package:flutter/material.dart';

class SelectCountryScreen extends StatefulWidget {
  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
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
        title: Text("ISSUING COUNTRY",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Suggested Country", style: TextStyle(fontSize: 14)),


              ]
          ),
        ),
      ),
    );
  }
}
