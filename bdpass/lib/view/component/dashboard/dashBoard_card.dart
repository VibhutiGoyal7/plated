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
                              Icons.check_circle,
                              color: AppColor.PRIMARY,
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text("${Languages.of(context)?.labelSignature}: ",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black)),
                            Text(
                              "${Languages.of(context)?.labelQualified}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColor.PRIMARY,
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text("${Languages.of(context)?.labelDocuments}: ",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black)),
                            Text(
                              "${Languages.of(context)?.labelAvailable}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
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
                  Row(
                    children: [
                      SvgPicture.asset("assets/sign_document_icon.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              AppColor.PRIMARY, BlendMode.srcIn),
                          semanticsLabel: 'A red up arrow'),
                      SizedBox(
                        width: 4,
                      ),
                      Text("${Languages.of(context)?.labelSignDocuments}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline_outlined),
                      SizedBox(
                        width: 4,
                      ),
                      Text("${Languages.of(context)?.labelVerifySignature}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
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
