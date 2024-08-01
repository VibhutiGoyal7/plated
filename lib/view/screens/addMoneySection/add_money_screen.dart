import 'package:Payrio/model/request/AddMoneyRequest.dart';
import 'package:Payrio/model/response/AddMoneyResponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class AddMoneyScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  AddMoneyScreen({Key? key, this.data}) : super(key: key);

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
  String? currentBalance;
  bool expanded = false;
  bool inputValid = false;
  List<String> _allLogList = ["50", "100", "200", "300", "500"];
  final ScrollController _scrollController = ScrollController();
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
    Helper.getUserBalance().then((balance) {
      setState(() {
        currentBalance = balance!;
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
        //Navigator.pushNamed(context, "/WebViewScreen", arguments: "${redirectUrl}");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (apiResponse.message == "Invalid access token")
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        hideKeyBoard();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        /* appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              hideKeyBoard();
              await Future.delayed(Duration(milliseconds: 2));
              Navigator.pushNamed(context, '/PaymentMethodScreen');
            },
          ),
          title: Text(
            "${widget.data}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),*/
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: screenHeight * 0.35,
                              child: Image(
                                height: screenHeight * 0.35,
                                image: AssetImage(isDarkMode
                                    ? "assets/header_night.png"
                                    : "assets/header.png"),
                                fit: isDarkMode ? BoxFit.cover : BoxFit.fill,
                                opacity: isDarkMode
                                    ? const AlwaysStoppedAnimation(.5)
                                    : const AlwaysStoppedAnimation(.9),
                              ),
                              alignment: AlignmentDirectional.center,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.35,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: isDarkMode
                                          ? AppColor.WHITE
                                          : AppColor.PRIMARY,
                                    ),
                                    onPressed: () async {
                                      hideKeyBoard();
                                      await Future.delayed(
                                          Duration(milliseconds: 2));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${widget.data}",
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
                                        width: screenWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Balance",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${addCurrencySymbol(countryCurrencySymbol, "${currentBalance}")}",
                                              style: TextStyle(
                                                fontSize: 26.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //alignment: AlignmentDirectional.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        /* Container(
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
                  */
                        SizedBox(
                          height: 10,
                        ),
                        _buildPhoneInput(context, Languages.of(context)!.labelZero,
                            _amountController),

                        Container(
                          height: screenHeight * 0.065,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center, // Set the desired height
                          child:
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: _allLogList.length,
                            padding: const EdgeInsets.only(bottom: 10),
                            // Adjust padding if needed
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _amountController.text = _allLogList[index];
                                    _isValidInput();
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.2, // Adjust width as needed
                                  margin: EdgeInsets.all(4),
                                  child: Card(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          _allLogList[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //Spacer(),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: _buildFooter(context),
                        )
                      ],
                    ),

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
                    controller: amountController,
                    onChanged: (value) {
                      _isValidInput();
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
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }

  /*Future<void> _start(String authorizationToken) async {
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
*/
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
