import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../languageSection/Languages.dart';
import '../../../theme/AppColor.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard();

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var isVerified = false;

    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Image(
                      image: AssetImage(isDarkMode
                          ? "assets/app_logo_dark.png"
                          :"assets/app_logo.png"),
                      height: 30,
                      fit: BoxFit.fitHeight,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Akash Singh",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "${Languages.of(context)?.labelVerifiedAccount}",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.PRIMARY),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              isVerified ? Icons.check_circle : Icons.cancel,
                              color: isVerified
                                  ? AppColor.PRIMARY
                                  : AppColor.TEXT_RED,
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text("${Languages.of(context)?.labelSignature}: ",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                            Text(
                              isVerified
                                  ? "${Languages.of(context)?.labelQualified}"
                                  : "N/A",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              false ? Icons.check_circle : Icons.cancel,
                              color:
                                  false ? AppColor.PRIMARY : AppColor.TEXT_RED,
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text("${Languages.of(context)?.labelDocuments}: ",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                            Text(
                              isVerified
                                  ? "${Languages.of(context)?.labelAvailable}"
                                  : "N/A",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 12, color: AppColor.PRIMARY)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

}
