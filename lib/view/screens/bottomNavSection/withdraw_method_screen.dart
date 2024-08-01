import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WithdrawMethodScreen extends StatefulWidget {
  @override
  _WithdrawMethodScreenState createState() => _WithdrawMethodScreenState();
}

class _WithdrawMethodScreenState extends State<WithdrawMethodScreen> {
  bool isLoading = false;
  String kycStatus = "";
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(
      context,
      "/BottomNav",
    );
    return false;
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        print("DashBoard $didPop");
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          _onWillPop();
          // return Future.value(true);
        }
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            toolbarHeight: 65,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/BottomNav');
              },
            ),
            title: Text(
              "Withdraw Methods",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      //_showPicker(context: context);
                      Navigator.pushNamed(context, "/WithdrawMethodTypeScreen",
                          arguments: "Local Distributors");
                    },
                    child: _buildCard(context, "Local Distributors",
                        "assets/bank_statement.png", isDarkMode),
                  )
                ]),
              ))),
    );
  }

  _buildCard(BuildContext context, String title, String icon, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        child: isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.white38,
          highlightColor: Colors.grey,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(
                  8.0), // Adjust the radius as needed
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  child: Image(
                    alignment: Alignment.topLeft,
                    width: 25,
                    image: AssetImage(icon),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.call_made_sharp,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('A Bank'),
                onTap: () {
                  //getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/AddMoneyScreen");
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('B Bank'),
                onTap: () {
                  //getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/AddMoneyScreen");
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
