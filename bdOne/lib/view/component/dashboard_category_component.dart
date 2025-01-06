import 'package:flutter/material.dart';

import '../../utils/Util.dart';
import 'circluar_profile_image.dart';

class DashboardCategoryComponent extends StatelessWidget {
  final List<String?> categories;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;

  const DashboardCategoryComponent({
    Key? key,
    required this.categories,
    required this.screenWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: screenWidth,
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 6,
          alignment: WrapAlignment.start,
          // Horizontal space between items
          runSpacing: 8,
          // Vertical space between lines
          children: categories.map((result) {
              var currentItem = result;
              var currentCategoryName = result;
              var currentCategoryImage = "";
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: GestureDetector(
                  onTap: () {
                   /* VendorData? data = vendorData;
                    data?.detailType = "menu";
                    data?.selectedCategoryId = currentItem?.id;*/
                    // Navigator.pushNamed(context, "/MenuScreen", arguments: data);
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color:
                    //         isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.white),
                     width: 50,
                    padding: EdgeInsets.only(bottom: 8, top: 2, left: 2, right: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircularProfileImage(
                            size: 48,
                            imageUrl: currentCategoryImage,
                            name: "${currentCategoryName}",
                            needTextLetter: true,
                            placeholderImage: ""),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            capitalizeFirstLetter("${currentCategoryName}"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
