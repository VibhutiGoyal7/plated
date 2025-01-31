import 'package:BDOne/model/response/driverStatusResponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/view/component/text_component.dart';
import 'package:flutter/material.dart';

import '../../../utils/Util.dart';
import 'location_stop_widget.dart';

class AcceptedRequestWidget extends StatefulWidget {
  late final String requestStatus;

  late final DriverStatusResponse data;
  late final bool isRideStarted;
  late final bool isDriverReached;
  final Function() onCancelTap;
  final Function() onPhoneTap;

  AcceptedRequestWidget({
    required this.data,
    required this.isRideStarted,
    required this.isDriverReached,
    required this.onCancelTap,
    required this.requestStatus,
    required this.onPhoneTap,
  });

  @override
  _AcceptedRequestWidgetState createState() => _AcceptedRequestWidgetState();
}

class _AcceptedRequestWidgetState extends State<AcceptedRequestWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.isRideStarted || widget.isDriverReached
              ? Container(
                  width: screenWidth * 0.95,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: widget.isRideStarted
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    widget.isDriverReached
                        ? "Driver has reached at your pickup location"
                        : "The Ride has started!",
                    style: TextStyle(
                      fontSize: 15,
                        color:
                            widget.isRideStarted ? Colors.green : Colors.red),
                  )),
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onPhoneTap,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5.0, bottom: 3),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey[100]),
                                    padding: EdgeInsets.all(18),
                                    child: Icon(
                                      Icons.person,
                                      size: 38,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(
                                text: capitalizeFirstLetter(
                                    "${widget.data.firstName} "),
                                fontSize: 15,
                                isBold: true),
                            TextComponent(
                                text: capitalizeFirstLetter(
                                    "${widget.data.lastName}"),
                                fontSize: 15,
                                isBold: true),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextComponent(
                          text: "৳${widget.data.estimatedFare}",
                          fontSize: 22,
                          isBold: true),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      LocationStopWidget(
                        location: capitalizeFirstLetter(
                            widget.data.pickup_address ?? ""),
                        isPickUp: true,
                      ),
                      LocationStopWidget(
                        location: capitalizeFirstLetter(
                            widget.data.destination_address ?? ""),
                        isPickUp: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  height: 0.7,
                  width: screenWidth * 0.9,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: widget.onCancelTap,
                      child: Container(
                        width: screenWidth * 0.56,
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.5, vertical: 12),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.TEXT_RED, width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkMode ? Colors.white : Colors.white),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColor.TEXT_RED),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onPhoneTap,
                      child: Container(
                          width: screenWidth * 0.28,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.5, vertical: 9),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blue.shade700, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue.shade700),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
