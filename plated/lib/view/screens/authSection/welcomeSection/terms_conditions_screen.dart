import 'package:Plated/languageSection/Languages.dart';
import 'package:Plated/theme/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_button_component.dart';
import '../../../component/custom_circular_progress.dart';

class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  bool isDarkMode = false;
  bool isChecked = false;
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Terms and Conditions",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
              ),
            ),
            middle: Text(
              "Terms and Conditions",
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
              (BuildContext context, int index) {
                // Example Terms and Conditions items
                final terms = [
                  'Introduction',
                  'Acceptance of Terms',
                  'Changes to Terms',
                  'User Responsibilities',
                  'Limitation of Liability',
                  'Termination',
                  'Governing Law',
                  'Contact Information'
                ];
                final termsSubHeading = [
                  'Introduction',
                  'Acceptance of Terms',
                  'Changes to Terms',
                  'User Responsibilities',
                  'Limitation of Liability',
                  'Termination',
                  'Governing Law',
                  'Contact Information'
                ];
                return ListTile(
                  title: Text(
                    terms[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Detailed explanation about ${terms[index].toLowerCase()} will be listed here.',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                );
              },
              childCount: 8, // Number of terms
            ),
          ),
          // SliverToBoxAdapter for the custom button at the bottom
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                ),
                Switch(
                  value: _isToggled,
                  activeColor: AppColor.PRIMARY,
                  inactiveTrackColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      _isToggled = value;
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${Languages.of(context)?.labelReadAllTermsConditions}",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButtonComponent(
                  isClickable: _isToggled == true ? true : false,
                  text: "Accept",
                  width: screenWidth,
                  isDarkMode: isDarkMode,
                  buttonColor: AppColor.PRIMARY,
                  textColor: Colors.white,
                  verticalPadding: 10,
                  onTap: () {
                    Navigator.pushNamed(context, "/ProceedAsScreen");
                  },
                ),
              ),
            ),
          ),

          // Spacer at the bottom for better UX
          SliverToBoxAdapter(
            child: const SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
