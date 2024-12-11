import 'package:flutter/material.dart';

class DetailBox extends StatelessWidget {
  late final String heading;
  late final double headingTextSize;
  late final IconData icon;

  DetailBox(
      {required this.heading,
      required this.icon,
      required this.headingTextSize});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: Colors.brown,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                heading,
                style: TextStyle(
                  fontSize: headingTextSize,
                  //fontWeight: FontWeight.w600,
                  //color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color:isDarkMode? Colors.white : Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
