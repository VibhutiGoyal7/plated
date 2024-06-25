import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payrio/view/component/toastMessage.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/shortcutItemList.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  double amount = 0.00;
  String? name = "";
  var imageUrl;
  bool isAmountVisible = false;
  bool isUSDVisible = false;
  late List<bool> _isChecked; // Initialize as late to delay initialization
  late List<Shortcutitemlist>
      _shortcutCardsList; // Initialize as late to delay initialization
  @override
  void initState() {
    super.initState();
    isAmountVisible = true;
    isUSDVisible = false;
    imageUrl = "";
    _fetchData();
    _isChecked = List<bool>.generate(
        5, (index) => false); // Initial setup for 5 checkboxes

    // Initial setup for 5 checkboxes
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _shortcutCardsList = [
      Shortcutitemlist(
          title: Languages.of(context)!.labelTransfer,
          icon: Icons.transfer_within_a_station_sharp,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelAddMoney,
          icon: Icons.add_rounded,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelSend,
          icon: Icons.send,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelExchange,
          icon: Icons.currency_exchange,
          selected: true),
      Shortcutitemlist(
          title: Languages.of(context)!.labelRewards,
          icon: Icons.gif_box,
          selected: false)
    ];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.pushNamed(context, '/ProfileScreen')
                            },
                            child: imageUrl == null || imageUrl == ""
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColor.WHITE,
                                      backgroundImage: AssetImage(
                                        "assets/profile_user.png",
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(imageUrl,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover)),
                          ),
                        ),
                        SizedBox(width: 6), // Add space between avatar and text
                        Text(
                          "${Languages.of(context)!.labelHi}, $name",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.notifications)
                      ],
                    ),
                    SizedBox(height: 6), // Add space between sections
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: AppColor.BODY_COLOR,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                              child: Text(
                                Languages.of(context)!.labelStandard,
                                style: TextStyle(
                                    fontSize: 12.0, color: AppColor.WHITE),
                              ),
                            ),
                            SizedBox(
                                width: 8), // Add space between text and card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Colors.black,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "100",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8), // Add space between text and amount
                    Text(
                      "${isAmountVisible ? amount : "**"}  "
                      "${Languages.of(context)!.labelINR} ",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.labelTotalBalance,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ), // Add space between sections
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              color: Colors.transparent,
                              width: screenWidth,
                              height: screenHeight * 0.12,
                              child: Row(
                                children: [
                                  Card(
                                    color: isDarkMode
                                        ? AppColor.DARK_CARD_COLOR
                                        : AppColor.SHORTCUT_CARD_LIGHT_COLOR,
                                    child: Container(
                                      width: screenWidth * 0.8,
                                      height: screenHeight * 0.12,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: List.generate(
                                            4,
                                            (index) {
                                              return _buildContainer(
                                                  context,
                                                  _shortcutCardsList[index]
                                                      .title,
                                                  _shortcutCardsList[index]
                                                      .icon);
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -8,
                              child: Container(
                                height: screenHeight * 0.05,
                                width: screenHeight * 0.12,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      _showModal(context, _shortcutCardsList);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.of(context)!.labelTotalBalance,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            isAmountVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: isDarkMode ? Colors.white60 : Colors.black45,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                isAmountVisible = !isAmountVisible;
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 5), // Add space between sections
                    Row(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image(
                                    alignment: Alignment.topLeft,
                                    image: AssetImage(
                                        "assets/india_flag_icon.png"),
                                    width: 35,
                                    height: 35,
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        "${Languages.of(context)!.labelINR} "
                                        "${isAmountVisible ? amount : "**"}",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ),

                      SizedBox(width: 8), // Add space between cards
                      isUSDVisible
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image(
                                          alignment: Alignment.topLeft,
                                          image: AssetImage(
                                              "assets/united_states_flag_icon.png"),
                                          width: 35,
                                          height: 60,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              "${Languages.of(context)!.labelUSD} "
                                              "${isAmountVisible ? amount : "**"}",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 0,
                            ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    /*   Row(
                      children: [
                        Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Row(children: [
                                Icon(
                                  Icons.edit,
                                  size: 24,
                                )
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/AddMoneyScreen');
                          },
                          child: Container(
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 6.0),
                                child: Row(children: [
                                  Text(
                                    Languages.of(context)!.labelAddMoney,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 18,
                                  )
                                ]),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  Languages.of(context)!.labelSend,
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Icon(
                                  Icons.send,
                                  size: 16,
                                )
                              ]),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  Languages.of(context)!.labelExchange,
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Icon(
                                  Icons.currency_exchange,
                                  size: 16,
                                )
                              ]),
                            ),
                          ),
                        ))
                      ],
                    ),*/
                    SizedBox(height: 5.0),
                    Text(
                      Languages.of(context)!.labelNews,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
          ),
        ));
  }

  void _showModal(BuildContext context, List<Shortcutitemlist> options) {
    // Initialize _isChecked with false for each option
    _isChecked =
        List<bool>.generate(options.length, (index) => options[index].selected);
    print(_isChecked);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(options.length, (index) {
                  return CheckboxListTile(
                    checkboxShape: CircleBorder(),
                    title: Text(options[index].title),
                    value: _isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[index] = value ?? false;
                      });
                    },
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int selectedCount = _countSelectedItems();
                    if (selectedCount == 4) {
                      print('Number of selected items: $selectedCount');
                      Navigator.of(context).pop();
                    } else {
                      ToastComponent.showToast(
                          context: context, message: "Select minimum 4 items");
                    }
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int _countSelectedItems() {
    return _isChecked.where((item) => item).length;
  }

  _buildContainer(BuildContext context, String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: IconButton(
                onPressed: () => {
                      if (text == Languages.of(context)!.labelTransfer)
                        {}
                      else if (text == Languages.of(context)!.labelSend)
                        {}
                      else if (text == Languages.of(context)!.labelAddMoney)
                        {Navigator.pushNamed(context, '/AddMoneyScreen')}
                      else if (text == Languages.of(context)!.labelExchange)
                        {}
                    },
                icon: Icon(
                  icon,
                  color: AppColor.BLACK,
                  size: 22,
                ))),
        Text(text, style: TextStyle(fontSize: 12))
      ],
    );
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? userDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = userDetails?.firstName == null ? "Name" : userDetails?.firstName;
        imageUrl = userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
      });
      print("${name} ");
    });
    return userDetails;
  }
}
