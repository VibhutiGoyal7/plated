import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatefulWidget {
  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final NotificationData data = NotificationData(
    notificationHeading: "Cheers! You won 100 Payario points",
    notificationContent: "Because you created your account in Payario",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.notificationHeading != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.notificationHeading!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (data.notificationContent != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.notificationContent!,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
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
