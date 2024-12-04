import 'package:BDPass/model/response/checkCustomerReponse.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/checkCustomerRequest.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  bool inputValid = false;
  String? phoneNo;
  String? selected = "All Documents";
  bool isIssued = false;
  bool isSearch = false;
  String? username;
  bool isRecentDataEmpty = true;
  final TextEditingController _searchController = TextEditingController();
  final ConnectivityService _connectivityService = ConnectivityService();
  final ScrollController _scrollController = ScrollController();
  late bool isDarkMode;
  List<String> list = [
    "Driving License",
    "Emirate ID card",
    "Residence Visa",
    "Emirate ID card",
    "Residence Visa",
    "Emirate ID card",
    "Residence Visa",
    "Emirate ID card",
    "Residence Visa"
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> initiateCheckCustomerResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CheckCustomerResponse? checkCustomerResponse =
        apiResponse.data as CheckCustomerResponse?;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("pushNamed ${checkCustomerResponse?.username}");
        Navigator.pushNamed(context, '/TransferScreen',
            arguments: checkCustomerResponse);
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNav");
      },
      child: GestureDetector(
        onTap: () => hideKeyBoard(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness:
                        isDarkMode ? Brightness.light : Brightness.dark),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Documents",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      isSearch = !isSearch;
                                    });
                                    },
                                  child: Icon(
                                    Icons.search_outlined,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.transfer_within_a_station_outlined,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.menu_sharp,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height:isSearch ? 5 : 12,
                        ),
                        isSearch ?
                        Row(
                          children: [
                            _buildSearch(),
                            GestureDetector(onTap:(){
                              setState(() {
                                isSearch = false;
                              });
                            },
                                child: Icon(Icons.cancel_outlined,color: Colors.grey,))
                          ],
                        ) :SizedBox(),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey, width: 0.6)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isIssued = true;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                        color: isIssued
                                            ? AppColor.PRIMARY
                                            : Colors.white,
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Issued",
                                        style: TextStyle(
                                            color: isIssued
                                                ? Colors.white
                                                : AppColor.PRIMARY),
                                      ))),
                                )),
                                Container(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isIssued = false;
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.only(
                                                topRight:
                                                    Radius.circular(8),
                                                bottomRight:
                                                    Radius.circular(8),
                                              ),
                                              color: !isIssued
                                                  ? AppColor.PRIMARY
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                                child: Text("Uploaded",
                                                    style: TextStyle(
                                                        color: !isIssued
                                                            ? Colors.white
                                                            : AppColor
                                                                .PRIMARY)))))),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTab(
                                  Icons.file_copy_sharp, "All Documents"),
                              _buildTab(Icons.person_outline_outlined,
                                  "Personal"),
                              _buildTab(Icons.local_post_office_outlined,
                                  "Professional"),
                              _buildTab(Icons.padding_outlined, "Legal"),
                              _buildTab(
                                  Icons.home_work_outlined, "Property"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "7 issued documents under 'All Documents'",
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: isSearch ? screenHeight*0.56 :screenHeight*  0.62,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: list.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return _buildCard(list[index]);
                            },
                          ),
                        ),
                        _buildFooter(
                          context: context,
                          text: 'Request a document',
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
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
      ),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = text;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 4, top: 2, bottom: 2),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.6),
            color: selected == text ? AppColor.PRIMARY : Colors.white),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected == text ? Colors.white : AppColor.PRIMARY),
            SizedBox(
              width: 2,
            ),
            Text(
              "$text",
              style: TextStyle(
                  fontSize: 11,
                  color: selected == text ? Colors.white : AppColor.PRIMARY),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      elevation: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Valid until 10 Dec 2026",
                  style: TextStyle(fontSize: 10, color:isDarkMode ? Colors.grey[300] : AppColor.PRIMARY),
                ),
                SizedBox(
                  height: 1,
                ),
                Text("$text", style: TextStyle(fontSize: 13)),
                Text("Ministry of Interior",
                    style: TextStyle(
                        fontSize: 10,
                        color:isDarkMode ? Colors.grey : Colors.black45,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(
              Icons.keyboard_control_outlined,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 43,
      width: screenWidth*0.8,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: TextStyle(
          fontSize: 14.0,
        ),
        obscureText: false,
        obscuringCharacter: "*",
        controller: _searchController,
        onChanged: (value) {
          //_isValidInput();
        },
        onSubmitted: (value) {},
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildFooter(
      {required BuildContext context,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: screenWidth * 0.94,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.8),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchData(String userSelected) async {
    //_isValidInput();
    const maxDuration = Duration(seconds: 2);
    hideKeyBoard();

    if (userSelected.isNotEmpty &&
        userSelected.length > 8 &&
        userSelected.length < 20) {
      setState(() {
        isLoading = true;
      });

      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Languages.of(context)!.labelNoInternetConnection),
              duration: maxDuration,
            ),
          );
        });
      } else {
        String user = userSelected;

        phoneNo = null;
        username = user;
        CheckCustomerRequest request =
            CheckCustomerRequest(username: username, phoneNo: phoneNo);
        /*      await Provider.of<MainViewModel>(context, listen: false)
            .checkCustomerByUsername(
                "api/v1/app/customers/check_customer_by_username", request);*/
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        initiateCheckCustomerResponse(context, apiResponse);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Languages.of(context)!.labelPleaseEnterValidDetails),
        duration: maxDuration,
      ));
    }
  }
}
