import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
import '../../utils/Util.dart';

class RequestQrScreen extends StatefulWidget {
  @override
  _RequestQrScreenState createState() => _RequestQrScreenState();
}

class _RequestQrScreenState extends State<RequestQrScreen> {
  late double screenWidth;
  late double screenHeight;
  String phoneCode = "+";
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

  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    isValid = false;
    phoneNumberValid = false;
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
    double screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Request QR",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        //backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        alignment: Alignment.topLeft,
                        //width: screenWidth*0.8,
                        height: screenHeight * 0.2,
                        image: AssetImage("assets/requestQR.png"),
                      ),
                    ),
                    _buildAddMoneyInput(context, "0.00"),
                    _buildFooter(context)
                  ],
                ),
              ),
            ),
            isLoading
                ? Stack(
                    children: [
                      // Block interaction
                      ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.3)),
                      // Loader indicator
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    ]);
  }

  void isInputValid() {
   // String otp = _controllers.map((controller) => controller.text).join();
    if (_amountController.text.isNotEmpty && _amountController.text.length>=1 ) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  Widget _buildAddMoneyInput(
    BuildContext context,
    String text,
    //TextEditingController amountController,
    //TextEditingController nameController, Icon icon
  ) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Add Money",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
              ),
              Card(
                child: Container(
                  height: 55,
                  width: screenWidth * 0.88,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border(
                        right: BorderSide(width: 0.2),
                        top: BorderSide(width: 0.250),
                        bottom: BorderSide(width: 0.2),
                        left: BorderSide(width: 0.2),
                      )),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    obscureText: false,
                    autofocus: true,
                    obscuringCharacter: "*",
                    controller: _amountController,
                    onChanged: (value) {
                      setState(() {
                        _amountController.text = value;
                      });
                      isInputValid();
                    },
                    /*   inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // This allows only digits (0-9)
                    ],*/
                    maxLength: 6,
                    textAlign: TextAlign.left,
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: text,
                        hintStyle: TextStyle(color: Colors.grey),
                        alignLabelWithHint: true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.7,
            child: ElevatedButton(
              onPressed: () async {
                hideKeyBoard();
                isInputValid();
                print(_amountController.text);
                /*if (isValid) {
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
                            'No internet connection',
                            style: TextStyle(color: AppColor.WHITE),
                          ),
                          duration: maxDuration,
                        ),
                      );
                    });
                  } else {
                    AddMoneyRequest request = AddMoneyRequest(
                        amount: int.parse(_amountController.text));

                    await Provider.of<MainViewModel>(context, listen: false)
                        .addMoneyData(
                        "api/v1/app/payment_transactions/add_money_to_wallet",
                        request);

                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    getAddMoneyResponse(context, apiResponse);
                  }
                }*/
              },
              child: Text(
                "Generate QR",
                style:
                    TextStyle(color: isValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: isValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }
}
