import 'package:flutter/material.dart';

import '../../languageSection/Languages.dart';

class InstructionStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final Color iconColor;

  InstructionStep({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title == "${Languages.of(context)?.labelStep} 1"
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.height * 0.016,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
          CircleAvatar(
            backgroundColor: isActive ? iconColor : Colors.grey,
            child: Icon(icon, color: isActive ? Colors.white : Colors.white, size: 24,),
          ),
          title == "${Languages.of(context)?.labelStep} 3"
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.height * 0.047,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
        ],
      ),
    );
  }
}
