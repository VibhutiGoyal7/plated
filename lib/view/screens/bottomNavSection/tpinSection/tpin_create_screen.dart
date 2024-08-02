import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../component/customNumberKeyboard.dart';

class TpinCreateScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  TpinCreateScreen({Key? key, this.data}) : super(key: key);

  @override
  _TpinCreateScreenState createState() => _TpinCreateScreenState();
}

class _TpinCreateScreenState extends State<TpinCreateScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  String phoneNo = "";
  late double screenWidth;
  List<String> _inputValues = ['', '', '', ''];

  void _handleKeyTap(String value) {
    setState(() {
      for (int i = 0; i < _inputValues.length; i++) {
        if (_inputValues[i].isEmpty) {
          _inputValues[i] = value;
          break;
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      for (int i = _inputValues.length - 1; i >= 0; i--) {
        if (_inputValues[i].isNotEmpty) {
          _inputValues[i] = '';
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isValid = false;
    resendOtp = false;
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight * 0.15,
              margin: EdgeInsets.zero,
              child: _buildLabelText(context, "Transaction \nPIN ", 28, true),
              alignment: AlignmentDirectional.center,
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.72,
                margin: EdgeInsets.zero,
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: _buildLabelText(
                            context, "Enter 4 digit TPIN", 20, true),
                      ),
                      SizedBox(height: 22),
                      _buildPhoneInput(context, screenWidth, isDarkMode),
                      SizedBox(height: 10),
                      Spacer(),
                      CustomNumberKeyboard(onKeyTap: (value) async {
                        if (value == "clear") {
                          _handleBackspace();
                        } else if (value == "submit") {
                          String otp = _inputValues
                              .map((controller) => controller)
                              .join();
                          if (otp.isNotEmpty && otp.length == 4) {
                            Navigator.of(context).pushNamed("/TpinVerifyScreen",
                                arguments: "${otp}");
                          }
                        } else {
                          _handleKeyTap(value);
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput(
      BuildContext context, double screenWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              borderRadius: BorderRadius.circular(6),
            ),
            width: screenWidth / 8.1,
            height: 62.0,
            child: Center(
              child: Text(
                _inputValues[index],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
