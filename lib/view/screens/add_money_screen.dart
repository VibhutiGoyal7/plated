import 'package:flutter/material.dart';
import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';

import '../../languageSection/Languages.dart';

class AddMoneyScreen extends StatefulWidget {
  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputValid = false;
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

  final List<Map<String, dynamic>> items = [
    {'icon': 'assets/united_states_flag_icon.svg', 'label': 'USD'},
    {'icon': 'assets/india_flag_icon.svg', 'label': 'INR'},
  ];

  Map<String, dynamic> selectedItem = {
    'icon': 'assets/united_states_flag_icon.svg',
    'label': 'USD'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelAddMoney,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 1.0,
              child: Container(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 12.0, bottom: 8.0),
              child: Text(
                Languages.of(context)!.labelEnterAmount,
              ),
            ),
           /* Container(
              width: 250.0,
              child: TextFormField(
                controller: tokenInputController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Authorization token'),
              ),
            ),
            ElevatedButton(
              child: Text("Start"),
              onPressed: () {
                _start(tokenInputController.text);
              },
            ),*/
            _buildPhoneInput(
                context, Languages.of(context)!.labelZero, _amountController),
            Spacer(),
            _buildFooter(context),
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: amountController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
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
                _isValidInput();
                print(_amountController.text);
                if (inputValid) {
                  Navigator.pushNamed(context, '/VerifyIdentityScreen');
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
}
