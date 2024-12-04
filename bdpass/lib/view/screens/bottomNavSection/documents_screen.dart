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
  String? username;
  bool isRecentDataEmpty = true;
  final ConnectivityService _connectivityService = ConnectivityService();
  final TextEditingController _usernameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<CheckCustomerResponse>? prefResponse = <CheckCustomerResponse>[];
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
                child: Stack(
                  children: <Widget>[
                    /* Container(
                      height: screenHeight * 0.27,
                      child: Column(
                        children: [
                          Image(
                            height: screenHeight * 0.27,
                            image: AssetImage(isDarkMode
                                ? "assets/header_night.png"
                                : "assets/header_day.png"),
                            fit: isDarkMode ? BoxFit.cover : BoxFit.cover,
                            opacity: isDarkMode ? const AlwaysStoppedAnimation(.3) : const AlwaysStoppedAnimation(.45),
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                    ),*/
                    SafeArea(
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
                                    Icon(
                                      Icons.search_outlined,
                                      size: 24,
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
                              height: 12,
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
                                    Text("Issued"),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text("Uploaded"),
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
                            Expanded(
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
                  ],
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
    return Container(
      margin: EdgeInsets.only(right: 4, top: 2, bottom: 2),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.6)),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            "$text",
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      elevation: 4,
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
                  style: TextStyle(fontSize: 10, color: AppColor.PRIMARY),
                ),
                SizedBox(
                  height: 1,
                ),
                Text("$text", style: TextStyle(fontSize: 13)),
                Text("Ministry of Interior",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
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
