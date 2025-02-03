
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../theme/AppColor.dart';
import '../../component/custom_button_component.dart';
import '../../component/text_component.dart';

class VerifyIdentityScreen extends StatefulWidget {
  @override
  _VerifyIdentityScreenState createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
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
            statusBarColor: AppColor.PRIMARY_RED,
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
                    TextComponent(
                        text: Languages.of(context)!.labelVerifyIdentity,
                        fontSize: 26,
                        isBold: true),
                    TextComponent(
                        text: Languages.of(context)!.labelTakeFewMinutes,
                        fontSize: 16,
                        isBold: false),
                    SizedBox(
                      height: 8,
                    ),
                    TextComponent(
                        text: Languages.of(context)!.labelUseDevice,
                        fontSize: 18,
                        isBold: true),
                    TextComponent(
                        text: Languages.of(context)!.labelTakePhoto,
                        fontSize: 16,
                        isBold: false),
                    TextComponent(
                        text: Languages.of(context)!.labelRecordVideo,
                        fontSize: 16,
                        isBold: false),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButtonComponent(
                        text: Languages.of(context)!.labelChooseDoc,
                        width: screenWidth * 0.85,
                        textColor: Theme.of(context).cardColor,
                        buttonColor: Colors.white,
                        isDarkMode: isDarkMode,
                        verticalPadding: 12,
                        onTap: () {
                          Navigator.pushNamed(context, "/ChooseDocScreen");
                        })),
              ],
            ),
          ),
        )));
  }
}
