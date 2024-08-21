import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/api_response.dart';
import '../../../../model/request/checkCustomerRequest.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/toastMessage.dart';

class TransferContactScreen extends StatefulWidget {
  @override
  _TransferContactScreenState createState() => _TransferContactScreenState();
}

class _TransferContactScreenState extends State<TransferContactScreen> {
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

  @override
  void initState() {
    super.initState();
    _fetchRecentData();
    _isRecentDataEmpty();
  }

  Future<Widget> initiateCheckCustomerResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CheckCustomerResponse? checkCustomerResponse =
        apiResponse.data as CheckCustomerResponse?;
    var message = apiResponse?.message.toString();
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
              SafeArea(
                child: Stack(
                  children: <Widget>[
                    Container(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0 ,vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                Languages.of(context)!.labelMoneyTransfer,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color:isDarkMode ?  Colors.black12 :  Colors.white38),
                                child: Text(
                                  Languages.of(context)!.labelEnterPhoneNoOrUsernameSub,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _buildPhoneInput(context, _usernameController),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all( AppColor.PRIMARY),
                              ),
                              onPressed: () async {
                                _fetchData(_usernameController.text);

                              },
                              child: Text(
                                Languages.of(context)!.labelSubmit,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              Languages.of(context)!.labelRecents,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          isRecentDataEmpty
                              ? Container(
                                  height: screenHeight * 0.3,
                                  child: Center(
                                    child: Text(
                                      Languages.of(context)!.labelNoRecentTransaction,
                                      style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white30
                                              : Colors.grey),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    controller: _scrollController,
                                    itemCount: prefResponse?.length,
                                    shrinkWrap: true,
                                    padding:
                                        const EdgeInsets.only(bottom: 0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        /*
                            tileColor: Colors.white12,*/
                                        contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                        onTap: () {
                                          setState(() {
                                            _fetchData(
                                                "${prefResponse?[index].username}");
                                          });
                                          //Navigator.of(context).pop();
                                        },
                                        leading: prefResponse?[index]
                                                    .imageUrl ==
                                                ""
                                            ? Container(
                                                height: 45,
                                                width: 45,
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      AppColor.WHITE,
                                                  backgroundImage: AssetImage(
                                                      "assets/profile_user.png"),
                                                ),
                                              )
                                            : Container(
                                          height: 45,
                                          width: 45,
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                            AppColor.WHITE,
                                            backgroundImage: AssetImage(
                                                "assets/profile_user.png"),
                                          ),
                                        ),
                                        title: Text(
                                          prefResponse?[index].fullName
                                              as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
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
                            dismissible: false,
                            color: Colors.transparent),
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

  Widget _buildPhoneInput(
      BuildContext context, TextEditingController nameController) {
    //nameController.text = widget.data as String;
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: screenWidth,
        //padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          style: TextStyle(
            fontSize: 14.0,
          ),
          obscureText: false,
          obscuringCharacter: "*",
          controller: nameController,
          onChanged: (value) {
            _checkInputValidation();
          },
          onSubmitted: (value) {
            _checkInputValidation();
            //_fetchData(_usernameController.text);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.PRIMARY, width: 0.8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.PRIMARY, width: 0.7)),
            hintText: Languages.of(context)!.labelHintUserNameOrPhoneNo,
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
        if (isNumeric(user)) {
          phoneNo = user;
          username = null;
        } else {
          phoneNo = null;
          username = user;
        }
        CheckCustomerRequest request =
            CheckCustomerRequest(username: username, phoneNo: phoneNo);
        await Provider.of<MainViewModel>(context, listen: false)
            .checkCustomerByUsername(
                "api/v1/app/customers/check_customer_by_username", request);
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

  bool isNumeric(String s) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(s);
  }

  void _checkInputValidation() {
    if (_usernameController.text.isNotEmpty) {
      inputValid = true;
    }
  }

  Future<void> _fetchRecentData() async {
    await Future.delayed(Duration(milliseconds: 2));
    List<CheckCustomerResponse>? prefResult =
        await Helper.getRecentP2PDetails();
    //print("prefResult ${prefResult?[0].username}");

    setState(() {
      prefResponse = prefResult;
      _isRecentDataEmpty();
      // print("prefResponse ${prefResponse?[0].username}");
    });
  }

  void _isRecentDataEmpty() {
    if (prefResponse == null ||
        prefResponse == [] ||
        prefResponse!.isEmpty ||
        prefResponse?[0] == null ||
        prefResponse?[0].username == null) {
      setState(() {
        isRecentDataEmpty = true;
      });
    } else {
      setState(() {
        isRecentDataEmpty = false;
      });
    }

    print("${isRecentDataEmpty}");
  }
}
