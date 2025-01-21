import 'package:BDOne/model/apis/api_response.dart';
import 'package:BDOne/model/request/signInRequest.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';
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
  String? deviceToken;
  String selectedItem = "";

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    inputValid = false;
    Helper.getDeviceToken().then((token) {
      setState(() {
        deviceToken = token;
      });
    });
    //getUserDeviceId();
    Helper.getUserId().then((id) {
      setState(() {
        if (id != null && id.isNotEmpty) {
          isChecked = true;
          _phoneNoController.text = "${id}";
        }
      });
      _isValidInput();
    });
  }

  void _isValidInput() {
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
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomLoader());
      case Status.COMPLETED:
        print("GetSignInResponse : ${mediaList?.firstName}");
        /* ProfileResponse data = ProfileResponse(firstName: mediaList?.firstName, lastName: mediaList?.lastName,
            username: mediaList?.username,userId: mediaList?.id, email: mediaList?.email,   );*/

        if (isChecked) {
          print("aaa${_phoneNoController.text}");
          Helper.saveUserId("${_phoneNoController.text}");
        } else {
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
      body: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        screenHeight - MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      //alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelLogin}",
                              26,
                              true,
                              false),
                          SizedBox(height: 6),
                          _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelAccessToAccount}",
                              18,
                              false,
                              true),
                          SizedBox(height: 25),
                          _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelEmailAddress}",
                              15,
                              true,
                              true),
                          _buildPhoneInput(
                            context,
                            "${Languages.of(context)?.labelEmail}",
                            _phoneNoController,
                            Icon(
                              Icons.person,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelPassword}",
                              15,
                              true,
                              true),
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
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          _buildFooter(context, apiResponse),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${Languages.of(context)?.labelNeedAcc} ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/SignUpScreen');
                        },
                        child: Text(
                          "${Languages.of(context)?.labelSignup}",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColor.PRIMARY_ACCENT,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CustomLoader(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, double size, bool isBold,
      bool isSubHeading) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: isBold ? FontWeight.w400 : FontWeight.normal,
          color: isSubHeading
              ? Theme.of(context).highlightColor
              : Theme.of(context).focusColor),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon)
  {
    //nameController.text = widget.data as String;
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 12.0, right: 8.0, top: 2, bottom: 2),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
            top: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            bottom: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            right: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            left: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: TextField(
        style: TextStyle(
          fontSize: 16.0,
        ),
        //obscureText: false,
        controller: nameController,
        onChanged: (value) {
          _isValidInput();
        },
        maxLength: 20,
        //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        onSubmitted: (value) {},
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          //alignLabelWithHint: true,
          counterText: "",
          //icon: icon,
          /*suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${Languages.of(context)?.labelSaveId}",
                  style: TextStyle(fontSize: 10),
                ),
                Checkbox(
                  checkColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  semanticLabel: "${Languages.of(context)?.labelSaveId}",
                  side: BorderSide(
                      color: isDarkMode ? Colors.white : Colors.black),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            )*/
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
    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(left: 12.0, right: 8.0, top: 2, bottom: 2),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
            top: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            bottom: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            right: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2),
            left: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.2)),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 16.0),
        obscureText: passwordVisibles,
        obscuringCharacter: "*",
        controller: nameController,
        onChanged: (value) {
          _isValidInput();
        },
        //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        onSubmitted: (value) {},
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          //alignLabelWithHint: true,
          //icon: icon,
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisibles
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 24,
              color: isDarkMode ? Colors.white60 : Colors.black87,
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
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inputValid ? AppColor.PRIMARY_ACCENT : Colors.grey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: MaterialButton(
        onPressed: () async {
          hideKeyBoard();
          Navigator.pushNamed(context, '/BottomNav');
          _isValidInput();
          const maxDuration = Duration(seconds: 2);
          if (inputValid) {
            SignInRequest request = SignInRequest(
                customer: CustomerSignIn(
                    phoneNumber: _phoneNoController.text,
                    password: _passwordController.text,
                    deviceToken: deviceToken));

            setState(() {
              isLoading = true;
            });

            bool isConnected = await _connectivityService.isConnected();
            if (!isConnected) {
              setState(() {
                isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${Languages.of(context)?.labelNoInternetConnection}'),
                    duration: maxDuration,
                  ),
                );
              });
            } else {
              //await Provider.of<MainViewModel>(context, listen: false).signInWithPass("api/v1/app/customers/sign_in", request);
              //Navigator.pushNamed(context, '/BottomNav');

              ApiResponse apiResponse =
                  Provider.of<MainViewModel>(context, listen: false).response;
              getSignInResponse(context, apiResponse);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('${Languages.of(context)?.labelPleaseEnterAllDetails}'),
              duration: maxDuration,
            ));
          }
        },
        child: Text(
          Languages.of(context)!.labelLogin,
          style: TextStyle(
              color: inputValid ? Colors.white : AppColor.PRIMARY,
              fontSize: 16),
        ),
      ),
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }

  Future<void> getUserDeviceId() async {
    deviceToken = await getDeviceId();
  }
}
