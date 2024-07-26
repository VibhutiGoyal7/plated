import 'package:Payrio/model/request/AddMoneyRequest.dart';
import 'package:Payrio/model/response/AddMoneyResponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';
import 'package:provider/provider.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../model/response/profileResponse.dart';
import '../../theme/AppColor.dart';
import '../../utils/Helper.dart';
import '../../view_model/main_view_model.dart';
import '../component/connectivity_service.dart';
import '../component/session_expired_dialog.dart';

class AddMoneyScreen extends StatefulWidget {
  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  late double screenWidth;
  late double screenHeight;
  String bankName = "abc bank";
  bool isDarkMode = false;
  String username = "";
  String paymentMethod = "Pay2Local";
  String limitAmt = "1000";
  String kycStatus = "";
  String amount = "";
  String? countryCurrencySymbol;
  bool expanded = false;
  bool inputValid = false;
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    _fetchData();
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    super.dispose();

  }

  void _isValidInput() {
    //print(input);
    if (_amountController.text.isNotEmpty &&
        _amountController.text.length >= 2) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  Future<Widget> getAddMoneyResponse(
      BuildContext context, ApiResponse apiResponse) async {
    AddMoneyResponse? addMoneyResponse = apiResponse.data as AddMoneyResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse}");
        String redirectUrl = "${addMoneyResponse?.redirectUrl}";
        print("redirectUrl: ${redirectUrl}");
        Navigator.pushNamed(context, "/WebViewScreen",
            arguments: "${redirectUrl}");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse?.message == "Invalid access token")
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

  Future<bool> _onWillPop() async {
    Navigator.pushNamed(
      context,
      "/BottomNav",
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        print("DashBoard $didPop");
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/BottomNav",
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/BottomNav');
            },
          ),
          title: Text(
            Languages.of(context)!.labelAddMoney,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: Stack(
          children: [
            isLoading?
            Container(
              height: screenHeight,
              width: screenWidth,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ): SizedBox(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.WHITE,
                        backgroundImage: AssetImage(
                          "assets/bank_statement.png",

                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Adding via: ${paymentMethod}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text("${username}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: isDarkMode ? Colors.white70 : Colors.black54)),
                    Text(
                      "Please enter amount to proceed",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    _buildPhoneInput(
                        context, Languages.of(context)!.labelZero, _amountController),
               /*     Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                      child: Text(
                        "Limit : ${limitAmt}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),*/
                    Spacer(),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput(
    BuildContext context,
    String text,
    TextEditingController amountController,
    //TextEditingController nameController, Icon icon
  ) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         /* Text("${countryCurrencySymbol}", style: TextStyle(fontSize: 38, fontWeight: FontWeight.normal,
              color: Colors.grey),),*/
          Container(
            // height: 60,
            width: screenWidth * 0.85,
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 40.0,
              ),
              obscureText: false,
              obscuringCharacter: "*",
              controller: amountController,
              onChanged: (value) {
                _isValidInput();
              },
              maxLength: 6,
              textAlign: TextAlign.center,
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
                _isValidInput();
                print(_amountController.text);
                if (inputValid) {
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
                          Text('No internet connection', style: TextStyle(color: AppColor.WHITE),),
                          duration: maxDuration,
                        ),
                      );
                    });
                  }else {

                    AddMoneyRequest request = AddMoneyRequest(
                        amount: int.parse(_amountController.text));

                    await Provider.of<MainViewModel>(context, listen: false)
                        .addMoneyData(
                        "api/v1/app/payment_transactions/add_money_to_wallet",
                        request);

                    ApiResponse apiResponse =
                        Provider
                            .of<MainViewModel>(context, listen: false)
                            .response;
                    getAddMoneyResponse(context, apiResponse);
                  }

                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor:
                      inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _start(String authorizationToken) async {
    await _logErrors(() async {
      await Jumio.init(authorizationToken, "US");
      final result = await Jumio.start({
        "background": "#AC3D9A",
        "primaryColor": "#FF5722",
        "loadingCircleIcon": "#F2F233",
        "loadingCirclePlain": "#57ffc7",
        "loadingCircleGradientStart": "#EC407A",
        "loadingCircleGradientEnd": "#bc2e41",
        "loadingErrorCircleGradientStart": "#AC3D9A",
        "loadingErrorCircleGradientEnd": "#C31322",
        "primaryButtonBackground": {"light": "#D900ff00", "dark": "#9Edd9E"}
      });
      await _showDialogWithMessage("Jumio has completed. Result: $result");
    });
  }

  Future<void> _logErrors(Future<void> Function() block) async {
    try {
      await block();
    } catch (error) {
      await _showDialogWithMessage(error.toString(), "Error");
    }
  }

  Future<void> _showDialogWithMessage(String message,
      [String title = "Result"]) async {
    print(message);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchKycStatus() async {
    kycStatus = (await Helper.getKycStatus())!;
    if (kycStatus != "verified") {
      Navigator.pushNamed(context, '/VerifyIdentityScreen');
    }
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        username = "${profileDetails?.username}";
      });
    });
    return profileDetails;
  }
}
