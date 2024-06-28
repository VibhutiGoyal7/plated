import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Helper.dart';

import '../../../languageSection/Languages.dart';

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

  var isEmailVerified;
  var mCities = ["en", "ar", "hi"];
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    password = "";
    phoneNumber = "";
    userId = "";
    isEmailVerified = false;
    dropdownValue = mCities.first;
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
        child: Column(
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
          ],
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
                Navigator.pushNamed(context, '/SignInScreen',
                    arguments: "");
              },
            ),
          ],
        );
      },
    );
  }
}
