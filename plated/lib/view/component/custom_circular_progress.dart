import 'package:flutter/material.dart';

import '../../theme/AppColor.dart';


class CustomCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Block interaction
        ModalBarrier(
            dismissible: false, color: Colors.transparent),
        // Loader indicator
        Center(
          child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_ACCENT,),
        ),
      ],
    );
  }

}
