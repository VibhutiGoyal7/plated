import 'package:BDPass/model/apis/api_response.dart';
import 'package:BDPass/model/request/signInWithPhoneNumber.dart';
import 'package:BDPass/model/response/countryListResponse.dart';
import 'package:BDPass/model/response/phoneVerifyResponse.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/toastMessage.dart';
import 'package:BDPass/view_model/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/exustingUserRequest.dart';
import '../../../model/response/existingUserResponse.dart';
import '../../../utils/Util.dart';
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
  String selectedItem = "";

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
    Helper.getCountryList().then((countries) {
      List<CountryData> list = [];
      print(countries);
      setState(() {
        countryList = countries as List<CountryData>;
      });

      print(countryList);
      if (countryList == null ||
          countryList == [] ||
          countryList.isEmpty ||
          countryList == list) {
        _fetchData();
      } else {
        setState(() {
          countryList = countries!;
          selectedItem = "${countries[0].flagImageUrl}";
          countryCode = int.parse("${countries[0].id}");
          phoneCode = "+${countries[0].phoneCode}";
        });
      }
    });
    //_fetchData();
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
          /*Navigator.pushNamed(context, '/SignInScreen',
              arguments: "${_inputController.text}");*/
          ToastComponent.showToast(
              context: context, message: apiResponse.message);
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
            arguments: "${_inputController.text}");/*
        ToastComponent.showToast(
            context: context, message: "${phoneVerifyResponse?.mobileOtp}");*/
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
        print("GetCountryList : ${countryListResponse?.countries?[1].name}");
        Helper.saveCountryList(countryListResponse?.countries);

        setState(() {

          countryList = countryListResponse?.countries as List<CountryData>;
          selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";
          countryCode = int.parse("${countryListResponse?.countries?[0].id}");
          phoneCode = "+${countryListResponse?.countries?[0].phoneCode}";
        });

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
        //resizeToAvoidBottomInset: false,
        body: GestureDetector(
      onTap: () {
        hideKeyBoard();
      },
      child: SafeArea(
        child: Stack(children: [
          Container(
            height: screenHeight,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      screenHeight - MediaQuery.of(context).viewInsets.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: screenHeight * 0.15,
                            child: Text(
                              "${Languages.of(context)?.labelPhoneVerification}",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  _buildLabelText(
                                      context,
                                      "${Languages.of(context)?.labelEnterPhoneNo}",
                                      16,
                                      true),
                                  _buildLabelText(
                                      context,
                                      "${Languages.of(context)?.labelSendConfirmationCode}",
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
              ),
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox(),
        ]),
      ),
    ));
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _changeItem(CountryData? newValue) {
    setState(() {
      print("${newValue?.id}");
      countryCode = int.parse("${newValue?.id}");
      phoneCode = "${newValue?.code}";
      selectedItem = "${newValue?.flagImageUrl}";
    });
  }

  Widget _buildPhoneInput(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _buildLabelText(context,
                "${Languages.of(context)?.labelPhoneNumber}", 12, false),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          showMenu(
                            context: context,
                            position: RelativeRect.fromRect(
                              Rect.fromLTWH(0, 290, overlay.size.width,
                                  overlay.size.height),
                              Offset.zero & overlay.size,
                            ),
                            items: countryList.map((item) {
                              return PopupMenuItem<CountryData>(
                                value: item,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        "${item.flagImageUrl}",
                                        height: 24,
                                        width: 40,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
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
                                      style: TextStyle(color: AppColor.WHITE),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ).then((value) {
                            if (value != null) {
                               _changeItem(value);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            selectedItem.isEmpty
                                ? Container(width: 40)
                                : Image.network(
                                    "${Uri.parse(selectedItem)}",
                                    height: 24,
                                    width: 40,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
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
                            SizedBox(width: 5),
                            Icon(Icons.keyboard_arrow_down_sharp),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                hideKeyBoard();
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
                          content: Text(
                              '${Languages.of(context)?.labelNoInternetConnection}'),
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
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/SignInScreen");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${Languages.of(context)?.labelAlreadyHaveAnAcc}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  "${Languages.of(context)?.labelLogin}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                            fontWeight: FontWeight.w600,
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
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
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
              Text('${Languages.of(context)?.labelPleaseEnterValidPhoneNo}'),
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
}
