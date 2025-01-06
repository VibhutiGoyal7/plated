import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/material.dart';

import '../custom_button_component.dart';

class VerifyYourAccountSection extends StatelessWidget {
  final Function() onKeyTap;

  VerifyYourAccountSection({required this.onKeyTap});

  void _onKeyPressed() {
    onKeyTap();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
              child: Text(
                "Verify your account to:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.85,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: AppColor.PRIMARY,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Access many digital services",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: screenWidth * 0.85,
                    height: 0.4,
                    color: Colors.black45,
                  ),
                  Container(
                    width: screenWidth * 0.85,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: AppColor.PRIMARY,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Sign documents digitally",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: screenWidth * 0.85,
                    height: 0.4,
                    color: Colors.black45,
                  ),
                  Container(
                    width: screenWidth * 0.85,
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: AppColor.PRIMARY,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Request and share your official documents",
                            style: TextStyle(fontSize: 13),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButtonComponent(
                text: "Verify your account now",
                width: screenWidth * 0.8,
                isDarkMode: isDarkMode,
                verticalPadding: 10,
                buttonColor: AppColor.PRIMARY,
                textColor: Colors.white,
                onTap: () {
                  onKeyTap();
                }),
          ],
        ),
      ),
    );
  }
}
