import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Detail Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationDetailScreen(),
    );
  }
}

class NotificationDetailScreen extends StatefulWidget {
  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final NotificationData data = NotificationData(
    notificationHeading: "Cheers! You won 100 AstroPoints",
    notificationContent: "Because you created your account in AstroPay",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notification'),
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Popins',
                                        ),
                          ),
                        ),
                      if (data.notificationContent != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.notificationContent!,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Popins',
                                        ),
                          ),
                        ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    ),
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
