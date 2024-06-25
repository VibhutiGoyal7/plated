import 'package:flutter/material.dart';
import 'package:payrio/model/response/profileResponse.dart';
import 'package:payrio/utils/Helper.dart';

import '../../../languageSection/Languages.dart';

class AccountDetailScreen extends StatefulWidget {
  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  var password;
  var phoneNumber;
  var userId;

  var isEmailVerified;
  var isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    password = "";
    phoneNumber = "";
    userId = "";
    isEmailVerified = false;
    isPasswordVisible = false;

    _fetchData();
    _fetchPasswordData();
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
          Languages.of(context)!.labelAccountDetails,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildEmailVerification(
                context: context,
                isDarkMode: isDarkMode,
                isEmailVerified: isEmailVerified,
                onTap: () {
                  {
                    Navigator.pushNamed(context, '/VerifyEmail');
                  }
                }),
            _buildDetailBox(
              context: context,
              label: Languages.of(context)!.enterPhoneNumber,
              value: phoneNumber ?? '',
            ),
            _buildPasswordBox(
                context: context,
                isPasswordVisibl: isPasswordVisible,
                password: "",
                //password,
                isDarkMode: isDarkMode),
            _buildChangePassword(context,isDarkMode: isDarkMode),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    isEmailVerified
                        ? Languages.of(context)!.labelEmailVerified
                        : Languages.of(context)!.labelVerifyEmail,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isEmailVerified
                      ? Text(
                          Languages.of(context)!.labelEmailVerifiedContent,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  //color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                value.isEmpty ? "XXXXXXXXXX" : value,
                style: TextStyle(
                  fontSize: 14.0,
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
      ),
    );
  }

  Widget _buildPasswordBox(
      {required BuildContext context,
      required bool isPasswordVisibl,
      required String? password,
      required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${Languages.of(context)!.labelPassword} ',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    isPasswordVisible ? "123456789" ?? '' : '********',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      })
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePassword(BuildContext context, {required bool isDarkMode}) {
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
            padding: const EdgeInsets.only(right: 18, bottom: 10.0),
            child: Text(
              Languages.of(context)!.labelChangePass,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  decorationColor: isDarkMode ? Colors.white : Colors.black
                  //color: isDarkMode ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        phoneNumber = profileDetails?.phoneNumber;
        userId = profileDetails?.username;
        isEmailVerified = profileDetails?.isEmailVerified;
      });
    });
    return profileDetails;
  }

  Future<void> _fetchPasswordData() async {
    await Future.delayed(Duration(milliseconds: 2));
    password = await Helper.getPassword();
  }
}
