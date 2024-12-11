import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:BDPass/view/component/textfield_component.dart';
import 'package:BDPass/view/component/toastMessage.dart';
import 'package:BDPass/view/screens/authSection/welcomeSection/instruction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';

class VisitorNameScreen extends StatefulWidget {
  @override
  _VisitorNameScreenState createState() => _VisitorNameScreenState();
}

class _VisitorNameScreenState extends State<VisitorNameScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  bool isInstruction = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<CountryData> countryList = [];
  late VideoPlayerController _controller;
  TextEditingController firtNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new)),
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm Details",
                    style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 14,),
                  Text(
                    "Enter your first and last name",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextfieldComponent(width: 1, isPhone: false, text: "First Name",
                      icon: Icon(Icons.person), inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      textController: firtNameController, onChanged: (){

                      }),
                  TextfieldComponent(width: 1, isPhone: false, text: "Last Name",
                      icon: Icon(Icons.person), inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      textController: lastNameController, onChanged: (){

                      }),

                  SizedBox(
                    height: 52,
                  ),
                  Center(
                      child: CustomButtonComponent(
                          text: "${Languages.of(context)?.labelProceed}",
                          screenWidth: screenWidth,
                          isDarkMode: isDarkMode,
                          verticalPadding: 10,
                          onTap: () {
                            if(firtNameController.text.isNotEmpty && lastNameController.text.isNotEmpty){
                              Helper.saveName("${firtNameController.text} ${lastNameController.text}");
                              Navigator.pushNamed(context, "/PhoneVerificationScreen",arguments: "");
                            }else{
                              ToastComponent.showToast(context: context, message: "Enter your name");
                            }
                          })),

                  SizedBox(
                    height: 52,
                  )
                ],
              ),
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox()
        ]),
      ),
    );
  }

  Widget _buildExistingAccFooter(
      {required BuildContext context,
      required String text,
      required bool isDarkMode,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.94,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? Colors.white : Colors.black, width: 0.8),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  void _fetchData() async {
    setState(() {
      isLoading = true;
    });

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
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCountryList("api/v1/app/customers/country_list");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCountryList(context, apiResponse);
    }
  }

  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[1].name}");

        countryList = countryListResponse!.countries!;
        Helper.saveCountryList(countryList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";

        print("countriess ${countryList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${countryList}");
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
