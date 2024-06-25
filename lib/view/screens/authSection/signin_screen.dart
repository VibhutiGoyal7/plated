import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:payrio/model/apis/api_response.dart';
import 'package:payrio/model/request/signInRequest.dart';
import 'package:payrio/model/response/signInResponse.dart';
import 'package:payrio/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../model/response/setUpAccountResponse.dart';
import '../../../utils/Helper.dart';

class SigninScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  SigninScreen({Key? key, this.data}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool passwordVisible = false;

  bool inputValid = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    inputValid = false;
  }

  void _isValidInput() {
    //print(input);
    if (_passwordController.text.isNotEmpty &&
        _phoneNoController.text.isNotEmpty &&
        _passwordController.text.length >= 8) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    SignInResponse? mediaList = apiResponse.data as SignInResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.firstName}");
        Navigator.pushNamed(context, '/BottomNav');

        await Helper.saveUserDetails(mediaList);
        String token = "${mediaList?.token}";
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        //if (await Helper.saveProfileDetails(mediaList)) print("data saved");

        await Helper.savePassword(_passwordController.text);
        String? password = await Helper.getPassword();
        print("password: ${password}");

        SetUpAccountResponse? retrievedToken = await Helper.getUserDetails();
        print('Retrieved Token: ${retrievedToken}');
        _fetchData();

        // Navigate to the new screen after receiving the response
        //Navigator.pushNamed(context, '/BottomNav');
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

  Future<Widget> getProfileWidget(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
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
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLabelText(
                        context, "Login", 18, false),
                    SizedBox(height: 20),
                    SizedBox(height: 10),
                    _buildPhoneInput(
                        context,
                        "Phone Number",
                        _phoneNoController,
                        Icon(
                          Icons.person,
                          size: 20,
                          color: isDarkMode ? Colors.white : Colors.black,
                        )),
                    SizedBox(height: 10),
                    _buildPasswordInput(
                        context,
                        Languages.of(context)!.labelPassword,
                        _passwordController,
                        Icon(
                          Icons.password,
                          size: 18,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        passwordVisible,
                        isDarkMode),
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
          fontSize: 28, fontWeight: FontWeight.bold,
          color: Colors.blueAccent),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.phone,
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
      ),
    );
  }

  Widget _buildPasswordInput(
    BuildContext context,
    String text,
    TextEditingController nameController,
    Icon icon,
    bool passwordVisibles,
    bool isDarkMode,
  ) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 14.0),
                obscureText: passwordVisibles,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                  icon: icon,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisibles
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _isValidInput();
                if (inputValid) {
                  SignInRequest request = SignInRequest(
                      customer: CustomerSignIn(
                          phoneNumber: _phoneNoController.text,
                          password: _passwordController.text));
                  await Provider.of<MediaViewModel>(context, listen: false)
                      .signInWithPass("api/v1/app/customers/sign_in", request);
                  //Navigator.pushNamed(context, '/BottomNav');

                  ApiResponse apiResponse =
                      Provider.of<MediaViewModel>(context, listen: false)
                          .response;
                  getMediaWidget(context, apiResponse);
                }
              },
              child: Text(
                Languages.of(context)!.labelConfirm,
                style: TextStyle(
                    color: inputValid ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      inputValid ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape:
                      BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Do you need any help?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchData() async {
    String? retrievedToken = await Helper.getUserToken();
    print("Token $retrievedToken");
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .profileScreenData("/api/v1/app/customers/show_customer_details");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getProfileWidget(context, apiResponse);
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
