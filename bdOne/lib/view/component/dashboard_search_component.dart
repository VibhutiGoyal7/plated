import 'package:flutter/material.dart';

import '../../theme/AppColor.dart';

class DashboardSearchComponent extends StatelessWidget {
  final TextEditingController queryController;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final String hintText;
  final Function() onTap;

  const DashboardSearchComponent({
    Key? key,
    required this.queryController,
    required this.screenWidth,
    required this.screenHeight,
    required this.hintText,
    required this.onTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1,
                    offset: Offset(0, 0.3),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                /*
                controller: queryController,*/
                readOnly: true,
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                //textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.8)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.7)),
                  hintText: "$hintText",
                  hintStyle: TextStyle(
                    color: AppColor.GREY_TEXT_COLOR,
                    fontSize: 12,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    size: 20,
                    color: AppColor.PRIMARY_ACCENT,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper method to build the card
}
