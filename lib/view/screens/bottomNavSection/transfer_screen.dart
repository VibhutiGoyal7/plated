import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/createOtpChangePassResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/connectivity_service.dart';

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
  var countryBalance;
  final TextEditingController _inputController = TextEditingController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  late double screenWidth;
  late double screenHeight;

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = ["100", "200", "300", "400", "500"];
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
        countryBalance = balance;
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
        appBar: AppBar(
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
          title:  Text(
            Languages.of(context)!.labelMoneyTransfer,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.0),
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
                            height: 48,
                            width: 48,
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
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  // You can return any widget here to display in case of an error
                                  return Container(
                                    height: 48,
                                    width: 48,
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
                                        height:48,
                                        width: 48,
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
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                                      amount = value;
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
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),*/
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          countryCurrencySymbol != null
                              ? Text(
                                  "${Languages.of(context)!.labelBalance}: ${countryCurrencySymbol}${countryBalance}",
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
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    print("request ${request.receiverPhoneNumber} ${request.receiverUsername}");
                    Navigator.pushNamed(context, '/TransferTPINScreen',
                        arguments: request);
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

  void _checkInputValidation() {
    if (/*_usernameController.text.isNotEmpty &&*/ amount.isNotEmpty) {
      inputValid = true;
    }
  }

  bool isNumeric(String s) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(s);
  }


}
