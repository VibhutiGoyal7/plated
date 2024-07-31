import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/signInRequest.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
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
  bool isChecked = false;
  late double screenWidth;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    inputValid = false;
    Helper.getUserId().then((id) {
      print("id${id}");
      setState(() {
        if (id != null && id.isNotEmpty) {
          isChecked =true;
          _phoneNoController.text = "${id}";
        }
      });
      _isValidInput();
    });
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
    }
  }

  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Widget> getSignInResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${mediaList?.firstName}");
        /* ProfileResponse data = ProfileResponse(firstName: mediaList?.firstName, lastName: mediaList?.lastName,
            username: mediaList?.username,userId: mediaList?.id, email: mediaList?.email,   );*/

        if (isChecked) {
          print("aaa${_phoneNoController.text}");
          Helper.saveUserId("${_phoneNoController.text}");
        }else{
          Helper.saveUserId("");
        }

        String token = "${mediaList?.token}";
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        if (await Helper.saveProfileDetails(mediaList)) print("data saved");

        await Helper.savePassword(_passwordController.text);
        String? password = await Helper.getPassword();
        print("password: ${password}");
        var email = mediaList?.email;

        if (email?.isEmpty == true) {
          Navigator.pushReplacementNamed(context, '/SetUpAccount');
        } else {
          await Helper.saveProfileDetails(mediaList);
          ProfileResponse? prefData = await Helper.getProfileDetails();
          print("prefData : ${prefData?.username}");
          await Helper.saveCountry(mediaList?.countryName);
          await Helper.saveKycStatus(mediaList?.kycStatus);
          Navigator.pushReplacementNamed(context, '/BottomNav');
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("message : ${apiResponse.message}");
        ToastComponent.showToast(
            context: context, message: apiResponse.message);
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

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          hideKeyBoard();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: screenHeight,
                child: SingleChildScrollView(
                  child: Container(
                    height: screenHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: screenHeight * 0.25,
                                child: Image(
                                  alignment: Alignment.topLeft,
                                  width: screenWidth * 0.54,
                                  height: screenHeight * 0.3,
                                  image: AssetImage("assets/sign-in.png"),
                                  fit: BoxFit.fitWidth,
                                ),
                                alignment: AlignmentDirectional.center,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
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
                                    _buildLabelText(
                                        context, "Welcome Back!", 26, true),
                                    _buildLabelText(context,
                                        "Welcome back we missed you", 14, false),
                                    SizedBox(height: 25),
                                    _buildPhoneInput(
                                      context,
                                      "Phone Number",
                                      _phoneNoController,
                                      Icon(
                                        Icons.person,
                                        size: 20,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        passwordVisible,
                                        isDarkMode),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/ForgotPasswordScreen');
                                        },
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            "${Languages.of(context)?.labelForgotPass}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _buildFooter(context, apiResponse),
                                          /*  Flexible(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  hideKeyBoard();
                                                  _isValidInput();
                                                  const maxDuration =
                                                      Duration(seconds: 2);
                                                  Helper.getBiometric().then((enable){
                                                    if(enable == false) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content:
                                                              Text('Please Enable Biometric from your profile setting.'),
                                                          duration: maxDuration,
                                                        ),
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Image(
                                                  height: 45,
                                                  //width: 40,
                                                  image: AssetImage(
                                                      "assets/fingerprint.png"),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    //padding: EdgeInsets.symmetric(vertical: 10.0),
                                                    backgroundColor:
                                                        AppColor.WHITE,
                                                    elevation: 3,
                                                    shape: BeveledRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                2))),
                                              ),
                                            ),*/
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              Navigator.pushNamed(
                                                  context, '/PhoneVerifyScreen');
                                            },
                                            child: Text(
                                              "SignUp here.",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false,
                            color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, double size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        //height: 60,
        width: screenWidth * 0.8,
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
                maxLength: 12,
                textAlignVertical: TextAlignVertical.center,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                onSubmitted: (value) {},
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: icon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Save ID",
                          style: TextStyle(fontSize: 10),
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          semanticLabel: "Save ID",
                          side: BorderSide(color: Colors.black),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ],
                    )),
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
        width: screenWidth * 0.8,
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
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
          width: screenWidth * 0.7,
          height: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                hideKeyBoard();
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
                          content: Text('No internet connection'),
                          duration: maxDuration,
                        ),
                      );
                    });
                  } else {
                    await Provider.of<MainViewModel>(context, listen: false)
                        .signInWithPass(
                            "api/v1/app/customers/sign_in", request);
                    //Navigator.pushNamed(context, '/BottomNav');

                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    getSignInResponse(context, apiResponse);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter valid details.'),
                    duration: maxDuration,
                  ));
                }
              },
              child: Text(
                Languages.of(context)!.labelLogin,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  //padding: EdgeInsets.symmetric(vertical: 10.0),
                  backgroundColor: inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),
      ],
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
