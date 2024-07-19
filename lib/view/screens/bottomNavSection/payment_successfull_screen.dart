import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  @override
  _PaymentSuccessfulScreenState createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  String token = "";
  String date="19 July 2024";
  String time="10:00 AM";
  String imageUrl="";
  String name="Vibhuti";
  String phoneNo="1234567890";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white,),
          Text("Payment Successful", style: TextStyle(color: Colors.white,fontSize: 16),),
          Text("${date} at ${time}", style: TextStyle(color: Colors.white,fontSize: 16),),
          Card(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      imageUrl == ""
                          ? Container(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.WHITE,
                          backgroundImage:
                          AssetImage("assets/profile_user.png"),
                        ),
                      )
                          : ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            imageUrl as String,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              // You can return any widget here to display in case of an error
                              return Container(
                                height: 60,
                                width: 60,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColor.WHITE,
                                  backgroundImage: AssetImage(
                                    "assets/profile_user.png",
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white38,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    height:60,
                                    width: 60,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          )),
                      Column(
                        children: [

                          Text("${name}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Text("${phoneNo}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: isDarkMode ? Colors.white70 : Colors.black54)),
                        ],

                      )
                    ],
                  ),
                  Text("100", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  Divider(height: 0.5,color: Colors.grey,),

                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildFooter(context)
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/BottomNav');
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: AppColor.PRIMARY,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
