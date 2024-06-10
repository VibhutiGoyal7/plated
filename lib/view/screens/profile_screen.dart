import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/profile_user.png"),
                  ),
                  _buildLabelText(context, "Name"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.0),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, "Profile")),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/AccountDetailScreen',
                                arguments: "");
                          },
                          child: _buildCard(context, "Account Details"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/PersonalInfoScreen',
                                arguments: "");
                          },
                          child: _buildCard(context, "Personal Information"),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, "Security")),
                        _buildCard(context, "2-step verification"),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, "Payment Methods")),
                        _buildCard(context, "Added Cards"),
                        Container(
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, "Help & Support")),
                        _buildCard(context, "Settings"),
                      ]),
                ],
              ),
            )),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      textAlign: TextAlign.left,
    );
  }

  _buildCard(BuildContext context, String text) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 14.0)),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
