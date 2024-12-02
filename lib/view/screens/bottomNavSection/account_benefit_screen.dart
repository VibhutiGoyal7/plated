  import 'dart:io';
import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/circluar_profile_image.dart';
import '../../component/connectivity_service.dart';
import '../../component/detail_box.dart';
import '../../component/session_expired_dialog.dart';

class AccountBenefitScreen extends StatefulWidget {
  @override
  _AccountBenefitScreenState createState() => _AccountBenefitScreenState();
}

class _AccountBenefitScreenState extends State<AccountBenefitScreen> {
  final picker = ImagePicker();
  bool isLoading = true;
  bool isDarkMode = false;
  late double screenWidth;
  late double screenHeight;
  late BDPassDatabase database;
  static const maxDuration = Duration(seconds: 2);
  bool isTablet = false;

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Brightness.light, // Light icons for the status bar
      //statusBarBrightness: Brightness.dark,       // Status bar brightness (for iOS)
    ));
    //_fetchData();
    $FloorBDPassDatabase
        .databaseBuilder('payorio_database.db')
        .build()
        .then((value) async {
      this.database = value;
    });
    print(Helper.getUserToken());
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = getIsTablet(context, screenWidth, screenHeight);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/BottomNav",
            arguments: 0,
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
          arguments: 0,
        );
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushNamed(context, "/BottomNav", arguments: 0);
              }
            }
          }
        },
        onTap: () => {hideKeyBoard()},
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            title: Text("Account Benefits"),
          ),
          body: Stack(children: [
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                  statusBarColor: AppColor.PRIMARY,
                  statusBarIconBrightness: Brightness.light),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
                    child: Column(
                      children: [
                        Text("These are benefits if Basic Account and Verified Account.",style: TextStyle(fontSize:13 ,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.person),
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4,),
                                    Text("Verified Account",style: TextStyle(fontSize:12,fontWeight: FontWeight.bold ),),
                                    SizedBox(height: 6,),
                                    _buildRow("Access all available Government Services"),
                                    _buildRow("Advanced Signature"),
                                    _buildRow("Verify BD Pass signed documents"),
                                    _buildRow("Qualified signatures"),
                                    _buildRow("Request and add documents from issuers"),
                                    _buildRow("Sharing digital documents"),
                                    _buildRow("Managing digital documents"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildRow(String text){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 1),
      child: Row(
        children: [
          Icon(Icons.check,size: 15,),
          SizedBox(width: 4,),
          Text("$text",style: TextStyle(fontSize: 11),)
        ],
      ),
    );
  }

  _buildCard(BuildContext context, String text, bool isDarkMode, Icon icon) {
    return Container(
      width: screenWidth * 0.7,
      padding: EdgeInsets.symmetric(
          vertical: isTablet ? 10 : 14.0, horizontal: isTablet ? 10 : 12.0),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 5,
          ),
          Text(text,
              style: TextStyle(
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      String? retrievedToken = await Helper.getUserToken();
      print("Token $retrievedToken");
      if (mounted) {
        /*await Provider.of<MainViewModel>(context, listen: false)
            .profileScreenData("api/v1/app/customers/show_customer_details");*/
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
       // getProfileResponse(context, apiResponse);
      }
    }
  }


  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,));
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
        await Helper.saveUserBalance(mediaList?.balance);
        await Helper.saveCountry(mediaList?.countryName);
        await Helper.saveKycStatus(mediaList?.kycStatus);
        print(mediaList?.countryName);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
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
}
