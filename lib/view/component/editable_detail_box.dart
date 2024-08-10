import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableDetailBox extends StatelessWidget  {

  late final String heading;
  late final String subHeading;
  late final double subHeadingTextSize;
  late final double headingTextSize;
  late final IconData icon;
  late final TextEditingController controller;
  late final Function isInputValid;

  EditableDetailBox({required this.heading,required this.subHeading,required this.icon,required this.headingTextSize,required this.subHeadingTextSize});


  Widget build(BuildContext context)
       {
      return Padding(
        padding: const EdgeInsets.symmetric( vertical: 2.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
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
                      fontWeight: FontWeight.w600,
                      //color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    child:
                    TextField(
                      style: TextStyle(fontSize: 15.0),
                      controller: controller,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        isInputValid();
                      },
                      onSubmitted: (value) {},
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: heading,
                        hintStyle: TextStyle(color: Colors.grey),

                      ),
                    )
                    /*Text(
                      subHeading.isEmpty ? "" : "${subHeading}",
                      style: TextStyle(
                        fontSize:subHeadingTextSize,
                        fontWeight: FontWeight.normal,
                        *//* color: value.isEmpty
                          ? Colors.grey
                          : isDarkMode ? Colors.white : Colors.black,
                                *//*
                      ),
                    ),*/
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}