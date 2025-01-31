import 'package:BDOne/model/response/productsListReponse.dart';
import 'package:flutter/material.dart';

import '../../../../theme/AppColor.dart';
import '../../../../utils/Util.dart';
import '../../../component/image_view_components.dart';

class ProductComponent extends StatefulWidget {
  late final ProductDetails? subCategory;
  late final String placeholderImage;
  late final double width;
  late final double height;
  late final BorderRadius borderRadius;
  late final bool isDarkMode;

  ProductComponent({
    required this.subCategory,
    required this.placeholderImage,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.isDarkMode,
  });

  @override
  _ProductComponentState createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  late var screenWidth;
  late var screenHeight;
  late bool isDarkMode;
  ProductDetails? subCategory;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = widget.width;
    screenHeight = widget.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    subCategory = widget.subCategory;
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: widget.borderRadius,
        border: Border.all(width: 0.1, color: Colors.black54),
      ),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: ImageViewComponent(
              height: 85,
              width: 120,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              imageUrl: subCategory?.itemImage,
              isDarkMode: false,
              placeholderImage: "assets/milk_image.png",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "৳${widget.subCategory?.price}",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.TEXT_RED,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColor.PRIMARY_ACCENT,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(" ৳${widget.subCategory?.price}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black54,
                        )),
                    SizedBox(width: 5),
                    Text(
                      "10% Off",
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColor.PRIMARY_ACCENT,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text(
                  "${capitalizeFirstLetter("${subCategory?.name}")}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 0.8,
                              color: AppColor.PRIMARY_ACCENT,
                              style: BorderStyle.solid))),
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    "${capitalizeFirstLetter("${subCategory?.description}")}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? AppColor.WHITE : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
