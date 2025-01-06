import 'package:BDOne/model/response/checkCustomerReponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/api_response.dart';
import '../../../../utils/Util.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/toastMessage.dart';


class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  String? selected = "All Entries";
  final ConnectivityService _connectivityService = ConnectivityService();
  final ScrollController _scrollController = ScrollController();
  late bool isDarkMode;
  int? expandedIndex ;
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
              statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    "FAQs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        color: isDarkMode? Colors.white : AppColor.TEXT_COLOR
                    ),
                  ),
                  middle: Text(
                    "FAQs",
                    style: TextStyle(fontSize: 22,
                    color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
                  ),
                  backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                  alwaysShowMiddle: false,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTab("Most Popular"),
                          _buildTab("About BD One"),
                          _buildTab("Features"),
                          _buildTab("Registration"),
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
          if(expandedIndex == index){
            expandedIndex = null;
          }else {
            expandedIndex = index;
          }
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
                children: [
                  Icon(expandedIndex == index ? Icons.keyboard_arrow_up  :Icons.keyboard_arrow_down_outlined),
                  Text("What is BD One?", style: TextStyle(fontSize: 14)),
                ],
              ),
              expandedIndex == index ?
              Column(
                children: [
                  SizedBox(height: 6,),
                  Text("BD One is the first national identity for citizens and residents of Bangladesh.The app enables all registered individuals to access more than 12000 governments.",
                      style: TextStyle(fontSize: 14),overflow: TextOverflow.visible,),
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
