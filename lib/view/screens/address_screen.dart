import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String streetName = "";
  String streetNumber = "";
  String state = "";
  String city = "";
  String postCode = "";

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
          Languages.of(context)!.labelAddressDetails,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(Languages.of(context)!.labelStreetName, streetName,
                  (value) {
                setState(() {
                  streetName = value;
                });
              }),
              buildTextField(Languages.of(context)!.labelStreetNo, streetNumber,
                  (value) {
                setState(() {
                  streetNumber = value;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: buildReadOnlyField(
                        Languages.of(context)!.labelCountry,
                        Languages.of(context)!.labelIndia),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: buildTextField(
                        Languages.of(context)!.labelState, state, (value) {
                      setState(() {
                        state = value;
                      });
                    }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: buildTextField(
                        Languages.of(context)!.labelCity, city, (value) {
                      setState(() {
                        city = value;
                      });
                    }),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: buildTextField(
                        Languages.of(context)!.labelPostalCode, postCode,
                        (value) {
                      setState(() {
                        postCode = value;
                      });
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, Function(String) onChanged) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
