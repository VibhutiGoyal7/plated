import 'package:Payrio/model/request/initiateP2PRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../languageSection/Languages.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool inputValid = true;
  bool isComingSoon = true;
  String amount = "0.00";
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late double screenWidth;
  late double screenHeight;

  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "100",
    "200",
    "300",
    "400",
    "500"
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    DateTime? lastBackPressed;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (kDebugMode) {
          print("$didPop");
          final now = DateTime.now();
          const maxDuration = Duration(seconds: 2);
          final isWarning = lastBackPressed == null ||
              now.difference(lastBackPressed!) > maxDuration;

          if (isWarning) {
            lastBackPressed = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: maxDuration,
              ),
            );
            SystemNavigator.pop();
            //return Future.value(false);
          } else {
            SystemNavigator.pop();
          }
          // return Future.value(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: isComingSoon ? Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.labelMoneyTransfer,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  Languages.of(context)!.labelEnterAmount,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            _checkInputValidation();
                          },
                          maxLength: 12,
                          textAlign: TextAlign.center,
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
                    /*Text(
                      Languages.of(context)!.labelINR,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),*/
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${Languages.of(context)!.labelBalance}: 7,000 ${Languages.of(context)!.labelINR}",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),
                ),
                SizedBox(height: 22,),
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
                              0.18, // Adjust width as needed
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
                SizedBox(height: 10),
                Spacer(),
                Card(
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
                                _buildPhoneInput(context, _usernameController)
                              ],
                            ),
                          ),
                         /* Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              Languages.of(context)!.labelChange,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.blueAccent),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFooter(context),
                SizedBox(height: 10)
              ],
            ),
          ) : Center(
            child: Text(Languages.of(context)!.labelComingSoon, style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                //print(_amountController.text);
                String user = _usernameController.text;
                _checkInputValidation();
                if (inputValid) {
                  if(isNumeric(user)){
                    InitiateP2PRequest request = InitiateP2PRequest(tpin: "", amount: amount,
                        receiverUsername: null, receiverPhoneNumber: user);
                    Navigator.pushNamed(context, '/TransferTPINScreen',arguments: request);
                  }else{
                  InitiateP2PRequest request = InitiateP2PRequest(tpin: "", amount: amount,
                      receiverUsername: _usernameController.text, receiverPhoneNumber: null);
                  Navigator.pushNamed(context, '/TransferTPINScreen',arguments: request);}

                }
              },
              child: Text(
                Languages.of(context)!.labelProceed,
                style: TextStyle(
                    color: inputValid ? Colors.white : Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      inputValid ? Colors.blueAccent : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  void _checkInputValidation(){
    if(_usernameController.text.isNotEmpty && amount.isNotEmpty){
      inputValid = true;
    }
  }

  bool isNumeric(String s) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(s);
  }

  Widget _buildPhoneInput(BuildContext context,
      TextEditingController nameController) {
    //nameController.text = widget.data as String;
    return Container(
      //height: 60,
      width: screenWidth*0.8,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Expanded(
        child: TextField(
          style: TextStyle(
            fontSize: 14.0,
          ),
          obscureText: false,
          obscuringCharacter: "*",
          controller: nameController,
          onChanged: (value) {
            _checkInputValidation();
          },
          onSubmitted: (value) {},
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid)),
            hintText: "Username or phone number",
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
           // icon: icon,
          ),
        ),
      ),
    );
  }
}
