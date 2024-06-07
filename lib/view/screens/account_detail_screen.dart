import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AccountDetailScreen extends StatelessWidget {

  //AccountDetailScreen({required this.navController});

  @override
  Widget build(BuildContext context) {
   // final mainViewModel = context.watch<DashBoardViewModel>();
   // final customerDetailsResponse = mainViewModel.getCustomerDetailsSharedPreference();
    bool isPasswordVisible = false;
    //final password = mainViewModel.getUpdateUserRequest()?.customer?.password;
    bool isEmailVerified =false; //customerDetailsResponse?.isEmailVerified ?? false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      //navController.navigateUp();
                    },
                    child:Icon(Icons.arrow_back_ios, color: Colors.black,),
                  ),
                ),
                Text(
                  'Account Details',
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 18.0, fontWeight: FontWeight.bold),
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
              value: ""//customerDetailsResponse?.phoneNumber ?? '',
            ),
            _buildPasswordBox(
              context: context,
              isPasswordVisible: isPasswordVisible,
              password: "",//password,
              onVisibilityToggle: () {
                isPasswordVisible = !isPasswordVisible;
              },
            ),
            _buildChangePassword(context),
            _buildDetailBox(
              context: context,
              label: 'User Id:',
              value: ""//customerDetailsResponse?.userId.toString() ?? '',
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
            color: Theme.of(context).colorScheme.primaryContainer,
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
                    fontSize: 14.0,
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
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                )
                    : Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Click the following link to verify your email address and associate it with your Payario Account',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
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
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
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
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              'Password: ',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              isPasswordVisible ? password ?? '' : '********',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
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
            //navController.navigate(Screen.ChangePasswordScreen.route);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Change Password',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
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

  CustomerDetailsResponse({this.isEmailVerified, this.phoneNumber, this.userId});
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
