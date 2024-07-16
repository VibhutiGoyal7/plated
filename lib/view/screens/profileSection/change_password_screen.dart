import 'package:flutter/material.dart';
import 'package:Payrio/model/request/changeOldPasswordRequest.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../theme/AppColor.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/session_expired_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late double screenWidth;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    oldPasswordVisible = true;
    newPasswordVisible = true;
    confirmPasswordVisible = true;
  }

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    final mediaList = apiResponse.data;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse}");

        Navigator.pushNamed(context, '/ProfileScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:

        if(mediaList?.message== "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
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

  bool isLoading = false;
  String? responseMessage;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelChangePass,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10,),
              Image(
                alignment: Alignment.topLeft,
                width: screenWidth*0.6,
               // height: screenHeight*0.45,
                image: AssetImage("assets/change_password.png"),
              ),

              SizedBox(height: 10,),
              _buildPasswordInput(
                  context,
                  Languages.of(context)!.labelOldPass,
                  _oldPasswordController,
                  Icon(
                    Icons.password,
                    size: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  oldPasswordVisible,
                  isDarkMode),
              _buildPasswordInput(
                  context,
                  Languages.of(context)!.labelNewPass,
                  _newPasswordController,
                  Icon(
                    Icons.password,
                    size: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  newPasswordVisible,
                  isDarkMode),
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
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ForgotPasswordScreen');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Languages.of(context)!.labelForgotPass,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22),
             _buildFooter(context)
            ],
          ),
        ),
      ),
    );
  }

  bool _isButtonEnabled() {
    return _oldPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: screenWidth*0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _isButtonEnabled();
                if (_isButtonEnabled()) {

                  print(_newPasswordController.text);
                  CustomerChangePassDetail customer =
                  CustomerChangePassDetail(
                      password: _oldPasswordController.text,
                      newPassword: _newPasswordController.text);

                  ChangeOldPassRequest request =
                  ChangeOldPassRequest(customer: customer);

                  await Provider.of<MainViewModel>(context, listen: false)
                      .changeOldPasswordData(
                      "/api/v1/app/customers/update_password_with_old_password",
                      request);
                  ApiResponse apiResponse =
                      Provider.of<MainViewModel>(context, listen: false)
                          .response;
                  getMediaWidget(context, apiResponse);
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: _isButtonEnabled() ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor:
                  _isButtonEnabled() ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape:
                  BeveledRectangleBorder(borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),

      ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
      child: Card(
        child: Container(
          //height: 60,
          width: screenWidth*0.92,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 15.0),
                  obscureText: passwordVisibles,
                  obscuringCharacter: "*",
                  controller: nameController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {},
                  onSubmitted: (value) {},
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                    icon: icon,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisibles
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (text == Languages.of(context)!.labelOldPass) {
                              oldPasswordVisible = !oldPasswordVisible;
                            } else if (text ==
                                Languages.of(context)!.labelNewPass) {
                              newPasswordVisible = !newPasswordVisible;
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
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    CustomerChangePassDetail customer = CustomerChangePassDetail(
        password: _oldPasswordController.text,
        newPassword: _newPasswordController.text);
    ChangeOldPassRequest request = ChangeOldPassRequest(customer: customer);
    await Provider.of<MainViewModel>(context, listen: false)
        .changeOldPasswordData(
            "/api/v1/app/customers/update_password_with_old_password", request);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }
}
