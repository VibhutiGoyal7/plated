import 'package:Payrio/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/shortcutItemList.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';

class DashboardHomeScreen extends StatefulWidget {
  @override
  _DashboardHomeScreenState createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  String amount = "0.00";
  String? name = "";
  var imageUrl;
  bool isAmountVisible = true;
  bool isUSDVisible = false;
  late List<bool> _isChecked; // Initialize as late to delay initialization
  late List<Shortcutitemlist>
      _shortcutCardsList; // Initialize as late to delay initialization

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "Add money",
    "Add money",
    "Add money",
    "Add money",
  ];
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    imageUrl = "";

    _isChecked = List<bool>.generate(
        5, (index) => false); // Initial setup for 5 checkboxes
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    String? isoCountryCode = systemLocales.first.languageCode;
    Helper.getProfileDetails().then((userDetails) {
      setState(() {
        print("userDetails?.imageUrl${userDetails?.imageUrl}");
        name = userDetails?.firstName == null ? "Name" : userDetails?.firstName;
        imageUrl = userDetails?.imageUrl == null ? "" : userDetails?.imageUrl;
        print("imageUrl${imageUrl}");
      });
    });
    print("isoCountryCode:: $isoCountryCode");

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
    DateTime? lastBackPressed;
    return WillPopScope(
      onWillPop: () async {
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
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
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
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        imageUrl as String,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          // You can return any widget here to display in case of an error
                                          return Container(
                                            height: 40,
                                            width: 40,
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
                                              baseColor: Colors.black45,
                                              highlightColor: Colors.black87,
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                color: Colors.grey,
                                              ),
                                            );
                                          }
                                        },
                                      )),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Languages.of(context)!.labelStandard,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                      child: Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      )), // Add space between text and card
                                  Text(
                                    "100",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 20,
                                  )
                                ],
                              ),
                              Text(
                                "2900 Points to Silver",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),

                          // Add space between avatar and text
                          /*Text(
                            "${Languages.of(context)!.labelHi}, $name",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),*/

                          Spacer(),
                          IconButton(
                            icon: Icon(
                              isAmountVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  isAmountVisible = !isAmountVisible;
                                },
                              );
                            },
                          ),
                          Icon(Icons.notifications)
                        ],
                      ),
                      // Add space between sections
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Languages.of(context)!.labelTotalBalance,
                                  style: TextStyle(
                                      fontSize: 16.0, letterSpacing: 1.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${isAmountVisible ? amount : "**"}  "
                            "${Languages.of(context)!.labelINR} ",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ), // Add space between text and amount

                      /*  Row(children: [
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
                          height:
                          MediaQuery.of(context).size.height * 0.15,
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
                      ]),*/
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) {
                              return _buildContainer(
                                  context,
                                  _shortcutCardsList[index].title,
                                  _shortcutCardsList[index].icon);
                            },
                          ),
                        ),
                      ),
                      Text(
                        Languages.of(context)!.labelNews,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.25),
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.2,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: _allLogList.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: screenWidth / 2,
                              child: Center(
                                  child: Image.network(
                                imgList[1],
                                fit: BoxFit.cover,
                              )),
                            );
                            // I omit the part to build card items from the list
                          },
                        ),

                        /*CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 0.5,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            ),
                            items: imgList
                                .map((item) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                          child: Image.network(item,
                                              fit: BoxFit.cover, width: 500)),
                                    ))
                                .toList(),
                          )*/
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        //height: screenSize.height/2,
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: _allLogList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
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
                    ]),
              ),
            ),
          )),
    );
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

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quick actions", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10,),
                    Text("Most Frequent", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                Expanded(
                  //height: screenSize.height/2,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _shortcutCardsList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 0),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                            ),
                            child: Icon(_shortcutCardsList[index].icon),),
                          Text(
                            _shortcutCardsList[index].title,
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold,
                              color:    Colors.black,),
                          ),
                        ],
                      );
                    /*    ListTile(
                          leading: ClipRRect(
                            child: Container(
                              padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                                ),
                                child: Icon(_shortcutCardsList[index].icon),)
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _shortcutCardsList[index].title,
                                style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold,
                                  color:    Colors.black,),
                              ),
                              Text("+${_shortcutCardsList[index].title}",
                                  style: TextStyle(fontSize: 12,
                                    color: Colors.black,)),
                            ],
                          ));*/
                      // I omit the part to build card items from the list
                    },
                  ),
                ),
              ],
            ),
          ),
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40.0),
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
                        {
                        _showPicker(context: context)
                        }
                    },
                icon: Icon(
                  icon,
                  color: AppColor.WHITE,
                  size: 28,
                ))),
        Text(text, style: TextStyle(fontSize: 12))
      ],
    );
  }
}
