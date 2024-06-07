import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget{

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
          child:Align(alignment: Alignment.centerLeft,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://example.com/image.jpg'),
                ),
                Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.left ,)
                ,Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.0),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(6.0),
                        child: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left ,)
                      ),
                      GestureDetector(
                        onTap: () {Navigator.pushNamed(context, '/AccountDetailScreen',
                            arguments: "");},
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding:  EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Account Details", style: TextStyle(fontSize: 16.0)),
                                Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {Navigator.pushNamed(context, '/PersonalInfoScreen',
                      arguments: "");},
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding:  EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Personal Information", style: TextStyle(fontSize: 16.0)),
                                Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(6.0),
                          child: Text("Security", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left ,)
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("2-step verification", style: TextStyle(fontSize: 16.0)),
                              Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(6.0),
                          child: Text("Payment Methods", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left ,)
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Added Cards", style: TextStyle(fontSize: 16.0)),
                              Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(6.0),
                          child: Text("Help & Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left ,)
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          //margin: EdgeInsets.all(5.0),
                          width: double.infinity,
                          padding:  EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Settings", style: TextStyle(fontSize: 16.0)),
                              Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

}