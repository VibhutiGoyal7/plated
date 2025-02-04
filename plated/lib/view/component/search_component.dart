import 'package:flutter/material.dart';

import '../../languageSection/Languages.dart';
import '../../theme/AppColor.dart';

class SearchComponent extends StatelessWidget {
  late final double width;
  late final bool isDarkMode;
  late final double screenWidth;
  late final TextEditingController searchController;
  final Function() onChanged;

  SearchComponent(
      {required this.width,
      required this.screenWidth,
      required this.isDarkMode,
      required this.searchController,
      required this.onChanged});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 43,
      width: screenWidth*width,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey[100],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: TextStyle(
          fontSize: 14.0,
        ),
        obscureText: false,
        obscuringCharacter: "*",
        controller: searchController,
        onChanged: (value) {
          onChanged();
        },
        onSubmitted: (value) {},
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: Languages.of(context)?.labelSearch,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
