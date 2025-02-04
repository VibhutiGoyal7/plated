import 'package:flutter/material.dart';

class LocationStopWidget extends StatefulWidget {
  late final String location;
  late final bool isPickUp;

  LocationStopWidget({
    required this.location,
    required this.isPickUp,
  });

  @override
  _LocationStopWidgetState createState() => _LocationStopWidgetState();
}

class _LocationStopWidgetState extends State<LocationStopWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            widget.isPickUp
                ? SizedBox(
                    height: screenHeight * 0.0175,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: screenHeight * 0.02,
                        maxHeight: screenHeight * 0.032),
                    child: Container(
                      width: 1.8,
                      color: Colors.grey.shade300,
                    ),
                  ),
            Icon(
              widget.isPickUp ? Icons.location_on_outlined : Icons.my_location,
              size: 15,
            ),
            !widget.isPickUp
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: screenHeight * 0.022,
                        maxHeight: screenHeight * 0.032),
                    child: SizedBox(
                      height: screenHeight * 0.022,
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: screenHeight * 0.016,
                        maxHeight: screenHeight * 0.03),
                    child: Container(
                      width: 1.8,
                      color: Colors.grey.shade300,
                    ),
                  ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          "${widget.location}",
          style: TextStyle(
            fontSize: 13,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
    ;
  }
}
