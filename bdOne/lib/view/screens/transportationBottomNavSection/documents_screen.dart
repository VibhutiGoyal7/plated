import 'package:BDOne/model/response/checkCustomerReponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/view/component/search_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/checkCustomerRequest.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_loader.dart';
import '../../component/fixed_header_delegate.dart';
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
  String? selected = "";
  bool isIssued = false;
  bool isSearch = false;
  bool isPinVerified = false;
  String selectedHeading = "Issued";
  List<String> heading = ["Issued", "Uploaded"];
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
    setState(() {
      selected = "All Documents";
    });
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
        return Center(child: CustomLoader());
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
        child: SafeArea(
          bottom: false,
          minimum: EdgeInsets.only(bottom: 70),
          child: Scaffold(
            body:  Stack(
                    children: [
                      AnnotatedRegion<SystemUiOverlayStyle>(
                        value: SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness:
                              isDarkMode ? Brightness.light : Brightness.dark,
                          statusBarBrightness:
                              isDarkMode ? Brightness.dark : Brightness.light,
                        ),
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            CupertinoSliverNavigationBar(
                              largeTitle: Text(
                                "${Languages.of(context)?.labelDocuments}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
                                ),
                              ),
                              middle: Text(
                                "${Languages.of(context)?.labelDocuments}",
                                style: TextStyle(fontSize: 22,
                                    color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
                              ),
                              backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                              // Control the color
                              trailing: Container(
                                width: screenWidth * 0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.transfer_within_a_station_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.menu_sharp,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                              alwaysShowMiddle: false,
                              leading: SizedBox(),
                            ),
                            SliverPersistentHeader(
                              pinned: isSearch ? true : false,
                              // Keeps the header fixed at the top when scrolling
                              delegate: FixedHeaderDelegate(
                                child: Container(
                                  color:isDarkMode? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                                  // Background color for the fixed header
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: SearchComponent(
                                      width: 1,
                                      screenWidth: screenWidth,
                                      isDarkMode: isDarkMode,
                                      searchController: _searchController,
                                      onChanged: () {}),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                              Border.all(color: Colors.grey, width: 0.6)),*/
                                child: Center(
                                  child: SegmentedButton(
                                    style: SegmentedButton.styleFrom(
                                      fixedSize: Size(screenWidth, 30),
                                      side: BorderSide(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          width: 0.4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 0),
                                      foregroundColor: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      selectedForegroundColor: Colors.white,
                                      selectedBackgroundColor: AppColor.PRIMARY,
                                    ),
                                    segments: [
                                      for (int i = 0; i < heading.length; i++)
                                        ButtonSegment<String>(
                                          value: heading[i],
                                          label: Text(heading[i]),
                                        ),
                                    ],
                                    selected: {selectedHeading},
                                    // Set of selected values
                                    onSelectionChanged: (Set<String> selected) {
                                      setState(() {
                                        // Get the first selected value from the set (assuming only one selection)
                                        selectedHeading = selected.first;
                                      });
                                    },
                                  )

                                  /*Row(
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
                                                "${Languages.of(context)?.labelIssued}",
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
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                              color: !isIssued
                                                  ? AppColor.PRIMARY
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    "${Languages.of(context)?.labelUploaded}",
                                                    style: TextStyle(
                                                        color: !isIssued
                                                            ? Colors.white
                                                            : AppColor
                                                            .PRIMARY)))))),
                              ],
                            )*/
                                  ,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildTab(Icons.file_copy_sharp,
                                          "${Languages.of(context)?.labelAllDocuments}"),
                                      _buildTab(Icons.person_outline_outlined,
                                          "${Languages.of(context)?.labelPersonal}"),
                                      _buildTab(
                                          Icons.local_post_office_outlined,
                                          "${Languages.of(context)?.labelProfessional}"),
                                      _buildTab(Icons.padding_outlined,
                                          "${Languages.of(context)?.labelLegal}"),
                                      _buildTab(Icons.home_work_outlined,
                                          "${Languages.of(context)?.labelProperty}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return _buildCard(list[index]);
                                },
                                childCount: list.length,
                              ),
                            ),
                          ],
                        ),

                        /*SafeArea(
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
                                "${Languages.of(context)?.labelDocuments}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
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
                            height: isSearch ? 5 : 12,
                          ),
                          isSearch ?
                          Row(
                            children: [
                              SearchComponent(width: 0.8, screenWidth: screenWidth, isDarkMode: isDarkMode,
                                  searchController: _searchController, onChanged: (){}),
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
                                border:
                                    Border.all(color: Colors.grey, width: 0.6)),
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
                                          "${Languages.of(context)?.labelIssued}",
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
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ),
                                                color: !isIssued
                                                    ? AppColor.PRIMARY
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      "${Languages.of(context)?.labelUploaded}",
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
                                _buildTab(Icons.file_copy_sharp,
                                    "${Languages.of(context)?.labelAllDocuments}"),
                                _buildTab(Icons.person_outline_outlined,
                                    "${Languages.of(context)?.labelPersonal}"),
                                _buildTab(Icons.local_post_office_outlined,
                                    "${Languages.of(context)?.labelProfessional}"),
                                _buildTab(Icons.padding_outlined,
                                    "${Languages.of(context)?.labelLegal}"),
                                _buildTab(Icons.home_work_outlined,
                                    "${Languages.of(context)?.labelProperty}"),
                              ],
                            ),
                          ),
                          Text(
                            "7${Languages.of(context)?.labelIssuedDocumentsUnder} 'All Documents'",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: isSearch
                                ? screenHeight * 0.52
                                : screenHeight * 0.58,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount: list.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 5),
                              itemBuilder: (BuildContext context, int index) {
                                return _buildCard(list[index]);
                              },
                            ),
                          ),
                          CustomButtonComponent(
                              text:
                                  '${Languages.of(context)?.labelRequestADocument}',
                              screenWidth: screenWidth,
                              isDarkMode: isDarkMode,
                              onTap: () {})
                        ],
                      ),
                    ),
                  ),*/
                      ),
                      isLoading
                          ? Stack(
                              children: [
                                // Block interaction
                                ModalBarrier(
                                    dismissible: false,
                                    color: Colors.transparent),
                                // Loader indicator
                                Center(
                                  child: CustomLoader(),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
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
                  "${Languages.of(context)?.labelValidUntil}10 Dec 2026",
                  style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.grey[300] : AppColor.PRIMARY),
                ),
                SizedBox(
                  height: 1,
                ),
                Text("$text", style: TextStyle(fontSize: 13)),
                Text("Ministry of Interior",
                    style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey : Colors.black45,
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
