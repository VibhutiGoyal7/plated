import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatefulWidget {
  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final NotificationData data = NotificationData(
    notificationHeading: "Cheers! You won 100 Payorio points",
    notificationContent: "Because you created new account in Payorio",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(Languages.of(context)!.labelNotification),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.notificationHeading != null)
                        Text(
                          data.notificationHeading!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      SizedBox(height: 10,),
                       (data.notificationContent != null)?
                        Container(
                          //height: MediaQuery.of(context).size.height *0.2,
                          width: MediaQuery.of(context).size.width *0.9,
                          child: Expanded(
                            child: Text(
                              data.notificationContent!,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.visible,maxLines: null,
                            ),
                          ),
                        ): SizedBox(),
                    ],
                  ),
                  //Spacer(),
                  /*Icon(
                    Icons.arrow_forward,
                    ),*/
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationData {
  final String? notificationHeading;
  final String? notificationContent;

  NotificationData({this.notificationHeading, this.notificationContent});
}
