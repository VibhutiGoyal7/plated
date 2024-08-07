import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/AppColor.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var imageUrl;
  late double screenWidth;
  late double screenHeight;
  final List<NotificationData> data = [
    NotificationData(
      notificationHeading: "Cheers! You won 100 points",
      notificationContent: "Because you created your account",
      notificationDate: "07-Aug-24"
    ),
  ];
  final List<NotificationData> transactionalData = [
    NotificationData(
      notificationHeading: "P2P account transfer",
      notificationContent: "Account has been debited Rs.1000 credited to abc",
      notificationDate: "07-Aug-24 8:40 am"
    ),
  ];

  void initState() {
    super.initState();
    imageUrl = "";
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
          child: generalNotificationItem(data[index]),
        );
      },
    );
  }

  Widget generalNotificationItem(NotificationData data) {
    return Center(
      child: Container(
        width: screenWidth*0.88,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.PRIMARY,width: 0.22),
          borderRadius: BorderRadius.circular(12)
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl == "" || imageUrl == null
                  ? Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey,
                        child: Container(
                          height: screenHeight*0.19,
                          width: screenWidth*0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                            border: Border.all(width: 0.12, color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                  )
                  : Center(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColor.PRIMARY, width: 0.3),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            imageUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Shimmer.fromColors(
                                baseColor: Colors.white38,
                                highlightColor: Colors.grey,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white38,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                child: Text("${data.notificationHeading}", ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                child: Text("${data.notificationContent}",style: TextStyle(fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("${data.notificationDate}",style: TextStyle(fontSize: 11), ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget transactionalNotificationItem(NotificationData data) {
    return Center(
      child: Container(
        width: screenWidth*0.88,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.PRIMARY,width: 0.2),
            borderRadius: BorderRadius.circular(12)
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text("${data.notificationHeading}",style: TextStyle(fontWeight: FontWeight.bold) ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                child: Text("${data.notificationContent}",style: TextStyle(fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1),
                child: Text("${data.notificationDate}",style: TextStyle(fontSize: 11), ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget transactionalNotification(){
    return ListView.builder(
      itemCount: transactionalData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {

          },
          child: transactionalNotificationItem(transactionalData[index]),
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
  final String? notificationDate;

  NotificationData({this.notificationHeading, this.notificationContent, this.notificationDate});
}

