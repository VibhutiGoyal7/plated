import 'package:BDOne/model/response/ServiceTypeResponse.dart';
import 'package:BDOne/model/response/countryListResponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/material.dart';

import '../../../utils/Util.dart';
import '../image_view_components.dart';

class RestaurantDashboardComponent extends StatefulWidget {
  final List<CategoryData?> categories;
  final double screenWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;
  final String heading;

  const RestaurantDashboardComponent({
    Key? key,
    required this.categories,
    required this.screenWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
    required this.heading,
  }) : super(key: key);

  @override
  _RestaurantDashboardComponentState createState() =>
      _RestaurantDashboardComponentState();
}

class _RestaurantDashboardComponentState
    extends State<RestaurantDashboardComponent> {
  bool _isExpanded = false;
  bool isDarkMode = false;
  late double screenWidth;
  late double screenHeight;
  int initialItemCount = 5;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 14),
              child: Text(
                "${widget.heading}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 14),
              child: Text(
                "See all",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColor.PRIMARY_ACCENT),
              ),
            ),
          ],
        ),
        AnimatedContainer(
            width: screenWidth,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
            ),
            // Expandable height control
            child: GridView.builder(
              shrinkWrap: true,
              // Fit grid inside list
              physics: NeverScrollableScrollPhysics(),
              // Disable grid scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 0,
                childAspectRatio: 0.9,
              ),
              padding: EdgeInsets.all(4),
              itemCount: widget.categories.length,
              itemBuilder: (context, subIndex) {
                if (subIndex < widget.categories.length) {
                  var subCategory = widget.categories[subIndex];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pushNamed(
                            "/RestaurantProductsScreen", arguments: subCategory);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageViewComponent(
                            height: 50,
                            width: 50,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            imageUrl: subCategory?.categoryImage,
                            isDarkMode: false,
                            placeholderImage: "assets/category_image.png",
                          ),
                          Text(
                            "${capitalizeFirstLetter("${subCategory?.categoryName}")}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(); // Prevents index errors
                }
              },
            ))
      ],
    );
  }
}
