import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class PersonalInformationScreen extends StatelessWidget {
  //final NavController navController;

 // PersonalInformationScreen({required this.navController});

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
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      //navController.navigateUp();
                    },
                    child:Icon(Icons.arrow_back_ios, color: Colors.black,),
                  ),
                ),
                Text(
                  'Personal Information',
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            _buildMenuItem(
              context: context,
              text: 'Personal Data',
              onTap: () {
                  Navigator.pushNamed(context, '/PersonalDataScreen');
              },
            ),
            _buildMenuItem(
              context: context,
              text: 'Address',
              onTap: () {
                  Navigator.pushNamed(context, '/AddressScreen');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Complete your Profile',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  //color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
            ],
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: /*customerDetailsResponse?.isEmailVerified */ emailVerified== true
              ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("Email Verified", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5.0,),
                    Text(
                                'Your Email has been successfully verified via OTP which was sent on your email address',
                                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onBackground,
                                ),
                                textAlign: TextAlign.left,
                              ),
                  ],
                ),
              )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your Email',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Click the following link to verify your email address and associate it with your Payorio Account',
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
}
