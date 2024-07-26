import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/completeP2PRequest.dart';
import '../../../model/response/createOtpChangePassResponse.dart';
import '../../../model/response/initiateP2PResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class TransferScreen extends StatefulWidget {
  final CheckCustomerResponse? data;

  TransferScreen({required this.data});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool inputValid = true;
  bool isComingSoon = true;
  String amount = "0.00";
  var userName;
  bool isDarkMode = false;
  var name;
  var phoneNo;
  var imageUrl;
  var countryCurrencySymbol;
  String countryBalance = "";
  final TextEditingController _inputController = TextEditingController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  late double screenWidth;
  late double screenHeight;

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = ["100", "200", "300", "400", "550"];
  @override
  void initState() {
    super.initState();
    inputValid = false;
    userName = widget.data?.username;
    name = "${widget.data?.fullName}";
    phoneNo = "${widget.data?.phoneNumber}";
    imageUrl = "${widget.data?.imageUrl}";
    print("object ${userName}");
    Helper.getUserBalance().then((balance) {
      setState(() {
        countryBalance = balance!;
      });
    });
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        countryCurrencySymbol = symbol;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    DateTime? lastBackPressed;
    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(toolbarHeight: 65,
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 24,),
        ),
          title:  Text(
            Languages.of(context)!.labelMoneyTransfer,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18.0),
          ),
        ),
        body: Stack(
          children: [

            SafeArea(
              child: isComingSoon
                  ? Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          imageUrl == null
                              ? Container(
                            height: 55,
                            width: 55,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColor.WHITE,
                              backgroundImage:
                              AssetImage("assets/profile_user.png"),
                            ),
                          )
                              : ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                imageUrl,
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  // You can return any widget here to display in case of an error
                                  return Container(
                                    height: 55,
                                    width: 55,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColor.WHITE,
                                      backgroundImage: AssetImage(
                                        "assets/profile_user.png",
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white38,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        height:55,
                                        width: 55,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Paying: ${name}",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),Text(
                            "${userName}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                         /* Text("${phoneNo}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: isDarkMode ? Colors.white70 : Colors.black54)),*/
                          SizedBox(height: 10,),
                          Text(
                            "Please enter amount",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*Text("${countryCurrencySymbol}", style: TextStyle(fontSize: 38, fontWeight: FontWeight.normal,
                                  color: Colors.grey),),*/
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    style: TextStyle(
                                      fontSize: 38.0,
                                    ),
                                    controller: _inputController,
                                    onChanged: (value) {
                                  /*    int balance = extractNumber(countryBalance) - extractNumber(amount);
                                      print(balance);*/
                                      setState(() {
                                        amount = value;
                                       // countryBalance = balance as String ;
                                      });
                                      _checkInputValidation();
                                    },
                                    maxLength: 12,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {

                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: Languages.of(context)?.labelZero,
                                    ),
                                  ),
                                ),
                              ),
                              /*Text(
                          Languages.of(context)!.labelINR,
                          style:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                        ),*/
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          countryCurrencySymbol != null
                              ? Text(

                                  "${Languages.of(context)!.labelBalance}: ${addCurrencySymbol(countryCurrencySymbol , countryBalance)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0),
                                )
                              : Text(""),
                          SizedBox(
                            height: 20,
                          ),
                          /*Container(
                            height:
                                screenHeight * 0.065, // Set the desired height
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
                                        0.16, // Adjust width as needed
                                    margin: EdgeInsets.all(4),
                                    child: Card(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            _allLogList[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),*/
                          Spacer(),
                          _buildFooter(context),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        Languages.of(context)!.labelComingSoon,
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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



  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                //print(_amountController.text);
                //String user = userName;
                _checkInputValidation();
                if (inputValid) {
                  InitiateP2PRequest request = InitiateP2PRequest(
                      tpin: "",
                      amount: amount,
                      receiverUsername: userName,
                      receiverPhoneNumber: phoneNo,
                      fullName:widget.data?.fullName, imageUrl: widget.data?.imageUrl);
                  _initiateTransaction();

                   /* print("request ${request.receiverPhoneNumber} ${request.receiverUsername}");
                    Navigator.pushNamed(context, '/TransferTPINScreen',
                        arguments: request);*/
                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initiateTransaction() async {
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
      InitiateP2PRequest request = InitiateP2PRequest(tpin: "", amount: amount,
        receiverUsername: null, receiverPhoneNumber: phoneNo,  );
      print("phno ${request.receiverPhoneNumber}");
      print("username ${request.receiverUsername}");
      await Provider.of<MainViewModel>(context, listen: false)
          .initiateP2PTransaction(
          "/api/v1/app/payment_transactions/initiate_p2p_transaction",
          request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false)
              .response;
      initiateTransactionResponse(context, apiResponse);
    }
  }

  Future<Widget> initiateTransactionResponse(
      BuildContext context, ApiResponse apiResponse) async {
    InitiateP2PResponse? initiateP2PResponse =
    apiResponse.data as InitiateP2PResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("TPIN ${initiateP2PResponse?.otp}");
        if(initiateP2PResponse?.otp!=null){
          ToastComponent.showToast(
              context: context, message: initiateP2PResponse?.otp);
        }else {
          ToastComponent.showToast(
              context: context, message: message);
        }
        CompleteP2PRequest data = CompleteP2PRequest(
            paymentTransactionId: initiateP2PResponse?.paymentTransactionId,
            customerOtpId: initiateP2PResponse?.customerOtpId,
            amount: amount,
            receiverUsername: userName,
            receiverPhoneNumber: phoneNo,
            fullName:name,
            imageUrl: ""
        );

        /*InitiateP2PRequest data1 = InitiateP2PRequest(tpin: '', amount: widget.data?.amount,
          receiverUsername: widget.data?.receiverUsername, receiverPhoneNumber: widget.data?.receiverPhoneNumber,);*/

        Navigator.pushNamed(context, '/TransferOtpScreen', arguments: data);
        // Navigate to the new screen after receiving the response
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

  void _checkInputValidation() {
    if (_inputController.text.length >=1 && amount.isNotEmpty && isBalanceMoreThanAmount(countryBalance, amount, context)) {
      setState(() {
        inputValid = true;

      });
    }else {
      setState(() {
        inputValid = false;
      });

    }
  }

  int extractNumber(String str) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(str);
    if (match != null) {
      return int.parse(match.group(0)!);
    } else {
      throw FormatException('No number found in the string');
    }
  }

  bool isNumeric(String s) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(s);
  }


}
