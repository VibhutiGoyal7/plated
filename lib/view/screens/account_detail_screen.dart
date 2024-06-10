import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/profileResponse.dart';
import 'package:mvvm_flutter_app/utils/Helper.dart';

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
    isEmailVerified = "";

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // final mainViewModel = context.watch<DashBoardViewModel>();
    bool isPasswordVisible = false;
    //final password = mainViewModel.getUpdateUserRequest()?.customer?.password;

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
                  'Account Details',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            _buildEmailVerification(
              context: context,
              isEmailVerified: isEmailVerified,
              onTap: () {
                //navController.navigate(Screen.VerifyEmailScreen.route);
              },
            ),
            _buildDetailBox(
              context: context,
              label: 'Phone Number:',
              value: phoneNumber ?? '',
            ),
            _buildPasswordBox(
              context: context,
              isPasswordVisible: isPasswordVisible,
              password: "", //password,
              onVisibilityToggle: () {
                isPasswordVisible = !isPasswordVisible;
              },
            ),
            _buildChangePassword(context),
            _buildDetailBox(
              context: context,
              label: 'User Id:',
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  isEmailVerified ? 'Email Verified' : 'Verify your Email',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Click the following link to verify your email address and associate it with your Payario Account',
                              style: TextStyle(
                                fontSize: 13.0,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                color: Theme.of(context).colorScheme.onBackground,
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
                color: value.isEmpty
                    ? Colors.grey
                    : Theme.of(context).colorScheme.onBackground,
              ),
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
              'Password: ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              isPasswordVisible ? password ?? '' : '********',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
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
              'Change Password',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<ProfileResponse?> _fetchData() async {
  await Future.delayed(Duration(milliseconds: 2));
  ProfileResponse? profileDetails = await Helper.getProfileDetails();
/*  WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      phoneNumber = profileDetails?.phoneNumber;
      userId = profileDetails?.userId;
      isEmailVerified = profileDetails?.isEmailVerified;
    });
  });*/
  return profileDetails;
}

class NavController {
  void navigateUp() {
    // Implement navigation logic
  }

  void navigate(String route) {
    // Implement navigation logic
  }
}

class DashBoardViewModel extends ChangeNotifier {
  CustomerDetailsResponse? getCustomerDetailsSharedPreference() {
    // Implement logic to retrieve customer details
    return null;
  }

  UpdateUserRequest? getUpdateUserRequest() {
    // Implement logic to retrieve user update request
    return null;
  }
}

class CustomerDetailsResponse {
  bool? isEmailVerified;
  String? phoneNumber;
  int? userId;

  CustomerDetailsResponse(
      {this.isEmailVerified, this.phoneNumber, this.userId});
}

class UpdateUserRequest {
  Customer? customer;

  UpdateUserRequest({this.customer});
}

class Customer {
  String? password;

  Customer({this.password});
}

class Screen {
  static const ProfileScreen = Screen._('ProfileScreen');
  static const AddressScreen = Screen._('AddressScreen');
  static const VerifyEmailScreen = Screen._('VerifyEmailScreen');
  static const ChangePasswordScreen = Screen._('ChangePasswordScreen');

  final String route;

  const Screen._(this.route);
}
