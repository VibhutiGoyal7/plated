import 'package:Payrio/theme/AppColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../model/services/cloud_firestore_service.dart';

class SupportSelectionScreen extends StatefulWidget {
  @override
  _SupportSelectionScreenState createState() => _SupportSelectionScreenState();
}

class _SupportSelectionScreenState extends State<SupportSelectionScreen> {
  bool isLoading = false;
  String kycStatus = "";
  String amount = "";
  bool expanded = false;
  bool inputValid = false;
  final tokenInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late CloudFirestoreService service;
  int messageCount = 0;
  late Stream<int?> _commentStream;

  @override
  void initState() {
    super.initState();
    inputValid = false;
    service = CloudFirestoreService(FirebaseFirestore.instance);
    //_commentStream = service.getMerchantCount(userId);
    displayUnReadByMerchant("3");
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/ProfileScreen');
            },
          ),
          title: Text(
            "Support Methods",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                //_showPicker(context: context);
                Navigator.pushNamed(context, "/SupportScreen",
                    arguments: "Ticket");
              },
              child: _buildCard(
                  context, "Ticket", Icon(Icons.airplane_ticket), isDarkMode),
            ),
            SizedBox(
              height: 4,
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                width: screenWidth * 0.8,
                color: Colors.grey,
                height: 0.5,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                //_showPicker(context: context);
                Navigator.pushNamed(context, "/LiveChatListScreen");
              },
              child: _buildCard(
                  context, "Live Chat", Icon(Icons.mark_chat_unread_outlined), isDarkMode),
            ),
          ]),
        )));
  }


  void displayUnReadByMerchant(String userId) async {
    int? unReadCount = await service.getUnReadByMerchantCount(userId);
    if (unReadCount != null) {
      setState(() {
        messageCount = unReadCount;
      });
      print("The user has $unReadCount unread messages by the merchant.");
    } else {
      print("Failed to fetch unread messages count.");
    }
  }

  _buildCard(BuildContext context, String title, Icon icon, bool isDarkMode) {
    return Card(
      elevation: 0,
      color: isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
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
                        child: icon,
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
                  title != "Live Chat" ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.call_made_sharp,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 18,
                    ),
                  ) :
                  messageCount > 0 ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                          child: Text("$messageCount", style: TextStyle(
                            color: AppColor.WHITE
                          ),),
                        ),
                      ) :  Padding(
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
