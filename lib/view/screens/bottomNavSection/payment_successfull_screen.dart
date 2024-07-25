import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/completeP2PRequest.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';

class PaymentSuccessfulScreen extends StatefulWidget {

  final CompleteP2PRequest? data;// Define the 'data' parameter here

  PaymentSuccessfulScreen({Key? key, required this.data}) : super(key: key);


  @override
  _PaymentSuccessfulScreenState createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  String token = "";
  String date="";
  String time="";
  String imageUrl="";
  String name="";
  String phoneNo="";
  String amount="";
  String? currencySymbol="";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
     date="${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
     time="${DateFormat('hh:mm a').format(DateTime.now())}";
     imageUrl="${widget.data?.imageUrl}";
     name="${widget.data?.fullName}";
     phoneNo="${widget.data?.receiverPhoneNumber}";
     amount="${widget.data?.amount}";
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        currencySymbol = symbol;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Icon(Icons.check_circle, color: Colors.white, size: 65,),
              Text("Payment Successful", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w600),),
              SizedBox(height:4,),
              Text("${date} at ${time}", style: TextStyle(color: Colors.yellow,fontSize: 13),),
              SizedBox(height: 55,),
              Card(
                child: Container(
                  height: screenHeight*0.25,
                  width: screenWidth*0.7,
                  padding: EdgeInsets.all(16),
                  child: Center(

                    child: Column(
                      children: [
                        Row(
                          children: [
                            imageUrl == ""
                                ? Container(
                              height: 45,
                              width: 45,
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
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // You can return any widget here to display in case of an error
                                    return Container(
                                      height: 45,
                                      width: 45,
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
                                          height:45,
                                          width: 45,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                )),
                            SizedBox(width: 6,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("${name}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                Text("${phoneNo}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: isDarkMode ? Colors.white70 : Colors.black54)),
                              ],

                            )
                          ],
                        ),
                        SizedBox(height: 14,),
                        Text(addCurrencySymbol(currencySymbol , amount), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                        SizedBox(height: 14,),
                        Divider(height: 0.5,color: Colors.grey,),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, size: 22,),
                            SizedBox(width: 6,),
                            Text("Share", style: TextStyle(fontSize: 16),)
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 200,),
              _buildFooter(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth*0.7,
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
                style: TextStyle(color: AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.white,
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
