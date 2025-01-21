import 'package:BDOne/view/screens/authSection/signin_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/createOtpChangePass.dart';
import '../../../model/request/verifyOtpChangePass.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../model/response/createOtpChangePassResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_text_component.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late double screenWidth;
  late double screenHeight;
  String phoneCode = "";
  int countryCode = 0;
  bool isLoading = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isValid = false;
  bool isOtpBoxVisible = false;
  String responseMessage = '';
  String otp = '';
  bool phoneNumberValid = false;
  bool isDarkMode = false;
  String selectedItem = "";

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  final List<String> _otp = List.generate(6, (_) => '');
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<CountryData> countryList = [];
  final TextEditingController _inputController = TextEditingController();
  late MainViewModel _viewModel;
  late ApiResponse apiResponse;

  @override
  void initState() {
    super.initState();
    isValid = false;
    phoneNumberValid = false;
    newPasswordVisible = true;
    confirmPasswordVisible = true;
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    _fetchData();
    Helper.getCountryList().then((countries) {
      List<CountryData> list = [];
      print(countries);
      countryList = countries!;
      print(countryList);
      if (countryList == [] || countryList.isEmpty || countryList == list) {
        _fetchData();
      } else {
        setState(() {
          countryList = countries;
          selectedItem = "${countries[0].flagImageUrl}";
          countryCode = int.parse("${countries[0].id}");
          phoneCode = "${countries[0].phoneCode}";
        });
      }
    });
    //_fetchData();
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<Widget> generateOtpResponse(BuildContext context) async {
    CreateOtpChangePassResponse? mediaList =
        apiResponse.data as CreateOtpChangePassResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_GREEN,
        ));
      case Status.COMPLETED:
        print("response: ${apiResponse.message}");
        print("data: ${apiResponse.data}");
        print("otp ${mediaList?.mobileOtp}");
        hideKeyBoard();
        CustomerVerifyOtpPass data = CustomerVerifyOtpPass(
            phoneNumber: "${_phoneNumberController.text}",
            countryId: countryCode);

        ToastComponent.showToast(
            context: context, message: mediaList?.mobileOtp);
        if (mediaList?.mobileOtp == null) {
          ToastComponent.showToast(
              context: context, message: apiResponse.message);
        }
        Navigator.pushNamed(context, "/OtpForgotPassScreen", arguments: data);
        /*ToastComponent.showToast(
            context: context, message: mediaList?.mobileOtp);*/

        setState(() {
          isOtpBoxVisible = true;
        });

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(
              context: context, message: apiResponse.message);
        }
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

  Future<Widget> verifyOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    final mediaList = apiResponse.data;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_ACCENT,
        ));
      case Status.COMPLETED:
        print("rwrwr ");
        ToastComponent.showToast(
            context: context, message: apiResponse.message);
        Helper.clearAllSharedPreferences();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SigninScreen()),
          (Route<dynamic> route) => false,
        );

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}"))
          SessionExpiredDialog.showDialogBox(context: context);
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

  Widget getCountryList(BuildContext context) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = countryListResponse?.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_GREEN,
        ));
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[0].name}");
        Helper.saveCountryList(countryListResponse?.countries);

        countryList = countryListResponse!.countries!;
        selectedItem = "${countryListResponse.countries?[0].flagImageUrl}";
        countryCode = int.parse("${countryListResponse.countries?[0].id}");
        phoneCode = "${countryListResponse.countries?[0].phoneCode}";
        print("countriess ${countryList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${countryList}");
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
    double screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: CustomTextComponent(
                    text: Languages.of(context)!.labelForgotPass,
                    fontSize: 34,
                    fontColor: isDarkMode ? Colors.white : Colors.black,
                    isBold: true),
                middle: CustomTextComponent(
                    text: Languages.of(context)!.labelForgotPass,
                    fontSize: 24,
                    fontColor: isDarkMode ? Colors.white : Colors.black,
                    isBold: true),
                backgroundColor:
                    isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.WHITE,
                stretch: true,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 24,
                  ),
                ),
                alwaysShowMiddle: false,
                border: Border.all(color: Colors.transparent, width: 0),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      SvgPicture.asset(
                        "assets/forgot_pass_icon.svg",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _buildLabelText(
                            context,
                            "Please enter the email address to continue a verify your account",
                            16,
                            false,
                            true),
                      ),
                      _buildPhoneNumberTextField(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: !isValid
                                  ? WidgetStateProperty.all(
                                      Theme.of(context).highlightColor)
                                  : WidgetStateProperty.all(
                                      AppColor.PRIMARY_ACCENT),
                            ),
                            onPressed: () async {
                              hideKeyBoard();
                              Navigator.pushNamed(context, "/OtpVerificationScreen");
                           /*   if (phoneNumberValid &&
                                  countryCode > 0 &&
                                  phoneCode != "") {
                                print(_phoneNumberController.text);
                                setState(() {
                                  isLoading = true;
                                });
                                var phoneNumber =
                                    "${_phoneNumberController.text}";
                                CreateOtpChangePassRequest request =
                                    CreateOtpChangePassRequest(
                                        customer: CustomerGetOtpPassDetail(
                                            phoneNumber: phoneNumber,
                                            countryCode: countryCode));

                                await _viewModel.CreateOtpChangePass(
                                    "", request);
                                apiResponse = _viewModel.response;
                                generateOtpResponse(context);
                              } else if (countryCode == 0 && phoneCode == "") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(Languages.of(context)!
                                      .labelSelectCountryCode),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(Languages.of(context)!
                                      .labelEnterValidPhone),
                                ));
                              }*/
                            },
                            child: Text(
                              Languages.of(context)!.labelSendOtp,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(
                        color: isDarkMode
                            ? AppColor.WHITE
                            : AppColor.PRIMARY_GREEN,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _buildLabelText(context,
                "${Languages.of(context)?.labelEmailAddress}", 14, false, true),
          ),
        ),
        Container(
          height: 55,
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border(
                top: BorderSide(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.2),
                bottom: BorderSide(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.2),
                right: BorderSide(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.2),
                left: BorderSide(
                    color: isDarkMode ? Colors.grey : Colors.black54,
                    width: 0.2)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  controller: _phoneNumberController,
                  onChanged: emailValidate,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: 'john@example.com',
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    //suffixIcon:Icon(Icons.phone_enabled_sharp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  void isInputValid() {
    String otp = _controllers.map((controller) => controller.text).join();

    if (otp.isNotEmpty &&
        otp.length == 6 &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text &&
        validatePassword(_newPasswordController.text)) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  void _handleOnChange(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }

    String otpString = _otp.join('');
    if (otpString.length == 6) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold,
      bool isSubHeading) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: size.toDouble(),
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: isSubHeading
              ? Theme.of(context).highlightColor
              : Theme.of(context).focusColor),
    );
  }

  void _fetchData() async {
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
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      await _viewModel.fetchCountryList("");
      apiResponse = _viewModel.response;
      getCountryList(context);
    }
  }

  void _changeItem(CountryData newValue) {
    setState(() {
      print("${newValue.id}");
      countryCode = int.parse("${newValue.id}");
      phoneCode = "${newValue.code}";
      selectedItem = "${newValue.flagImageUrl}";
    });
  }

  void emailValidate(String email) {
    setState(() {
      isValid = EmailValidator.validate(email);
    });
    print(isValid);
  }

  bool validatePassword(String password) {
    // Regular expression pattern for password validation
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}
