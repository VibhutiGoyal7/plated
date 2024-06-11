import 'package:flutter/material.dart';
import 'package:mvvm_flutter_app/model/apis/api_response.dart';
import 'package:mvvm_flutter_app/model/request/setUpAccountRequest.dart';
import 'package:mvvm_flutter_app/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

import '../../Strings/Languages.dart';
import '../../model/response/setUpAccountResponse.dart';

class SetUpAccountScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  SetUpAccountScreen({Key? key, this.userId}) : super(key: key);

  @override
  _SetUpAccountScreenState createState() => _SetUpAccountScreenState();
}

class _SetUpAccountScreenState extends State<SetUpAccountScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    SetUpAccountResponse? mediaList = apiResponse.data as SetUpAccountResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.firstName}");
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/BottomNav');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight * 0.95),
            child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelText(context, Languages.of(context)!.labelAlmostFinish, 16, false),
                        SizedBox(height: 4),
                        _buildLabelText(
                            context, Languages.of(context)!.labelSetProfile, 20, true),
                        SizedBox(height: 4),
                        _buildLabelText(
                            context, Languages.of(context)!.labelTellAbtYourself, 14, false),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelText(
                                context, Languages.of(context)!.labelPromoCode, 14, false),
                            _buildLabelText(context, Languages.of(context)!.labelRedeem, 14, false),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildPhoneInput(
                            context,
                            Languages.of(context)!.labelName,
                            _nameController,
                            Icon(
                              Icons.person,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 10),
                        _buildPhoneInput(
                            context,
                            Languages.of(context)!.labelLastname,
                            _lastNameController,
                            Icon(Icons.person,
                                size: 20,
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                        SizedBox(height: 10),
                        _buildPhoneInput(
                            context,
                            Languages.of(context)!.labelEmail,
                            _emailController,
                            Icon(Icons.mail,
                                size: 18,
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                        SizedBox(height: 10),
                        _buildPasswordInput(
                            context,
                            Languages.of(context)!.labelPassword,
                            _passwordController,
                            Icon(Icons.password,
                                size: 18,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            passwordVisible,
                            isDarkMode),
                        SizedBox(height: 10),
                        _buildPasswordInput(
                            context,
                            Languages.of(context)!.labelConfirmPass,
                            _confirmPasswordController,
                            Icon(Icons.password,
                                size: 18,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            confirmPasswordVisible,
                            isDarkMode),
                      ],
                    ),
                    _buildFooter(context, apiResponse),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 16.0,
              ),
              obscureText: false,
              obscuringCharacter: "*",
              controller: nameController,
              onChanged: (value) {},
              onSubmitted: (value) {},
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(color: Colors.grey),
                icon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput(
    BuildContext context,
    String text,
    TextEditingController nameController,
    Icon icon,
    bool passwordVisibles, bool isDarkMode,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 16.0),
              obscureText: passwordVisibles,
              obscuringCharacter: "*",
              controller: nameController,
              onChanged: (value) {},
              onSubmitted: (value) {},
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(color: Colors.grey),
                icon: icon,
                suffixIcon: IconButton(
                  icon: Icon(passwordVisibles
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 20,),
                  onPressed: () {
                    setState(
                      () {
                        if (text == "Password") {
                          passwordVisible = !passwordVisible;
                        } else {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        }
                      },
                    );
                  },
                ),


              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              print(_nameController.text);
              SetUpAccountRequest request = SetUpAccountRequest(
                  customer: CustomerDetail(
                email: _emailController.text,
                password: _passwordController.text,
                firstName: _nameController.text,
                lastName: _lastNameController.text,
                dob: "17/07/1996",
              ));
              // Make the API call to fetch media data
              await Provider.of<MediaViewModel>(context, listen: false)
                  .fetchSetUpScreenData(
                      "/api/v1/app/customers/update_customer", request);
              //Navigator.pushNamed(context, '/BottomNav');

              // Now that the API call is complete, update the UI based on the response
              ApiResponse apiResponse =
                  Provider.of<MediaViewModel>(context, listen: false).response;
              getMediaWidget(context, apiResponse);
              //Navigator.pushNamed(context, '/BottomNav');
            },
            child: Text(Languages.of(context)!.labelConfirm),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                backgroundColor: Colors.white,
                elevation: 3,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Do you need any help?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
