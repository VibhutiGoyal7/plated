import 'package:Payrio/model/response/checkCustomerReponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/request/checkCustomerRequest.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            Languages.of(context)!.labelMoneyTransfer,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      /*Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Languages.of(context)!.labelTransferTo,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please enter phone number registered with Payorio or username to(such as XXXXX@payorio) to which you want to transfer money.",
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildPhoneInput(context, _usernameController),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Recents",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      isRecentDataEmpty
                          ? Expanded(
                              child: Center(
                                child: Text("Make some transactions...",
                                style: TextStyle(color: isDarkMode ? Colors.grey : Colors.white70),),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _scrollController,
                                itemCount: prefResponse?.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 0),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    /*
                            tileColor: Colors.white12,*/
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                    onTap: () {
                                      setState(() {
                                        _fetchData(
                                            "${prefResponse?[index].username}");
                                      });
                                      //Navigator.of(context).pop();
                                    },
                                    leading: prefResponse?[index].imageUrl == ""
                                        ? Container(
                                            height: 45,
                                            width: 45,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColor.WHITE,
                                              backgroundImage: AssetImage(
                                                  "assets/profile_user.png"),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.network(
                                              prefResponse?[index].imageUrl
                                                  as String,
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                // You can return any widget here to display in case of an error
                                                return Container(
                                                  height: 45,
                                                  width: 45,
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        AppColor.WHITE,
                                                    backgroundImage: AssetImage(
                                                      "assets/profile_user.png",
                                                    ),
                                                  ),
                                                );
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.white38,
                                                    highlightColor: Colors.grey,
                                                    child: Container(
                                                      height: 45,
                                                      width: 45,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                }
                                              },
                                            )),
                                    title: Text(
                                      prefResponse?[index].fullName as String,
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
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
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
        ),
      ),
    );
  }

  Widget _buildPhoneInput(
      BuildContext context, TextEditingController nameController) {
    //nameController.text = widget.data as String;
    return Container(
      alignment: Alignment.center,
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
          _fetchData(_usernameController.text);
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(18),
          /*enabledBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: Colors.black, style: BorderStyle.solid)),*/
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black87,
                  width: 0.7)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey : Colors.black87,
                  width: 0.7)),
          hintText: "Username or phone number",
          hintStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          suffixIcon: Icon(
            Icons.perm_contact_cal,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 25,
          ),
        ),
      ),
    );
  }

  Future<void> _fetchData(String userSelected) async {
    //_isValidInput();
    const maxDuration = Duration(seconds: 2);

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
              content: Text('No internet connection'),
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
        content: Text('Please enter valid details.'),
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
        prefResponse!.isEmpty ||
        prefResponse?[0] == null ||
        prefResponse?[0].username == null) {
      isRecentDataEmpty = true;
    } else {
      isRecentDataEmpty = false;
    }
  }
}
