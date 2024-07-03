
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../languageSection/Languages.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool isLoading = false;
  String kycStatus = "";
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
    "Add money",
  ];
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${Languages.of(context)!.labelTransaction}s",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      //height: screenSize.height/2,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: _allLogList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Card(
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    width: 0,
                                                    color: Colors.blue)),
                                            color: Colors.blue,
                                            child: Icon(
                                              Icons.wallet,
                                              color: Colors.white,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _allLogList[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text("From Google Pay",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "+INR 100.00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("05/05/2024",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                            // I omit the part to build card items from the list
                          },
                        ),
                      ),
                    ),
                  ]
              ),
            )
        )
    );
  }

  _buildCard(BuildContext context,  String title,
      String icon,
      bool isDarkMode) {
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
            :Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Image(
                alignment: Alignment.topLeft,
                width: 25,
                image: AssetImage(icon),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.call_made_sharp,color: isDarkMode ? Colors.white :Colors.black,size: 18,),
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