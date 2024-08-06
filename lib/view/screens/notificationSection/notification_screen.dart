import 'package:flutter/material.dart';
import 'package:Payrio/languageSection/Languages.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationData> data = [
    NotificationData(
      notificationHeading: "Cheers! You won 100",
      notificationContent: "Because you created your account",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(Languages.of(context)!.labelNotification),
        ),
        body:
        Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "General"),
                Tab(text: "Transactional"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [generalNotification(), transactionalNotification()],
              ),
            ),
          ],
        )


      ),
    );
  }
  Widget generalNotification(){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {

          },
          child: NotificationItem(data: data[index]),
        );
      },
    );
  }

  Widget transactionalNotification(){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {

          },
          child: NotificationItem(data: data[index]),
        );
      },
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: 5),
                if (data.notificationContent != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data.notificationContent!,
                      style: TextStyle(fontSize: 14),
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

