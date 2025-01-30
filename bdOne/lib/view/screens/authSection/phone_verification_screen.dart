import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/exustingUserRequest.dart';
import '../../../model/request/signInWithPhoneNumber.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../model/response/existingUserResponse.dart';
import '../../../model/response/phoneVerifyResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/toastMessage.dart';

class PhoneVerifyScreen extends StatefulWidget {
  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_PhoneVerifyScreenState>();
    state?.setLocale(newLocale);
  }
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late Locale _locale;
  final ScrollController _scrollController = ScrollController();
  String phoneCode = "";
  String selectedCountryCode = "+880";
  int countryCode = 0;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  String dropdownValue = "";
  bool isDarkMode = false;
  late double screenWidth;
  String selectedItem = "";

  late MainViewModel _viewModel;
  late ApiResponse apiResponse;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  bool phoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    phoneNumberValid = false;
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
  }

  final TextEditingController _inputController = TextEditingController();

  void _isValidPhoneNumber(String input) {
    print(input);
    if (input.isNotEmpty && input.length >= 10) {
      setState(() {
        phoneNumberValid = true;
      });
    } else {
      setState(() {
        phoneNumberValid = false;
      });
    }
  }

  Widget existingUserWidget(BuildContext context) {
    ExistingUserResponse? mediaList = apiResponse.data as ExistingUserResponse?;
    var message = apiResponse.message.toString();
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
        print("userfound: ${mediaList?.userFound}");
        // Navigate to the new screen after receiving the response
        if (mediaList?.userFound == true &&
            mediaList?.isProfileSetupDone == true) {
          /*Navigator.pushNamed(context, '/SignInScreen',
              arguments: "${_inputController.text}");*/
          ToastComponent.showToast(
              context: context,
              message: "This number belongs to an existing user, Please login");
        } else {
          _phoneVerifyAPI();
        }
        return Container();
      case Status.ERROR:
        _phoneVerifyAPI();
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

  Future<Widget> getPhoneVerifyResponse(
      BuildContext context, ApiResponse apiResponse) async {
    var phoneVerifyResponse = apiResponse.data as PhoneVerifyResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
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
        print("rwrwr ${phoneVerifyResponse?.mobileOtp}");
        //Call Toast

        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(
          context,
          '/OtpVerificationScreen',
          arguments:'${_inputController.text.toString()}',
        );
        ToastComponent.showToast(context: context, message: message);
        return Container(); // Return an empty container as yo u'll navigate away
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
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool keyboardOpen = isKeyboardOpen(context);
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: GestureDetector(
      onTap: () {
        hideKeyBoard();
      },
      child: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        // Top Image and Header
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                "assets/phone_globe.svg",
                                height: keyboardOpen == true
                                    ? MediaQuery.of(context).size.height / 4
                                    : MediaQuery.of(context).size.height / 2.5,
                                width: screenWidth,
                                semanticsLabel: 'A decorative image',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Input Card
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            margin: EdgeInsets.only(top: 5),
                            elevation: 0,
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            child: Container(
                              height: screenHeight / 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: _buildLabelText(
                                          context,
                                          "${Languages.of(context)?.labelEnterPhoneNo}",
                                          20,
                                          true,
                                        )),
                                    SizedBox(height: 8),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: _buildLabelText(
                                          context,
                                          "${Languages.of(context)?.labelSendConfirmationCode}",
                                          12,
                                          false,
                                        )),
                                    SizedBox(height: 16),
                                    _buildPhoneInput(context, isDarkMode),
                                    SizedBox(height: 25),
                                    _buildFooter(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading) CustomCircularProgress(),
            // Show loading indicator conditionally
          ],
        ),
      ),
    ));
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

  Widget _buildPhoneInput(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 0.2,
                        color: Theme.of(context).cardColor,),
                    color:
                        isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16.0),
                          controller: _inputController,
                          onChanged: _isValidPhoneNumber,
                          maxLength: 11,
                          keyboardType: TextInputType.phone,
                          onSubmitted: (value) {
                            // Implement submit logic if needed
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.8)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.7)),
                            counterText: "",
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            phoneNumberValid ? AppColor.PRIMARY_ACCENT : Colors.grey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          hideKeyBoard();
          if (phoneNumberValid) {
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
              ExistingUserRequest request = ExistingUserRequest(
                  customer:
                      ExistingCustomer(phoneNumber: _inputController.text));
              await _viewModel.existingUserData(request);
              apiResponse = _viewModel.response;
              existingUserWidget(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(Languages.of(context)!.labelEnterValidPhone),
            ));
          }
        },
        child: Text(
          Languages.of(context)!.labelSubmit,
          style: TextStyle(
              color: phoneNumberValid ? Colors.white : AppColor.PRIMARY,
              fontSize: 15),
        ),
      ),
    );
  }

  void _phoneVerifyAPI() async {
    if (phoneNumberValid) {
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
        PhoneRequest phoneRequest = PhoneRequest(
            customer: Customer(
                phoneNumber: _inputController.text,
                mobileOtp: "",
                countryId: countryCode));
        await _viewModel.PhoneVerifyData(phoneRequest);
        apiResponse = _viewModel.response;
        getPhoneVerifyResponse(context, apiResponse);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${Languages.of(context)?.labelPleaseEnterValidPhoneNo}'),
          duration: maxDuration,
        ),
      );
    }
  }
}
