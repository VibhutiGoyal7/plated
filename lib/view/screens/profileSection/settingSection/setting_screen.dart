import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/component/detail_box.dart';
import 'package:Payrio/view/screens/authSection/money_safe_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../languageSection/Languages.dart';
import '../../../component/connectivity_service.dart';

class SettingScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  SettingScreen({required this.setLocale});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class Language {
  final String name;
  final String code;

  Language(this.name, this.code);
}

class _SettingScreenState extends State<SettingScreen> {
  //AccountDetailScreen({required this.navController});
  var password;
  var phoneNumber;
  var userId;
  bool isLoading = false;
  bool isApiLoading = false;
  var isEmailVerified;
  var mLanguages = [
    Language("English", "en"),
    Language("Arabic", "ar"),
    Language("Hindi", "hi")
  ];
  String dropdownValue = "";
  bool isBiometricEnable = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    password = "";
    phoneNumber = "";
    userId = "";
    isEmailVerified = false;
    dropdownValue = mLanguages.first.code;
    Helper.getBiometric().then((retrievedBiometric) {
      setState(() {
        isBiometricEnable = retrievedBiometric ?? false; // Handle null case
        isLoading = false; // Update loading state
      });
    });
    isLoading = true;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordVisible = false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        print("SettingScreen $didPop");
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/ProfileScreen",
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/ProfileScreen",
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/ProfileScreen");
            },
          ),
          title: Text(
            Languages.of(context)!.labelSettings,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
         /* actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => {_showLogOutDialog()},
                  child: Icon(
                    Icons.logout,
                    size: 28,
                    color: AppColor.PRIMARY,
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            )
          ],*/
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Languages.of(context)!.labelLanguage,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${dropdownValue}",
                              style: TextStyle(
                                  fontSize: 11.0, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        /*GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed("/LanguageSelectionScreen");
                          },
                          child: Container(
                            child: Text("Edit", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14
                            ),)
                            ,
                          ),
                        ),*/
                      ]),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenWidth * 7,
                    height: 0.5,
                    margin: EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLabelText(
                            context, Languages.of(context)!.labelSecurity),
                        SizedBox(width: 10,),
                      ],
                    )),
               /* DetailBox(
                  heading: Languages.of(context)!.labelStepVerification,
                  subHeading: "Secure your account",
                  icon: Icons.verified_user,
                  headingTextSize: 14,
                  subHeadingTextSize: 13,
                ),*/
                _buildBiometricCard(context, "Enable App Lock", isDarkMode),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenWidth * 7,
                    height: 0.5,
                    margin: EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLabelText(context, "Privacy"),
                        SizedBox(width: 10,),

                      ],
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ChangePasswordScreen');
                  },
                  child: DetailBox(
                    heading: "Change Password",
                    subHeading: "Update Current Password",
                    icon: Icons.password,
                    headingTextSize: 14,
                    subHeadingTextSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, '/ChangeTPinScreen');
                  },
                  child: DetailBox(
                    heading: "Change Transaction Pin(TPIN)",
                    subHeading: "Update Transaction Pin",
                    icon: Icons.pin,
                    headingTextSize: 14,
                    subHeadingTextSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    var selectedLanguage = await Helper.getLocale();
    print(selectedLanguage.languageCode);

    // Ensure that setState is called synchronously after the async work is done
    if (mounted) {
      setState(() {
        dropdownValue = selectedLanguage.languageCode;
        mLanguages.map((Language items) {
          if (dropdownValue == items.code) {
            dropdownValue = items.name;
          }
        }).toList();
      });
    }
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: Border.all(),
          title: Text("Logout"),
          content: SingleChildScrollView(
              child: Text("Are you sure you want to logout?")),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Helper.clearAllSharedPreferences();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MoneySafeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
      textAlign: TextAlign.left,
    );
  }

  _buildCard(BuildContext context, String text, bool isDarkMode, Icon icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(
                width: 8,
              ),
              Text(text,
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
            ],
          ),
          /*Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          )*/
        ],
      ),
    );
  }

  _buildBiometricCard(BuildContext context, String text, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(text,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w600)),
                ],
              ),
              Transform.scale(
                scale: 0.6,
                child: Switch.adaptive(
                    applyCupertinoTheme: false,
                    value: isBiometricEnable,
                    activeColor: AppColor.WHITE,
                    activeTrackColor: AppColor.PRIMARY,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.red,
                    trackOutlineColor: WidgetStateColor.transparent,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch
                      setState(() {
                        isBiometricEnable = value;
                        enableDisableBioMetric(value);
                      });
                    }),
              ),
            ],
          ),
         /* Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 5.0),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/ManageAppLockScreen");
              },
              child: Text("Manage App Lock",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: AppColor.PRIMARY,
                      fontWeight: FontWeight.w500)),
            ),
          ),*/
        ],
      ),
    );
  }

  Future<void> enableDisableBioMetric(bool value) async {
    bool isSaved = await Helper.saveBiometric(value);
    // Check if the token was saved successfully
    if (isSaved) {
      print('Biometric Saved successfully.$value');
    } else {
      print('Failed to save biometric.');
    }
  }
}
