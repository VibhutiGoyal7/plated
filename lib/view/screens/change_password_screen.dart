import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? responseMessage;

  void _handleChangePassword() {
    setState(() {
      isLoading = true;
    });

    // Simulate an async operation for changing the password
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        responseMessage = "Password changed successfully!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              _buildPasswordTextField(
                controller: _oldPasswordController,
                label: 'Old Password*',
                placeholder: 'Enter Password',
              ),
              _buildPasswordTextField(
                controller: _newPasswordController,
                label: 'New Password*',
                placeholder: 'Enter your Password',
              ),
              _buildPasswordTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password*',
                placeholder: 'Enter Password Again',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/ForgotPasswordScreen');
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isButtonEnabled()
                      ? _handleChangePassword
                      : null,
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
                      child: Text('Proceed'),
                    ),
                  ),
                ),
              ),
              if (isLoading) CircularProgressIndicator(),
              if (responseMessage != null)
                Text(
                  responseMessage!,
                  style: TextStyle(
                    color: responseMessage!.contains('successfully') ? Colors.green : Colors.red,
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

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        obscureText: true,
      ),
    );
  }
}
