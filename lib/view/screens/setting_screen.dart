import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/utils/Helper.dart';

import '../../Strings/Languages.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                  ),
                ),
                Text(
                  Languages.of(context)!.labelSettings,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(children: [
                Text(
                  Languages.of(context)!.labelLanguage,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      alignment: Alignment.centerLeft,
                      value: dropdownValue,
                      items: mCities.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          alignment: Alignment.centerLeft,
                          child: Text(items,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        await Helper.setLocale(newValue!);
                        if (mounted) {
                          setState(()  {
                            dropdownValue = newValue!;
                          });
                        }
                        widget.setLocale(Locale(newValue, ''));
                        print(dropdownValue);
                      },
                      style: TextStyle(),
                      hint: Text(
                        "en",
                      ),
                    ),
                  ),
                )
              ]),
            ),
            _buildEmailVerification(
                context: context,
                isDarkMode: isDarkMode,
                isEmailVerified: isEmailVerified,
                onTap: () {
                  //navController.navigate(Screen.VerifyEmailScreen.route);
                }),
            _buildDetailBox(
              context: context,
              label: Languages.of(context)!.enterPhoneNumber,
              value: phoneNumber ?? '',
            ),
            _buildPasswordBox(
                context: context,
                isPasswordVisible: isPasswordVisible,
                password: "",
                //password,
                onVisibilityToggle: () {
                  isPasswordVisible = !isPasswordVisible;
                },
                isDarkMode: isDarkMode),
            _buildChangePassword(context),
            _buildDetailBox(
              context: context,
              label: Languages.of(context)!.labelUserId,
              value: userId.toString() ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailVerification({
    required BuildContext context,
    required bool isEmailVerified,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  child: Text(
                    isEmailVerified
                        ? 'Email Verified'
                        : Languages.of(context)!.labelVerifyEmail,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isEmailVerified
                      ? Text(
                          'Your Email has been successfully verified via OTP which was sent on your email address',
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                Languages.of(context)!.labelVerifyEmailContent,
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                //color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value.isEmpty ? "XXXXXXXXXX" : value,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                /* color: value.isEmpty
                    ? Colors.grey
                    : isDarkMode ? Colors.white : Colors.black,
  */
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordBox(
      {required BuildContext context,
      required bool isPasswordVisible,
      required String? password,
      required VoidCallback onVisibilityToggle,
      required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${Languages.of(context)!.labelPassword}: ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              isPasswordVisible ? password ?? '' : '********',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePassword(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () {
            {
              Navigator.pushNamed(context, '/ChangePasswordScreen');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              Languages.of(context)!.labelChangePass,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                //color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
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
}
