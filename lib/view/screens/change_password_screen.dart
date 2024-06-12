import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_flutter_app/model/changeOldPasswordRequest.dart';
import 'package:provider/provider.dart';

import '../../Strings/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../utils/Helper.dart';
import '../../view_model/media_view_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
  }

  Future<Widget> getMediaWidget(BuildContext context, ApiResponse apiResponse) async {
    //ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${apiResponse?.data}");

        // Defer the state update until the next frame

        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/AccountDetailScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  bool isLoading = false;
  String? responseMessage;


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    Languages.of(context)!.labelChangePass,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //color: Theme.of(context).colorScheme.secondary.withAlpha(50),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              _buildPasswordInput(
                  context,
                  Languages.of(context)!.labelOldPass,
                  _oldPasswordController,
                  Icon(Icons.password,
                      size: 18
                  ),
                  passwordVisible,
                  isDarkMode),
              _buildPasswordInput(
                  context,
                  Languages.of(context)!.labelNewPass,
                  _newPasswordController,
                  Icon(Icons.password,
                      size: 18,
                      ),
                  passwordVisible,
                  isDarkMode),
              _buildPasswordInput(
                  context,
                  Languages.of(context)!.labelConfirmPass,
                  _confirmPasswordController,
                  Icon(Icons.password,
                      size: 18,),
                  passwordVisible,
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
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: ()async {
                    print(_newPasswordController.text);
                CustomerChangePassDetail customer = CustomerChangePassDetail
                (password: _oldPasswordController.text, newPassword: _newPasswordController.text);

                ChangeOldPassRequest request = ChangeOldPassRequest(customer: customer);

                await Provider.of<MediaViewModel>(context, listen: false)
                    .changeOldPasswordData("/api/v1/app/customers/update_password_with_old_password",request);
                ApiResponse apiResponse =
                Provider.of<MediaViewModel>(context, listen: false).response;
                getMediaWidget(context, apiResponse);
                  }
                      ,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      _isButtonEnabled()
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(Languages.of(context)!.labelProceed),
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

  bool _isButtonEnabled() {
    return _oldPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  Widget _buildPasswordInput(
      BuildContext context,
      String text,
      TextEditingController nameController,
      Icon icon,
      bool passwordVisibles
      , bool isDarkMode,
      ) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 16.0),
              obscureText: passwordVisibles,
              obscuringCharacter: "*",
              controller: nameController,
              onChanged: (value) {},
              onSubmitted: (value) {},
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(color: Colors.grey),
                icon: icon,
                suffixIcon: IconButton(
                  icon: Icon(passwordVisibles
                      ? Icons.visibility
                      : Icons.visibility_off,
                    size: 20,),
                  onPressed: () {
                    setState(
                          () {
                        if (text == "Password") {
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
  Future<void> _changePassword() async {
    CustomerChangePassDetail customer = CustomerChangePassDetail
      (password: _oldPasswordController.text, newPassword: _newPasswordController.text);
    ChangeOldPassRequest request = ChangeOldPassRequest(customer: customer);
    await Provider.of<MediaViewModel>(context, listen: false)
        .changeOldPasswordData("/api/v1/app/customers/update_password_with_old_password",request);
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }
}
