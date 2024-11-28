import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../languageSection/Languages.dart';
import '../../../theme/AppColor.dart';

class VerifyIdentityScreen extends StatefulWidget {
  @override
  _VerifyIdentityScreenState createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelKYCVerification,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: AppColor.PRIMARY,
            statusBarIconBrightness: Brightness.light, // Change icon brightness
          ),
        ),
        //backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildText(
                        context,
                        Languages.of(context)!.labelVerifyIdentity,
                        26,
                        FontWeight.w600),
                    _buildText(context, Languages.of(context)!.labelTakeFewMinutes, 16,
                    FontWeight.normal),
                SizedBox(
                  height: 8,
                ),
                _buildText(
                    context, Languages.of(context)!.labelUseDevice, 18, FontWeight.w600),
                _buildText(
                    context,
                    Languages.of(context)!.labelTakePhoto,
                    16,
                    FontWeight.normal),
                _buildText(context, Languages.of(context)!.labelRecordVideo, 16,
                    FontWeight.normal),
              ],
            ),
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
                    style: TextStyle(color: Theme.of(context).cardColor),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.zero)),
              ),
            ),
          ],
        ),
                  ),
                )));
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
