import 'dart:io';

import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:country_picker/country_picker.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/instruction_step.dart';

class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() =>
      _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  bool isDarkMode = false;
  bool isChecked = false;
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${Languages.of(context)?.labelTermAndCondition}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8,),
                Text(
                  "${Languages.of(context)?.labelBDPassTermsOfUse}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                Text(
                  "${Languages.of(context)?.labelVersion} 1.0",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4,),
                Text(
                  "${Languages.of(context)?.labelWelcomeToBDPass}",
                  style: TextStyle(fontSize: 12,),
                ),
                SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  child: Container(
                    height: screenHeight*0.6,
                    child: Column(
                      children: [
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. In consequat ligula vel ante efficitur, eu auctor urna fermentum. Aenean hendrerit placerat justo et lobortis. Nulla mauris lectus, congue non libero vel",
                        style: TextStyle(fontSize: 11),),
                        Padding(
                          padding: const EdgeInsets.only(top : 8.0,left: 18),
                          child: Text("1. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\n2.Fusce volutpat felis eget sollicitudin dictum.\n\n3.Maecenas rhoncus nulla non nisl finibus, sit amet ultrices dolor fringilla.\n\n4.Pellentesque scelerisque velit et vestibulum tempor.\n\n5.Phasellus lobortis lacus non purus dignissim, nec tincidunt urna volutpat.\n\n6.Nunc mollis purus quis odio accumsan imperdiet.",
                            style: TextStyle(fontSize: 11),),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Switch(
                      value: _isToggled,
                      activeColor:AppColor.PRIMARY ,
                      inactiveTrackColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          _isToggled = value;
                        });
                      },
                    ),
                    SizedBox(width: 8,),
                    Text("${Languages.of(context)?.labelReadAllTermsConditions}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Center(
                    child: CustomButtonComponent(
                        text: "${Languages.of(context)?.labelAccept}",
                        screenWidth: screenWidth,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          Navigator.pushNamed(context, "/ProceedAsScreen");
                        })),
                SizedBox(
                  height: 20,
                )
              ],
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

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
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
