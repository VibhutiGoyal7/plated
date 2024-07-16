import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/screens/authSection/money_safe_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';

class SettingScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  SettingScreen({required this.setLocale});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //AccountDetailScreen({required this.navController});
  var password;
  var phoneNumber;
  var userId;
  bool isLoading = true;

  var isEmailVerified;
  var mCities = ["en", "ar", "hi"];
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
    dropdownValue = mCities.first;
    Helper.getBiometric().then((retrievedBiometric) {
      setState(() {
        isBiometricEnable = retrievedBiometric ?? false; // Handle null case
        isLoading = false; // Update loading state
      });
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordVisible = false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelSettings,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () => {_showLogOutDialog()},
                child: Icon(
                  Icons.logout,
                  size: 34,
                  color: AppColor.WHITE,
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14),
            child: Row(children: [
              Text(
                Languages.of(context)!.labelLanguage,
                style:
                TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
              Spacer(),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isDarkMode ? Colors.white60 : Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: isDarkMode ? Colors.grey : Colors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10),
                    value: dropdownValue,
                    items: mCities.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        alignment: Alignment.centerLeft,
                        child: Text(items,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      await Helper.setLocale(newValue!);
                      if (mounted) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      }
                      widget.setLocale(Locale(newValue, ''));
                      print(dropdownValue);
                    },
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                    hint: Text(
                      "en",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(6.0),
              child: _buildLabelText(context,
                  Languages.of(context)!.labelSecurity)),
          _buildCard(
              context,
              Languages.of(context)!.labelStepVerification,
              isDarkMode),
          _buildBiometricCard(context,
              "Bio-metric Authentication", isDarkMode),
          Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(6.0),
              child: _buildLabelText(context,
                  "Privacy")),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/ChangePasswordScreen');
            },
            child: _buildCard(
                context,
                "Change Password",
                isDarkMode),
          )
          ,
          GestureDetector(
              onTap: () async {

                  Navigator.pushNamed(context, '/ChangeTPinScreen');
                },
                child: _buildCard(
                context,
                "Change Transaction Pin(TPIN)",
                isDarkMode),
                )
                ,
                ],
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

        _buildLabelText(BuildContext context, String text)
    {
      return Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
    _buildBiometricCard(BuildContext context, String text, bool isDarkMode) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: 14.0)),
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
                      // This is called when the user toggles the switch.
                      setState(() {
                        isBiometricEnable = value;
                        enableDisableBioMetric(value);
                      });
                    }),
              ),
            ],
          ),
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
