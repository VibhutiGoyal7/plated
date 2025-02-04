import 'package:Plated/languageSection/Languages.dart';
import 'package:Plated/theme/AppColor.dart';
import 'package:Plated/utils/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';


class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class ListItem {
  final IconData icon;
  final String title;
  final String subtitle;

  ListItem(this.icon, this.title, this.subtitle);
}

class _SupportScreenState extends State<SupportScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    // Sample list
    final List<ListItem> items = [
      ListItem(Icons.fingerprint, "Identity Information",
          "Personal Information,Profile Photo, mobile number"),
      ListItem(Icons.computer, "Technical Issue",
          "Login, SHare documents, QR Code"),
      ListItem(Icons.message_outlined, "Suggestions", ""),
    ];

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[

        CupertinoSliverNavigationBar(
          largeTitle: Text(
            "Support",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
            ),
          ),
          middle: Text(
            "Support",
            style: TextStyle(fontSize: 22,
                color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
          ),
          backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
            ),
          ),
          alwaysShowMiddle: false,
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                 /* if (index == 0) {
                      Navigator.pushNamed(context, "/VerificationScreen");

                  }else{
                    Navigator.pushNamed(context, "/VisitorNameScreen");
                  }*/
                },
                child: _buildCard(item.icon, item.title, item.subtitle),
              );
              _buildCard(item.icon, item.title, item.subtitle);
            },
            childCount: items.length,
          ),
        ) //SliverList
      ], //<Widget>[]
    )
        );
  }

  Widget _buildCard(IconData icon, String heading, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.brown,
                size: 28,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  if(detail.isNotEmpty)
                  Container(
                      width: screenWidth * 0.66,
                      child: Text(
                        detail,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.visible,
                      )),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
