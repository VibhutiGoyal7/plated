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
import '../../../model/response/signInResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/WavePainter.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
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
  String password = "";
  static const maxDuration = Duration(seconds: 2);

  late MainViewModel _viewModel;
  late ApiResponse apiResponse;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    inputValid = false;
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
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

  Future<Widget> getSignInResponse(BuildContext context) async {
    SignInResponse? mediaList = apiResponse.data as SignInResponse?;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        print("GetSignInResponse : ${mediaList?.firstName}");
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
          Navigator.pushReplacementNamed(context, '/BottomNav');
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Error message : ${apiResponse.message}");
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
      /*   appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                width: 150,
                image: AssetImage(isDarkMode
                    ? "assets/app_logo_dark.png"
                    : "assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),*/
      body: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, 200), // Adjust height as needed
              painter: WavePainter(),
            ),
            SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight -
                          MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            14,
                            false,
                            true),
                        SizedBox(height: 25),
                        _buildLabelText(
                            context,
                            "${Languages.of(context)?.labelPhoneNumber}",
                            12,
                            true,
                            true),
                        _buildPhoneInput(
                          context,
                          "${Languages.of(context)?.labelPhoneNumber}",
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
                            12,
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
                                    fontSize: 12,
                                    color: Theme.of(context).focusColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${Languages.of(context)?.labelNeedAcc} ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/PhoneVerifyScreen');
                      },
                      child: Text(
                        "${Languages.of(context)?.labelSignup}",
                        style: TextStyle(
                            fontSize: 14,
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
                    child: CustomCircularProgress(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, double size, bool isBold,
      bool isSubHeading) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: size,
            fontWeight: isBold ? FontWeight.w400 : FontWeight.normal,
            color: isSubHeading
                ? isKeyboardOpen(context)
                    ? Colors.white
                    : Theme.of(context).focusColor
                : isKeyboardOpen(context)
                    ? Colors.white
                    : Theme.of(context).focusColor),
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
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
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            bottom: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            right: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            left: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1)),
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
        maxLength: 11,
        //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        onSubmitted: (value) {},
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter ${text}",
          //alignLabelWithHint: true,
          counterText: "",
          //icon: icon,
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
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            bottom: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            right: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1),
            left: BorderSide(
                color: isDarkMode ? Colors.grey : Colors.black54, width: 0.1)),
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
          hintText: "Enter ${text}",
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

  Widget _buildFooter(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        hideKeyBoard();
        _isValidInput();
        if (inputValid) {
          password = _passwordController.text;
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
            await _viewModel.signInWithPass(request);

            apiResponse = await _viewModel.response;
            getSignInResponse(context);
          }
        } else if (!validatePassword(_passwordController.text)) {
          ToastComponent.showToast(
              message: Languages.of(context)!.labelPasswordRequirement,
              context: context,
              duration: maxDuration);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('${Languages.of(context)?.labelPleaseEnterAllDetails}'),
            duration: maxDuration,
          ));
        }
      },
      color: inputValid ? AppColor.PRIMARY_ACCENT : Colors.grey[400],
      minWidth: screenWidth * 0.75,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        Languages.of(context)!.labelLogin,
        style: TextStyle(
            color: inputValid ? Colors.white : AppColor.PRIMARY, fontSize: 16),
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

  bool validatePassword(String password) {
    // Regular expression pattern for password validation
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}
