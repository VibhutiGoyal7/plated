import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../languageSection/Languages.dart';
import '../../theme/AppColor.dart';

class TextfieldComponent extends StatelessWidget {
  late final double width;
  late final bool isPhone;
  late final String text;
  late final Icon icon;
  late final TextEditingController textController;
  late final List<TextInputFormatter> inputFormatters;
  final Function() onChanged;

  TextfieldComponent(
      {required this.width,
      required this.isPhone,
      required this.text,
      required this.icon,
      required this.inputFormatters,
      required this.textController,
      required this.onChanged});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Container(
        //height: 60,
        width: screenWidth * width,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Expanded(
          flex: 1,
          child: TextField(
            style: TextStyle(
              fontSize: 14.0,
            ),
            obscureText: false,
            obscuringCharacter: "*",
            controller: textController,
            onChanged: (value) {
              //_isValidInput();
            },
            maxLength: isPhone ? 10: 100   ,
            textAlignVertical: TextAlignVertical.top,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            onSubmitted: (value) {},
            keyboardType:isPhone ? TextInputType.phone : TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: text,
              alignLabelWithHint: true,
              counterText: "",
            ),
          ),
        ),
      ),
    );
  }
}
