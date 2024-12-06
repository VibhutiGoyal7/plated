import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/apis/api_response.dart';
import 'package:BDPass/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/response/setUpAccountResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/textfield_component.dart';
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
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100.0,
              centerTitle: false,
              backgroundColor: AppColor.WHITE,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "${Languages.of(context)!.labelAccountRecovery}",
                  style: TextStyle(fontSize: 16),
                ),
                background: Container(
                  color: AppColor.BG_COLOR, // Matches the dynamic app bar color
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildLabelText(
                  context,
                  "${Languages.of(context)?.labelPleaseEnterMobileEmailEmirateID}",
                  11,
                  false,
                  AppColor.TEXT_COLOR),
            )),
            SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildPhoneInput(
                  context,
                  "${Languages.of(context)?.labelEmailMobileEmiratesId}",
                  _nameController,
                  Icon(
                    Icons.person,
                    size: 15,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
            )),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  _buildLabelText(
                      context,
                      "${Languages.of(context)?.labelMobileNoEg}",
                      11,
                      false,
                      Colors.grey),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: screenHeight * 0.5,
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: CustomButtonComponent(
                      text: "${Languages.of(context)?.labelContinue}",
                      isDarkMode: isDarkMode,
                      screenWidth: screenWidth,
                      onTap: () {
                        hideKeyBoard();
                        Navigator.pushNamed(context, "/BottomNav");
                      }),
                ),
              ),
            ),
          ],
        )
        /*SafeArea(
        child: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: Stack(
            children: [
              ConstrainedBox(
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
                                child: Icon(Icons.arrow_back_ios)),
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
                            TextfieldComponent(width: 1,
                                  isPhone:false,
                                  textController: _nameController,
                                  icon:Icon(
                                    Icons.person,
                                    size: 20,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ) ,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9@._]'),
                                    ),
                                  ],
                                  text: "${Languages.of(context)?.labelEmailMobileEmiratesId}",
                                  onChanged: (){}),
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
      ),*/
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

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
