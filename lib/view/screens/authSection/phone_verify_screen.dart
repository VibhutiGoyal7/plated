import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/signInWithPhoneNumber.dart';
import 'package:Payrio/model/response/countryListResponse.dart';
import 'package:Payrio/model/response/phoneVerifyResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/exustingUserRequest.dart';
import '../../../model/response/existingUserResponse.dart';
import '../../component/connectivity_service.dart';

class PhoneVerifyScreen extends StatefulWidget {
  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_PhoneVerifyScreenState>();
    state?.setLocale(newLocale);
  }
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  late Locale _locale;
  final ScrollController _scrollController = ScrollController();
  String phoneCode = "+";
  int countryCode = 0;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  String dropdownValue = "";

  late double screenWidth;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  bool phoneNumberValid = false;

  List<CountryData> countryList = [];

  @override
  void initState() {
    super.initState();
    phoneNumberValid = false;
    _fetchData();
  }

  final TextEditingController _inputController = TextEditingController();

  void _isValidPhoneNumber(String input) {
    print(input);
    if (input.isNotEmpty && input.length >= 10) {
      setState(() {
        phoneNumberValid = true;
      });
    } else {
      setState(() {
        phoneNumberValid = false;
      });
    }
  }

  Widget existingUserWidget(BuildContext context, ApiResponse apiResponse) {
    ExistingUserResponse? mediaList = apiResponse.data as ExistingUserResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });

    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("userfound: ${mediaList?.userFound}");
        // Navigate to the new screen after receiving the response
        if (mediaList?.userFound == true &&
            mediaList?.isProfileSetupDone == true) {
          Navigator.pushNamed(context, '/SignInScreen',
              arguments: "${_inputController.text}");
        } else {
          _phoneVerifyAPI();
        }
        return Container();
      case Status.ERROR:
        _phoneVerifyAPI();
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

  Future<Widget> getPhoneVerifyResponse(
      BuildContext context, ApiResponse apiResponse) async {
    PhoneVerifyResponse? phoneVerifyResponse =
        apiResponse.data as PhoneVerifyResponse?;
    var message = apiResponse?.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${phoneVerifyResponse?.mobileOtp}");
        //Call Toast

        ToastComponent.showToast(context: context, message: message);
        // Navigate to the new screen after receiving the response
        Navigator.pushNamed(context, '/OtpVerify',
            arguments: "${_inputController.text}");
        ToastComponent.showToast(
            context: context, message: "${phoneVerifyResponse?.mobileOtp}");
        return Container(); // Return an empty container as yo u'll navigate away
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

  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = apiResponse?.message.toString();
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: screenHeight * 0.15,
                      child: Text(
                        "Phone\n Verification",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: AlignmentDirectional.center,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            _buildLabelText(
                                context, "Enter your mobile number", 16, true),
                            _buildLabelText(
                                context,
                                "We will send you a confirmation code",
                                12,
                                false),
                            Column(
                              children: [
                                SizedBox(height: 40),
                                _buildPhoneInput(context, isDarkMode),
                                SizedBox(
                                  height: screenHeight * 0.2,
                                ),
                              ],
                            ),
                            Spacer(),
                            Center(
                              child: _buildFooter(context, apiResponse),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                /*_buildLabelText(
                    context, Languages.of(context)!.appName, 16, false),*/
              ],
            ),
          ),
          isLoading
              ? Stack(
            children: [
              ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.3)),
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

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, bool isDarkMode) {
    String? selectedItem;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _buildLabelText(context, "Phone Number", 12, false),
          ),
          Card(
            elevation: 2,
            child: Container(
              height: 55,
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                    top: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    bottom: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    right: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    left: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                width: 70, // Width of the dropdown button
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    //hint: Text('Select'),
                    isExpanded: true,
                    value: selectedItem,
                    onChanged: (newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return countryList.map((item) {
                        return Container(
                          width: 70,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  item.flagImageUrl as String,
                                  height: 22,
                                  width: 35,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white30,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          height: 22,
                                          width: 35,
                                          color: Colors.grey,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              /*SizedBox(width: 2.5),
                              Text(
                                "+${item.phoneCode}",
                                style: TextStyle(fontSize: 11),
                                overflow: TextOverflow.ellipsis,

                              ),*/
                            ],
                          ),
                        );
                      }).toList();
                    },
                    items: countryList.map((item) {
                      return DropdownMenuItem<String>(
                        value: item.phoneCode,

                        child: Container(
                          width: 200,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  item.flagImageUrl as String,
                                  height: 24,
                                  width: 40,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white30,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          height: 24,
                                          width: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "+${item.phoneCode}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
                /*  Container(
                    width: screenWidth*0.1,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        //hint: Text('Select a fruit'),
                        value: selectedItem,
                        onChanged: (newValue) {
                          setState(() {
                            selectedItem = newValue;
                          });
                        },
                        items: countryList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.phoneCode,
                            child: Row(
                              children: [
                                Image.asset(
                                  "${item.flagImageUrl}",
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 10),
                                Text("${item.phoneCode}"),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),*/
                  /* GestureDetector(
                    onTap: () async {
                      _showPicker(context: context);
                    },
                    child: SizedBox(
                      height: 55,
                      width: 40,
                      child: Center(
                        child: Text(
                          phoneCode,
                          style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      controller: _inputController,
                      onChanged: _isValidPhoneNumber,
                      maxLength: 12,
                      keyboardType: TextInputType.phone,
                      onSubmitted: (value) {
                        // if (value.isNotEmpty) {
                        //   Provider.of<MainViewModel>(context, listen: false)
                        //       .setSelectedMedia(null);
                        //   Provider.of<MainViewModel>(context, listen: false)
                        //       .fetchMediaData(value, phoneRequest);
                        // }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: 'XXXXXXXXXX',
                        hintStyle: TextStyle(color: Colors.grey),
                        //suffixIcon:Icon(Icons.phone_enabled_sharp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: screenWidth * 0.7,
            //height: 40,
            child: ElevatedButton(
              onPressed: () async {
                if (phoneNumberValid && countryCode > 0 && phoneCode != "+") {
                  setState(() {
                    isLoading = true;
                  });

                  bool isConnected = await _connectivityService.isConnected();
                  if (!isConnected) {
                    setState(() {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No internet connection'),
                          duration: maxDuration,
                        ),
                      );
                    });
                  } else {
                    ExistingUserRequest request = ExistingUserRequest(
                        customer: ExistingCustomer(
                            phoneNumber: _inputController.text));
                    await Provider.of<MainViewModel>(context, listen: false)
                        .existingUserData(
                            "/api/v1/app/customers/check_customer_existance",
                            request);
                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    existingUserWidget(context, apiResponse);
                  }
                } else if (countryCode == 0 && phoneCode == "+") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(Languages.of(context)!.labelSelectCountryCode),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(Languages.of(context)!.labelEnterValidPhone),
                  ));
                }
              },
              child: Text(
                Languages.of(context)!.labelSubmit,
                style: TextStyle(
                    color: phoneNumberValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      phoneNumberValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),
        /*Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            Languages.of(context)!.labelNeedHelp,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),*/
      ],
    );
  }

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      isScrollControlled: false, // Ensure the sheet takes full height
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure minimal height
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end, // Align start
            children: <Widget>[
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: countryList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 0),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: (phoneCode == "+${countryList[index].phoneCode}")
                        ? AppColor.PRIMARY
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        phoneCode = "+${countryList[index].phoneCode}";
                        countryCode = countryList[index].id as int;
                      });
                      Navigator.of(context).pop();
                    },
                    leading: ClipRRect(
                      child: Image.network(
                        countryList[index].flagImageUrl as String,
                        height: 28,
                        width: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.white30,
                              highlightColor: Colors.grey,
                              child: Container(
                                height: 28,
                                width: 50,
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          countryList[index].name as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (phoneCode ==
                                    "+${countryList[index].phoneCode}")
                                ? AppColor.WHITE
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "+${countryList[index].phoneCode}",
                          style: TextStyle(
                            fontSize: 12,
                            color: (phoneCode ==
                                    "+${countryList[index].phoneCode}")
                                ? AppColor.WHITE
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _phoneVerifyAPI() async {
    if (phoneNumberValid) {
      setState(() {
        isLoading = true;
      });

      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No internet connection'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        PhoneRequest phoneRequest = PhoneRequest(
            customer: Customer(
                phoneNumber: _inputController.text,
                mobileOtp: "",
                countryId: countryCode));
        await Provider.of<MainViewModel>(context, listen: false)
            .PhoneVerifyData(
                "/api/v1/app/temp_customers/initiate_customer", phoneRequest);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getPhoneVerifyResponse(context, apiResponse);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter valid phone number and select country code.'),
          duration: maxDuration,
        ),
      );
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
            content: Text('No internet connection'),
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
}
