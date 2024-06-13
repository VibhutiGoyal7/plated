
import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/response/profileResponse.dart';
import 'package:provider/provider.dart';

import '../../Strings/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../utils/Helper.dart';
import '../../view_model/media_view_model.dart';
import 'package:mvvm_flutter_app/theme/AppColor.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userName;

  @override
  void initState() {
    super.initState();
    userName = "";
    _fetchData();
    print(Helper.getUserToken());
  }

  Future<Widget> getMediaWidget(BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.firstName}");

        await Helper.saveProfileDetails(mediaList);

        ProfileResponse? retrievedDetails = await Helper.getProfileDetails();
        print('Retrieved Token: ${retrievedDetails}');
        // Defer the state update until the next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            userName = "${retrievedDetails?.firstName} ${retrievedDetails?.lastName}";
          });

    });



        // Navigate to the new screen after receiving the response
        //Navigator.pushNamed(context, '/BottomNav');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelProfile,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.WHITE,
                    backgroundImage: AssetImage("assets/profile_user.png"),
                  ),
                  _buildLabelText(context, userName.toString()),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.0),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, Languages.of(context)!.labelProfile)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/AccountDetailScreen',
                                arguments: "");
                          },
                          child: _buildCard(context, Languages.of(context)!.labelAccountDetails, isDarkMode),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/PersonalInfoScreen',
                                arguments: "");
                          },
                          child: _buildCard(context, Languages.of(context)!.labelPersonalInfo, isDarkMode),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, Languages.of(context)!.labelSecurity)),
                        _buildCard(context, Languages.of(context)!.labelStepVerification, isDarkMode),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, Languages.of(context)!.labelPaymentMethod)),
                        _buildCard(context, Languages.of(context)!.labelAddedCard, isDarkMode),

                        Container(
                            padding: EdgeInsets.all(6.0),
                            child: _buildLabelText(context, Languages.of(context)!.labelHelpSupport)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/SettingScreen',
                                arguments: "");
                          },
                          child: _buildCard(context, Languages.of(context)!.labelSettings, isDarkMode),
                        ),

                      ]),
                ],
              ),
            )),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      textAlign: TextAlign.left,
    );
  }

  _buildCard(BuildContext context, String text, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 14.0)),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    String? retrievedToken = await Helper.getUserToken();
    print("Token $retrievedToken");
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .profileScreenData("/api/v1/app/customers/show_customer_details");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }
}
