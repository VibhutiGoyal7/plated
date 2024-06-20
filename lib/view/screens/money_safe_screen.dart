import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';

class MoneySafeScreen extends StatefulWidget {
  @override
  _MoneySafeScreenState createState() => _MoneySafeScreenState();
}

class _MoneySafeScreenState extends State<MoneySafeScreen> {
  String token = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Payrio", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          Image(
            alignment: Alignment.topLeft,
            image: AssetImage(
                "assets/money_safe.png"),

          ),
          SizedBox(height: 6,),
          Text("Your Money Stays Safe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 8,),
          Text("Your money stays safeWe have all security measures put in place, so that you really feel that your money is in safe hands.",
            style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
          SizedBox(height: 8,),

          _buildFooter(context: context, text: "SignUp", onTap: ()
          {
            Navigator.pushNamed(context, '/PhoneVerifyScreen');
          }),
          SizedBox(height: 8,),

          _buildFooter(context: context,text: "SignIn", onTap: ()
            {
              Navigator.pushNamed(context, '/SignInScreen',
                  arguments: "");
            }
          )

        ],
      ),
    );
  }

  Widget _buildFooter({required BuildContext context,required String text,required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                onTap,
              child: Text(
                text,
                style: TextStyle(
                    color:Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                  Colors.blueAccent ,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
    );
  }
}