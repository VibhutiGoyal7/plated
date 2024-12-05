import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/apis/api_response.dart';
import 'package:BDPass/utils/Util.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:BDPass/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/response/setUpAccountResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class AccountRecoveryScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  AccountRecoveryScreen({Key? key, this.userId}) : super(key: key);

  @override
  _AccountRecoveryScreenState createState() => _AccountRecoveryScreenState();
}

class _AccountRecoveryScreenState extends State<AccountRecoveryScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  bool inputValid = false;
  bool isDarkMode = false;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
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

  Future<Widget> getSetUpAccountWidget(
      BuildContext context, ApiResponse apiResponse) async {
    SetUpAccountResponse? setUpAccountResponse =
        apiResponse.data as SetUpAccountResponse?;
    String? message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("GetSetUpAccountWidget : ${setUpAccountResponse?.firstName}");
        await Helper.saveProfileDetails(setUpAccountResponse);
        if (await Helper.saveProfileDetails(setUpAccountResponse))
          print("data saved");
        else
          print("not saved");

        await Helper.savePassword(_passwordController.text);
        await Helper.saveCountry(setUpAccountResponse?.countryName);
        await Helper.saveKycStatus(setUpAccountResponse?.kycStatus);
        String? password = await Helper.getPassword();
        print("password: ${password}");
        await Helper.getUserDetails();

        Navigator.pushReplacementNamed(context, '/BottomNav');
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
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight * 0.95),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.arrow_back)),
                              SizedBox(
                                height: 15,
                              ),
                              _buildLabelText(context, "${Languages.of(context)?.labelAccountRecovery}", 22,
                                  true, AppColor.TEXT_COLOR),
                              SizedBox(height: 4),
                              _buildLabelText(
                                  context,
                                  "${Languages.of(context)?.labelPleaseEnterMobileEmailEmirateID}",
                                  11,
                                  false,
                                  AppColor.TEXT_COLOR),
                              SizedBox(height: 25),
                              _buildPhoneInput(
                                  context,
                                  "${Languages.of(context)?.labelEmailMobileEmiratesId}",
                                  _nameController,
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _buildLabelText(
                                      context,
                                      "${Languages.of(context)?.labelMobileNoEg}",
                                      11,
                                      false,
                                      Colors.grey),
                                ],
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 28.0),
                            child: CustomButtonComponent(text: "${Languages.of(context)?.labelContinue}",
                                isDarkMode: isDarkMode,
                                screenWidth: screenWidth,
                                onTap: () {
                                  hideKeyBoard();
                                  Navigator.pushNamed(context, "/BottomNav");
                                }),
                          ),
                        ],
                      )),
                ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
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

  _buildLabelText(
      BuildContext context, String text, int size, bool isBold, Color grey) {
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
    return Card(
      elevation: 0,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 0.2, color: Colors.grey)),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 12.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9@._]'),
                  ),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey)
                    //icon: icon,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
