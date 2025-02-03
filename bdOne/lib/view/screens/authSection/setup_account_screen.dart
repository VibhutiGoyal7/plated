import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/setUpAccountRequest.dart';
import '../../../model/response/setUpAccountResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class SetUpAccountScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  SetUpAccountScreen({Key? key, this.userId}) : super(key: key);

  @override
  _SetUpAccountScreenState createState() => _SetUpAccountScreenState();
}

class _SetUpAccountScreenState extends State<SetUpAccountScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  String token = "";
  final ConnectivityService _connectivityService = ConnectivityService();
  String currentLatitude = "";
  String currentLongitude = "";
  bool inputValid = false;
  bool isDarkMode = false;
  late double screenWidth;
  late MainViewModel _viewModel;
  late ApiResponse apiResponse;
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    _getCurrentLocation();
    Helper.getOtpToken().then((otpToken) {
      print("otpToken $otpToken");
      token = "${otpToken}";
    });
  }

  void _isValidInput() {
    //print(input);
    if (_emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.length >= 8 &&
        _passwordController.text == _confirmPasswordController.text &&
        validatePassword(_passwordController.text) &&
        EmailValidator.validate(_emailController.text)) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Widget> getSetUpAccountWidget(BuildContext context) async {
    SetUpAccountResponse? setUpAccountResponse =
        apiResponse.data as SetUpAccountResponse?;
    String? message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : Colors.red,
        ));
      case Status.COMPLETED:
        print("GetSetUpAccountWidget : ${setUpAccountResponse?.firstName}");
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        Helper.getUserToken();
        await Helper.saveProfileDetails(setUpAccountResponse);
        if (await Helper.saveProfileDetails(setUpAccountResponse))
          print("data saved");
        else
          print("not saved");

        await Helper.savePassword(_passwordController.text);
        await Helper.saveKycStatus(setUpAccountResponse?.kycStatus);
        String? password = await Helper.getPassword();
        print("password: ${password}");
        await Helper.getUserDetails();

        Navigator.pushReplacementNamed(context, '/BottomNav', arguments: 0);
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        ToastComponent.showToast(context: context, message: message);
        return Center(
          child: Text('Please try again later!!!'),
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
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: Stack(
            children: [
              CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelText(
                                    context,
                                    Languages.of(context)!.labelAlmostFinish,
                                    15,
                                    false),
                                SizedBox(height: 1),
                                _buildLabelText(
                                    context,
                                    Languages.of(context)!.labelSetProfile,
                                    20,
                                    true),
                                SizedBox(height: 8),
                                _buildLabelText(
                                    context,
                                    Languages.of(context)!.labelTellAbtYourself,
                                    18,
                                    false),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                            Icon(
                              Icons.person,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 10),
                        _buildPhoneInput(
                            context,
                            Languages.of(context)!.labelEmail,
                            _emailController,
                            Icon(
                              Icons.mail,
                              size: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 10),
                        _buildDOBInput(
                            context,
                            Languages.of(context)!.labelDOB,
                            _dateController,
                            Icon(
                              Icons.calendar_month,
                              size: 18,
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
                        SizedBox(height: 10),
                        _buildPasswordInput(
                            context,
                            Languages.of(context)!.labelConfirmPass,
                            _confirmPasswordController,
                            Icon(
                              Icons.password,
                              size: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            confirmPasswordVisible,
                            isDarkMode),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelPasswordRequirement}",
                              9,
                              false),
                        ),
                        SizedBox(height: 40),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
              ]),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(
                            color: isDarkMode ? AppColor.WHITE : Colors.red,
                          ),
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

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade300,
            blurRadius: 2,
          ),
        ],
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
              onChanged: (value) {
                _isValidInput();
              },
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (value) {},
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintText: text,
                icon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDOBInput(BuildContext context, String text,
      TextEditingController dateController, Icon icon) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade300,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: dateController,
                  //editing controller of this TextField
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Languages.of(context)!.labelBirthdate,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      icon: icon
                      //icon of text field
                      ),
                  readOnly: true,
                  // when true user cannot edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(Duration(days: 365 * 18)),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate:
                            DateTime.now().subtract(Duration(days: 365 * 18)),
                        helpText: "${Languages.of(context)?.labelSelectDob}",
                        confirmText: "${Languages.of(context)?.labelConfirm}",
                        errorFormatText:
                            '${Languages.of(context)?.labelEnterValidDate}',
                        errorInvalidText:
                            '${Languages.of(context)?.labelEnterDateInValidRange}',
                        builder: (context, child) {
                          return Theme(
                            data: isDarkMode
                                ? ThemeData.dark()
                                : ThemeData
                                    .light(), // This will change to light theme.
                            child: child!,
                          );
                        });

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        _dateController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  })),
        ],
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
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade300,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                icon: icon,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibles ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                    color: isDarkMode ? Colors.white60 : Colors.black45,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (text == "${Languages.of(context)?.labelPassword}") {
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

  Widget _buildFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: () async {
            hideKeyBoard();
            _isValidInput();
            if (inputValid) {
              setState(() {
                isLoading = true;
              });

              bool isConnected = await _connectivityService.isConnected();
              if (!isConnected) {
                setState(() {
                  isLoading = false;
                  showSnackBar(
                      context,
                      '${Languages.of(context)?.labelNoInternetConnection}',
                      screenWidth * 0.7);
                });
              } else {
                SetUpAccountRequest request = SetUpAccountRequest(
                    customer: CustomerDetail(
                        email: _emailController.text,
                        password: _passwordController.text,
                        firstName: _nameController.text,
                        lastName: _lastNameController.text,
                        dob: _dateController.text,
                        latitude: currentLatitude,
                        longitude: currentLongitude));
                await _viewModel.fetchSetUpScreenData(request, token);
                apiResponse = _viewModel.response;
                getSetUpAccountWidget(context);
              }
            } else {
              if (_emailController.text.isEmpty &&
                  _nameController.text.isEmpty &&
                  _lastNameController.text.isEmpty &&
                  _passwordController.text.isEmpty &&
                  _dateController.text.isEmpty &&
                  _confirmPasswordController.text.isEmpty) {
                showSnackBar(
                    context, 'Please enter all the details', screenWidth * 0.7);
              } else if (!EmailValidator.validate(_emailController.text)) {
                showSnackBar(
                    context, 'Enter valid email address.', screenWidth * 0.7);
              } else if (_passwordController.text.length < 8) {
                showSnackBar(
                    context,
                    '${Languages.of(context)?.labelPasswordAlert}',
                    screenWidth * 0.7);
              } else if (_passwordController.text !=
                  _confirmPasswordController.text) {
                showSnackBar(
                    context,
                    '${Languages.of(context)?.labelPasswordDoesntMatch}',
                    screenWidth * 0.7);
              } else if (!validatePassword(_passwordController.text)) {
                ToastComponent.showToast(
                    message: Languages.of(context)!.labelPasswordRequirement,
                    context: context,
                    duration: maxDuration);
              }
            }
          },
          color: inputValid ? AppColor.PRIMARY_ACCENT : Colors.grey[300],
          minWidth: screenWidth * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Text(
            Languages.of(context)!.labelConfirm,
            style: TextStyle(shadows: [
              BoxShadow(
                color: AppColor.PRIMARY_GREEN,
                blurRadius: 2,
              ),
            ], color: inputValid ? Theme.of(context).cardColor : Colors.black),
          ),
        ),
      ],
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }

  bool validatePassword(String password) {
    // Regular expression pattern for password validation
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      currentLatitude = "${position.latitude}";
      currentLongitude = "${position.longitude}";
      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      // Location services are not enabled, show an error or request to enable
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        // Permissions are denied, show an error
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      // Permissions are denied forever, handle accordingly
      throw Exception('Location permissions are permanently denied.');
    }

    // Retrieve the current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
