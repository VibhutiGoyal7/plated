import 'package:flutter/material.dart';

import '../../Strings/Languages.dart';
import '../../model/profileResponse.dart';
import '../../utils/Helper.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  //final NavController navController;
  bool isEmailVerified = false;

  // PersonalInformationScreen({required this.navController});
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    //final mainViewModel = context.watch<DashBoardViewModel>();
    //final customerDetailsResponse = mainViewModel.getCustomerDetailsSharedPreference();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                Text(
                  Languages.of(context)!.labelPersonalInfo,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            _buildMenuItem(
              context: context,
              text: Languages.of(context)!.labelPersonalData,
              onTap: () {
                Navigator.pushNamed(context, '/PersonalDataScreen');
              },
            ),
            _buildMenuItem(
              context: context,
              text: Languages.of(context)!.labelAddress,
              onTap: () {
                Navigator.pushNamed(context, '/AddressScreen');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                Languages.of(context)!.completeProfile,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildEmailVerification(
              context: context,
              //customerDetailsResponse: customerDetailsResponse,
              onTap: () {
                //navController.navigate(Screen.VerifyEmailScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailVerification({
    required BuildContext context,
    //required CustomerDetailsResponse? customerDetailsResponse,
    required VoidCallback onTap,
  }) {
    bool emailVerified = true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: isEmailVerified == true
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Languages.of(context)!.labelEmailVerified,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          Languages.of(context)!.labelEmailVerifiedContent,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Languages.of(context)!.labelVerifyEmail,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                Languages.of(context)!.labelVerifyEmailContent,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded),
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

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isEmailVerified = profileDetails!.isEmailVerified!;
      });
    });
    return profileDetails;
  }
}
