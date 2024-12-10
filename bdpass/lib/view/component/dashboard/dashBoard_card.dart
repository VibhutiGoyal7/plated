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
                      image: AssetImage("assets/app_logo.png"),
                      height: 35,
                      width: 50,
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
                      height: 34,
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.WHITE,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.5),
                    bottomRight: Radius.circular(12.5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/sign_document_icon.svg",
                            height: 28,
                            width: 28,
                            colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? isVerified
                                        ? AppColor.WHITE
                                        : Colors.white30
                                    : isVerified
                                        ? AppColor.TEXT_COLOR
                                        : Colors.black38,
                                BlendMode.srcIn),
                            semanticsLabel: 'A red up arrow'),
                        SizedBox(
                          width: 8,
                        ),
                        Text("${Languages.of(context)?.labelSignDocuments}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? isVerified
                                        ? AppColor.WHITE
                                        : Colors.white30
                                    : isVerified
                                        ? AppColor.TEXT_COLOR
                                        : Colors.black38))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                        size: 28,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("${Languages.of(context)?.labelVerifySignature}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

  }

}
