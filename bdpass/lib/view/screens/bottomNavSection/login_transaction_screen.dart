import 'package:BDPass/model/response/checkCustomerReponse.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class LoginTransactionScreen extends StatefulWidget {
  @override
  _LoginTransactionScreenState createState() => _LoginTransactionScreenState();
}

class _LoginTransactionScreenState extends State<LoginTransactionScreen> {
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  String? selected = "All Entries";
  final ConnectivityService _connectivityService = ConnectivityService();
  final ScrollController _scrollController = ScrollController();
  late bool isDarkMode;
  List<bool> isClicked = [];
  List<String> list = [
    "Successful",
    "Failure",
    "Successful",
    "Failure",
    "Successful",
    "Failure",
  ];

  @override
  void initState() {
    super.initState();
    isClicked = List.generate(list.length, (_) => false);
    setState(() {
      selected = "All Entries";
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
    return Scaffold(
      body:Stack(
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    isDarkMode ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  snap: false,
                  pinned: true,
                  floating: false,
                  expandedHeight: 90.0, // Adjust the expanded height
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppColor.BG_COLOR,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Text(
                      "Login Transactions",
                      style: TextStyle(
                        color: AppColor.TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  backgroundColor: AppColor.BG_COLOR,
                  foregroundColor: AppColor.BG_COLOR,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTab("All Entries"),
                          _buildTab("Successful"),
                          _buildTab("Failure"),
                        ],
                      ),
                    ),
                  ) ,
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          bool isDetailVisible = false;
                      return _buildCard(list[index],index);
                    },
                    childCount: list.length,
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
    );
  }

  Widget _buildTab( String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = text;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 4, top: 2, bottom: 2),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected == text ? AppColor.PRIMARY : Colors.grey, width: 0.6),
            color: selected == text ? AppColor.PRIMARY : Colors.white),
        child: Text(
          "$text",
          style: TextStyle(
              fontSize: 11.5,
              color: selected == text ? Colors.white : AppColor.PRIMARY),
        ),
      ),
    );
  }

  Widget _buildCard(String text,int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isClicked[index] = !isClicked[index];
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Self Service Portal", style: TextStyle(fontSize: 14)),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: text == "Failure" ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.25)
                        ),
                        child: Text("$text",
                            style: TextStyle(
                                fontSize: 10,
                                color: text == "Failure" ? Colors.red : AppColor.PRIMARY,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 5,),
                      Icon(isClicked[index] ? Icons.keyboard_arrow_up  :Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                ],
              ),
              isClicked[index] ?
              Column(
                children: [
                  SizedBox(height: 6,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green.withOpacity(0.4),width: 1),
                          color: Colors.green.withOpacity(0.1)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Self Service Portal",style: TextStyle(fontSize: 13),),
                          Image(
                            height: screenHeight * 0.06,
                            image: AssetImage(isDarkMode
                                ? "assets/app_logo_dark.png"
                                : "assets/app_logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDetail("Logged in","Self Service portal"),
                  Container(width: screenWidth,height: 0.2,color: Colors.grey,),
                  _buildDetail("Location","Ludhiana"),
                  Container(width: screenWidth,height: 0.2,color: Colors.grey,),
                  _buildDetail("Device Type","Linux"),
                  Container(width: screenWidth,height: 0.2,color: Colors.grey,),
                  _buildDetail("Date & Time","10 Dec 2024- 14:12"),
                  Container(width: screenWidth,height: 0.2,color: Colors.grey,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,vertical: 14),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status",style: TextStyle(fontSize: 13),),
                        Text("$text",style: TextStyle(fontSize: 13,color: text == "Failure" ? Colors.red : Colors.green)),
                      ],
                    ),
                  )
                ],
              ) :
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String heading, String detail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 14),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$heading",style: TextStyle(fontSize: 13),),
          Text("$detail",style: TextStyle(fontSize: 13)),
        ],
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
/*
        phoneNo = null;
        username = user;
        CheckCustomerRequest request =
            CheckCustomerRequest(username: username, phoneNo: phoneNo);*/
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
