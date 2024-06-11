import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/response/profileResponse.dart';
import 'package:mvvm_flutter_app/utils/Helper.dart';

import '../../Strings/Languages.dart';

class AccountDetailScreen extends StatefulWidget {
  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  //AccountDetailScreen({required this.navController});
  var password;
  var phoneNumber;
  var userId;

  var isEmailVerified;

  @override
  void initState() {
    super.initState();
    password = "";
    phoneNumber = "";
    userId = "";
    isEmailVerified = false;

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
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                Text(
                  Languages.of(context)!.labelAccountDetails,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            _buildEmailVerification(
              context: context,
            isDarkMode: isDarkMode,
              isEmailVerified: isEmailVerified,
              onTap: () {
                {
                  Navigator.pushNamed(context, '/VerifyEmail');
                }              }
            ),
            _buildDetailBox(
              context: context,
              label: Languages.of(context)!.enterPhoneNumber,
              value: phoneNumber ?? '',
            ),
            _buildPasswordBox(
              context: context,
              isPasswordVisible: isPasswordVisible,
              password: "", //password,
              onVisibilityToggle: () {
                isPasswordVisible = !isPasswordVisible;
              }, isDarkMode: isDarkMode
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    isEmailVerified ? 'Email Verified' : Languages.of(context)!.labelVerifyEmail,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
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
                            color: isDarkMode ? Colors.white : Colors.black,
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
                              color: Colors.black,
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
  */            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordBox({
    required BuildContext context,
    required bool isPasswordVisible,
    required String? password,
    required VoidCallback onVisibilityToggle,
    required bool isDarkMode
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
                color: Colors.black,
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
              Languages.of(context)!.labelChangePass  ,
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
  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        phoneNumber = profileDetails?.phoneNumber;
        userId = profileDetails?.userId;
        isEmailVerified = profileDetails?.isEmailVerified;
      });
    });
    return profileDetails;
  }
}

