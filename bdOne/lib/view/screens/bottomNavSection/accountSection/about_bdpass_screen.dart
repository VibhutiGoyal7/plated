import 'package:BDOne/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';
import '../../../component/custom_circular_progress.dart';

class AboutBDOneScreen extends StatefulWidget {
  @override
  _AboutBDOneScreenState createState() => _AboutBDOneScreenState();
}

class _AboutBDOneScreenState extends State<AboutBDOneScreen> {
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
    screenHeight = MediaQuery.of(context).size.height;
    // Sample list

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "About BD One",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(isDarkMode
                              ? "assets/app_logo_dark.png"
                              : "assets/app_logo.png"),
                          height: 70,
                          fit: BoxFit.fitHeight,
                        ),
                        Text(
                          "5.9.0 N6",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Text(
                        "BD One is the first national digital identity, for all citizens, residents, and visitors of BD.",
                        overflow: TextOverflow.visible),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Text(
                        "Allowing you to access services across different sectors in the UAE, digitally sign & verify documents, request for a digital copy of your issued documents, as well as avail services through sharing the digital documents",
                        overflow: TextOverflow.visible),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Text(
                      "BD One is a national joint initiative with Digital Dubai, Telecommunications and Digital Government Regulatory Authority and Department of Government Enablement, with the aim to provide a single trusted digital identity solution for service providers and customers in the UAE, while maintaining a seamless user experience and facilitating paperless government with a high level of security assurance.",
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
