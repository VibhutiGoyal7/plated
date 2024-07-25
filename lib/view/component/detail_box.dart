import 'package:flutter/cupertino.dart';

class DetailBox extends StatelessWidget  {

  late final String heading;
  late final String subHeading;
  late final double subHeadingTextSize;
  late final double headingTextSize;
  late final IconData icon;


  //NewsOfferListWidget(ScrollController scrollController);

  DetailBox({required this.heading,required this.subHeading,required this.icon,required this.headingTextSize,required this.subHeadingTextSize});


  Widget build(BuildContext context)
       {
      return Padding(
        padding: const EdgeInsets.symmetric( vertical: 2.0),
        child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: headingTextSize,
                      fontWeight: FontWeight.bold,
                      //color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    child: Text(
                      subHeading.isEmpty ? "" : "${subHeading}",
                      style: TextStyle(
                        fontSize:subHeadingTextSize,
                        fontWeight: FontWeight.normal,
                        /* color: value.isEmpty
                          ? Colors.grey
                          : isDarkMode ? Colors.white : Colors.black,
                                */
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}