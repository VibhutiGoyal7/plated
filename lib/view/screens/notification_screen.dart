import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationScreen(),
    );
  }
}
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationData> data = [
    NotificationData(
      notificationHeading: "Cheers! You won 100 AstroPoints",
      notificationContent: "Because you created your account in AstroPay",
    ),
  ];

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
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {

            },
            child: NotificationItem(data: data[index]),
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationData data;

  NotificationItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/NotificationDetailScreen");
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.notificationHeading != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data.notificationHeading!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 5),
                if (data.notificationContent != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data.notificationContent!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
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

