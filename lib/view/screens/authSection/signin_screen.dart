import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/signInRequest.dart';
import 'package:Payrio/model/response/signInResponse.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class SigninScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  SigninScreen({Key? key, this.data}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool passwordVisible = false;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  bool inputValid = false;
  late double screenWidth;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    inputValid = false;
  }

  void _isValidInput() {
    const maxDuration = Duration(seconds: 2);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter valid details.'),
          duration: maxDuration,
        ),
      );
    }
  }

  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Widget> getSignInResponse(
      BuildContext context, ApiResponse apiResponse) async {
    SignInResponse? mediaList = apiResponse.data as SignInResponse?;
    var message = mediaList?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.firstName}");

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
        var email = mediaList?.email;

        if (email?.isEmpty == true) {
          Navigator.pushReplacementNamed(context, '/SetUpAccount');
        }else{
          await Helper.saveProfileDetails(mediaList);
          //await Helper.saveCountry(mediaList?.countryName);
          await Helper.saveKycStatus(mediaList?.kycStatus);
          Navigator.pushReplacementNamed(context, '/BottomNav');
        }
        //SetUpAccountResponse? retrievedToken = await Helper.getUserDetails();
        //print('Retrieved Token: ${retrievedToken}');
        //_fetchData();

        // Navigate to the new screen after receiving the response
        //Navigator.pushNamed(context, '/BottomNav');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("message : ${apiResponse.message}");
        ToastComponent.showToast(context: context, message: apiResponse.message);
        return Center(
            // child: Text('Please try again later!!!'),
            );
      case Status.INITIAL:
      default:
        return Center(
            // child: Text('Search for the song by Artist'),
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
        var email = mediaList?.email;
        if (email?.isEmpty == true) {
          Navigator.pushReplacementNamed(context, '/SetUpAccount');
        }else{
          await Helper.saveProfileDetails(mediaList);
          await Helper.saveCountry(mediaList?.countryName);
          await Helper.saveKycStatus(mediaList?.kycStatus);
          Navigator.pushReplacementNamed(context, '/BottomNav');
        }

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
            //child: Text('Please try again later!!!'),
            );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:
        isLoading ?
        Center(
          child: CircularProgressIndicator(),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: screenHeight * 0.2,
                  child: Image(
                    alignment: Alignment.topLeft,
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.25,
                    image: AssetImage("assets/payment_image.png"),
                  ),
                  alignment: AlignmentDirectional.center,
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.zero,
                child: Card(
                  elevation: 20,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _buildLabelText(context, "Welcome Back!", 26, true),
                        _buildLabelText(
                            context, "Welcome back we missed you", 14, false),
                        SizedBox(height: 25),
                        _buildPhoneInput(
                          context,
                          "Phone Number",
                          _phoneNoController,
                          Icon(
                            Icons.person,
                            size: 20,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 15),
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
                        SizedBox(
                          height: 15,
                        ),
                        _buildFooter(context, apiResponse),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, double size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        //height: 60,
        width: screenWidth*0.8,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
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
        width: screenWidth*0.8,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
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
                  alignLabelWithHint: true,
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
          width: screenWidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _isValidInput();
                const maxDuration = Duration(seconds: 2);
                if (inputValid) {
                  SignInRequest request = SignInRequest(
                      customer: CustomerSignIn(
                          phoneNumber: _phoneNoController.text,
                          password: _passwordController.text));

                  setState(() {
                    isLoading = true;
                  });

                  bool isConnected = await _connectivityService.isConnected();
                  if (!isConnected) {
                    setState(() {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('No internet connection'),
                          duration: maxDuration,
                        ),
                      );
                    });
                  }else {
                    await Provider.of<MainViewModel>(context, listen: false)
                        .signInWithPass(
                        "api/v1/app/customers/sign_in", request);
                    //Navigator.pushNamed(context, '/BottomNav');

                    ApiResponse apiResponse =
                        Provider
                            .of<MainViewModel>(context, listen: false)
                            .response;
                    getSignInResponse(context, apiResponse);
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text('Please enter valid details.'),
                      duration: maxDuration,
                  );
                }
              },
              child: Text(
                Languages.of(context)!.labelConfirm,
                style: TextStyle(
                    color: inputValid ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  backgroundColor:
                      inputValid ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Need account? ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/ForgotPasswordScreen');
                },
                child: Text(
                  "SignUp here.",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _fetchData() async {
    String? retrievedToken = await Helper.getUserToken();
    print("Token $retrievedToken");
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .profileScreenData("/api/v1/app/customers/show_customer_details");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getProfileWidget(context, apiResponse);
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
