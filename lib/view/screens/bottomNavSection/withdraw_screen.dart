import 'package:Payrio/model/response/withdrawResponse.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/withdrawRequest.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  bool inputValid = false;
  bool isComingSoon = true;
  String amount = "0.00";
  var countryCurrencySymbol;
  var currentBalance;
  var customerNumber;
  late double screenWidth;
  late double screenHeight;
  final TextEditingController _inputController = TextEditingController();


  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = ["100", "200", "300", "400", "500"];

  @override
  void initState() {
    Helper.getProfileDetails().then((profile){
      customerNumber = profile?.phoneNumber;
    });
    Helper.getUserBalance().then((balance) {
      setState(() {
        currentBalance = balance;
      });
    });
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    DateTime? lastBackPressed;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${Languages.of(context)!.labelWithdraw}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ): SizedBox(),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  Languages.of(context)!.labelEnterAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                _buildPhoneInput(
                    context, Languages.of(context)!.labelZero, _inputController),

                /*   Row(
                  children: [
                    Text(
                      countryCurrencySymbol,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.grey),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 26.0,
                          ),
                          controller: _inputController,
                          onChanged: (value) {
                            amount = value;
                          },
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: Languages.of(context)?.labelZero,
                          ),
                        ),
                      ),
                    ),
                    */
                /*Text(
                        Languages.of(context)!.labelINR,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),*/ /*
                  ],
                ),*/
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${Languages.of(context)!.labelBalance}: ${countryCurrencySymbol}${currentBalance} ",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
                ),
                Container(
                  height: screenHeight * 0.065, // Set the desired height
                  child: ListView.builder(
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
                            _inputController.text = _allLogList[index];
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
                Spacer(),
                /*   Card(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Languages.of(context)!.labelTransferTo,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  Languages.of(context)!.labelName,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              Languages.of(context)!.labelChange,
                              style: TextStyle(
                                  fontSize: 14.0, color: AppColor.PRIMARY),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),*/
                _buildFooter(context),
                SizedBox(height: 10)
              ],
            ),
          )),
        ],
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
          Expanded(
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

  void _isValidInput() {
    //print(input);
    if (_inputController.text.isNotEmpty && _inputController.text.length >= 2) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  Future<Widget> getWithDrawResponse(
      BuildContext context, ApiResponse apiResponse) async {
    WithDrawResponse? withDrawResponse = apiResponse.data as WithDrawResponse?;
    String? message = apiResponse.message;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse}");
        String redirectUrl = "${withDrawResponse?.callbackUrl}";
        print("redirectUrl: ${redirectUrl}");

        _showModal(context, "${withDrawResponse?.requestedAmount}");

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (withDrawResponse?.message == "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
        else {
          _inputController.text = "";
          ToastComponent.showToast(context: context, message: message);
        }
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

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          onPressed: () async {
            print(_inputController.text);
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
                      content: Text('No internet connection'),
                      duration: maxDuration,
                    ),
                  );
                });
              } else {
                WithdrawRequest request = WithdrawRequest(
                    amount: _inputController.text,
                    bankType: "Nagad",
                    custPhone: customerNumber);

                await Provider.of<MainViewModel>(context, listen: false)
                    .withDrawData(
                        "api/v1/app/payment_transactions/withdraw_money_from_wallet",
                        request);

                ApiResponse apiResponse =
                    Provider.of<MainViewModel>(context, listen: false).response;
                getWithDrawResponse(context, apiResponse);
              }
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                  Text('Enter amount.'),
                  duration: maxDuration,
                ),
              );
            }
          },
          child: Text(
            Languages.of(context)!.labelProceed,
            style:
                TextStyle(color: inputValid ? Colors.white : AppColor.PRIMARY),
          ),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              backgroundColor: inputValid ? AppColor.PRIMARY : Colors.white,
              elevation: 3,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(2))),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, String amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              scrollable: true,
              insetPadding: EdgeInsets.all(20),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              content: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/BottomNav");
                    },
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 25,
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.celebration,
                          size: 80,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Awesome!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColor.PRIMARY),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "You withdrawed $countryCurrencySymbol$amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                          width: 50,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Happy Spending!",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
