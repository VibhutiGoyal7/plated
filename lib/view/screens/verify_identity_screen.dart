import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';

class VerifyIdentityScreen extends StatefulWidget {
  @override
  _VerifyIdentityScreenState createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
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
          /*title: Text(
            Languages.of(context)!.labelForgotPass,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),*/
        ),
        //backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildText(context, "Verify your Identity", 24, FontWeight.bold),
                      _buildText(
                          context, "It should take a few minutes", 14, FontWeight.normal),
                      SizedBox(
                        height: 8,
                      ),
                      _buildText(context, "Use your device to:", 16, FontWeight.bold),
                      _buildText(context, "1. Take a photo of your identity document", 16, FontWeight.normal),
                      _buildText(context, "2. Record a video of your face", 16, FontWeight.normal),
                      SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(

                          onPressed: () {
                            Navigator.pushNamed(context, "/ChooseDocScreen");
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              Languages.of(context)!.labelChooseDoc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:  Colors.blueAccent),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.0),
                              backgroundColor:  Colors.white,
                              elevation: 3,
                              shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  Widget _buildText(
    BuildContext context,
    String text,
    double size,
    FontWeight weight,
  ) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(fontWeight: weight, fontSize: size),
      ),
    );
  }
}
