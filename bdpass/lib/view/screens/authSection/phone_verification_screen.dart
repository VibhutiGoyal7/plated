import 'dart:io';

import 'package:BDPass/languageSection/Languages.dart';
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
import '../../component/instruction_step.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<CountryData> countryList = [];
  File? docImg;
  bool isDarkMode = false;
  bool isChecked = false;
  String selectedItem = "";
  String selectedCountryFlag = "";
  Country? selectedCountry;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setInitialCountry();
    //_fetchData();
  }

  void setInitialCountry() {
    // Use a predefined country code to find the Country object
    final initialCountryCode = 'IN'; // Example: India
    selectedCountry = Country.tryParse(initialCountryCode);
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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  Languages.of(context)!.labelVerificationDetails,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    InstructionStep(
                        icon: Icons.document_scanner_rounded,
                        title: "Step 1",
                        isActive: true,
                        iconColor: Colors.green.shade900),
                    InstructionStep(
                        icon: Icons.person_sharp,
                        title: "Step 2",
                        isActive: true,
                        iconColor: Colors.green.shade900),
                    InstructionStep(
                        icon: Icons.lock_sharp,
                        title: "Step 3",
                        isActive: false,
                        iconColor: Colors.green.shade900),
                  ],
                ),
                Text(
                  "Please provide your mobile number and email address to proceed",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            useSafeArea: true,
                            context: context,
                            showPhoneCode: true,
                            // Show phone code next to country
                            onSelect: (Country country) {
                              setState(() {
                                selectedItem = country.phoneCode;
                                selectedCountryFlag = country.flagEmoji;
                                selectedCountry == null;
                              });
                              print(
                                  'Selected country flag: ${country.flagEmoji}');
                              print('Phone code: ${country.phoneCode}');
                              print('Country code: ${country.countryCode}');
                            },
                          );
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border(
                                top: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black54,
                                    width: 0.4),
                                bottom: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black54,
                                    width: 0.4),
                                right: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black54,
                                    width: 0.4),
                                left: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black54,
                                    width: 0.4)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              selectedItem.isEmpty
                                  ? IntrinsicWidth(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 2),
                                          Text(
                                            selectedCountry != null
                                                ? "${selectedCountry?.flagEmoji}"
                                                : "",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            selectedCountry != null
                                                ? "+${selectedCountry?.phoneCode}"
                                                : "+",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  : IntrinsicWidth(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 2),
                                          Text(
                                            "$selectedCountryFlag",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "+$selectedItem",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                              Icon(Icons.keyboard_arrow_down_sharp),
                            ],
                          ),
                        ),
                      ),
                      _buildPhoneInput(
                          context,
                          Languages.of(context)!.labelMobileNumber,
                          _phoneNoController,
                          Icon(
                            Icons.person,
                            size: 20,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          0.68),
                    ],
                  ),
                ),
                _buildEmailInput(
                    context,
                    Languages.of(context)!.labelEmail,
                    _emailController,
                    Icon(
                      Icons.mail,
                      size: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    1.0),
                Spacer(),
                _buildFooter(
                    context: context,
                    text: Languages.of(context)!.labelContinue,
                    onTap: () {
                      //onPressedFrontImage();
                      Navigator.pushNamed(context, "/OtpVerificationScreen");
                    }),
                SizedBox(
                  height: 35,
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

  void _changeItem(CountryData? newValue) {
    setState(() {
      print("${newValue?.id}");
      //countryCode = int.parse("${newValue?.id}");
      //phoneCode = "${newValue?.code}";
      //selectedCountryCode = "${newValue?.phoneCode}";
      ///selectedItem = "${newValue?.flagImageUrl}";
    });
  }

  Widget _buildFooter(
      {required BuildContext context,
      required String text,
      required VoidCallback onTap}) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.8),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void onPressedFrontImage() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      if (!mounted) return;
      setState(() {
        print("Front Image: ${pictures}");
        docImg = File(pictures.first);
        print("Front Image: $docImg");
      });
    } catch (exception) {
      // Handle exception here
    }
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

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, double height) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        //height: 60,
        width: screenWidth * height,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  //_isValidInput();
                },
                maxLength: 10,
                textAlignVertical: TextAlignVertical.top,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                onSubmitted: (value) {},
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  alignLabelWithHint: true,
                  counterText: "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, double height) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        //height: 60,
        width: screenWidth * height,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              top: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              right: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              left: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                  width: 0.4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  //_isValidInput();
                },
                textAlignVertical: TextAlignVertical.top,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                onSubmitted: (value) {},
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  alignLabelWithHint: true,
                  counterText: "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
