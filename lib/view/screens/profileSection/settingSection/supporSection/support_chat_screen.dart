import 'dart:async';
import 'dart:io';

import 'package:Payrio/model/response/live_chat_user_details_response.dart';
import 'package:Payrio/model/response/messagesSupportChatResponse.dart';
import 'package:Payrio/model/response/sendMessageResponse.dart';
import 'package:Payrio/model/services/cloud_firestore_service.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../model/apis/api_response.dart';
import '../../../../../model/response/live_chat_response.dart';
import '../../../../../utils/Helper.dart';
import '../../../../../view_model/main_view_model.dart';
import '../../../../component/connectivity_service.dart';
import '../../../../component/session_expired_dialog.dart';

class SupportChatScreen extends StatefulWidget {
  final int userId;

  SupportChatScreen({Key? key, required this.userId}) : super(key: key);
  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}


class _SupportChatScreenState extends State<SupportChatScreen> {
  File image = File("");
  String kycStatus = "";
  String amount = "";
  String fistName = "";
  String lastName = "";
  String userId = "";
  bool expanded = false;
  bool inputValid = false;
  late List<dynamic>  liveChatResponses;
  final tokenInputController = TextEditingController();
  ScrollController _scrollController = ScrollController();
/*
  late CloudFirestoreService service;*/
  final TextEditingController _controller = TextEditingController();
  //late Stream<QuerySnapshot<Map<String, dynamic>>> _commentStream;


  bool isLoading = true;
  bool isInternetConnected = true;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    //service = CloudFirestoreService(FirebaseFirestore.instance);
    liveChatResponses = [];
    _scrollToBottom();
    Helper.getProfileDetails().then((profile) {
      setState(() {
        userId = "${profile?.userId}";
        fistName = "${profile?.firstName}";
        lastName = "${profile?.lastName}";
       // _commentStream = service.getUsers(userId);
      });
    });
    _fetchData();

    inputValid = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> getSupportData(BuildContext context, ApiResponse apiResponse,) async {
    MessagesSupportChatResponse? supportDataListResponse =
    apiResponse.data as MessagesSupportChatResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = supportDataListResponse?.messages ?? [];
        print("Livechat response");
        setState(() {
          liveChatResponses.clear();

         liveChatResponses.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message == "${Languages.of(context)?.labelInvalidAccessToken}") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }


  Future<void> sendMessageSupport(BuildContext context, ApiResponse apiResponse,) async {
    SendMessageResponse? sendMessageResponse =
    apiResponse.data as SendMessageResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = sendMessageResponse?.message ?? "";
        print("Livechat response");
        _fetchData();
        setState(() {
          _controller.text="";
          hideKeyBoard();

         //liveChatResponses.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message == "${Languages.of(context)?.labelInvalidAccessToken}") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }


  Future<void> _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final position = _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
          position,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      } else {
        // You can also add a retry mechanism here if necessary
      }
    });
  }

  void _addMessage(String message) {
    LiveChatResponse liveChatResponse = LiveChatResponse(
      text: message,
      isRead: false,
      user: 2,
    );

    LiveChatUserDetailsResponse liveChatUserDetailsResponse =
    LiveChatUserDetailsResponse(
        first_name: fistName,
        last_name: lastName,
        lastMessage: message,
        unReadByAdmin: 1,
        unReadByMerchant: 1);

   /* service.add(liveChatResponse, userId).then((_) {
      service.addUserDetails(liveChatUserDetailsResponse, userId).then((_) {
        _controller.clear();
        _scrollToBottom(); // Scroll to bottom after adding a message
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/SupportSelectionScreen');
          },
        ),
        title: Text(
          "Support ticket chat",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userId != ""
                      ? Expanded(
                    child: ListView.builder(
                          //shrinkWrap: true,
                          //scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          //physics: const BouncingScrollPhysics(),
                          itemCount: liveChatResponses.length,
                          itemBuilder: (context, index) {
                            final response = liveChatResponses[index];
                            final isUserMessage = response.userId == 1;
                            final messageAlignment = isUserMessage
                                ? Alignment.topRight
                                : Alignment.topLeft;
                            final messageColor = isUserMessage
                                ? AppColor.PRIMARY
                                : isDarkMode
                                ? AppColor.WHITE
                                : AppColor.BLACK;
                            final textColor = isUserMessage
                                ? AppColor.WHITE
                                : isDarkMode
                                ? AppColor.BLACK
                                : AppColor.WHITE;
                            final timeTextColor = isDarkMode
                                ? AppColor.WHITE
                                : AppColor.BLACK;

                            return Align(
                              alignment: messageAlignment,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.6,
                                        minWidth: screenWidth * 0.3),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      color: messageColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            left: 10.0,
                                            right: 6.0,
                                            bottom: 10.0),
                                        child: Text(
                                          response.content ?? 'No Last Name',
                                          overflow: TextOverflow.visible,
                                          style:
                                          TextStyle(color: textColor),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 6.0),
                                    child: Text(
                                      "${convertTime(response.createdAt)} ",
                                      style: TextStyle(
                                          color: timeTextColor,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )

                  )
                      : Center(child: Text('No Messages')),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding:
                      EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: _controller,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 14.0),
                        obscureText: false,
                        obscuringCharacter: "*",
                        onChanged: (value) {
                          //setState(() {});
                        },
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message",
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  _sendMsg(_controller.text);
                                },
                                child: Icon(Icons.send))),
                      ),
                    ),
                  ),
                ],
              ),
              isLoading ? Stack(
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
              ): SizedBox()
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _fetchData(
      ) async {
    print("Fetch Data");
    try {
      setState(() {
        isLoading = true;
      });
      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {

        await Provider.of<MainViewModel>(context, listen: false)
            .getSupportChatData("api/v1/app/payorio_support_tickets/${widget.userId}/messages", );
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getSupportData(context, apiResponse);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> _sendMsg(String content) async {
    print("Fetch Data");
    try {
      setState(() {
        isLoading = true;
      });
      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {

        await Provider.of<MainViewModel>(context, listen: false)
            .postMultiFormMessageResponse(
          "api/v1/app/payorio_support_tickets/${widget.userId}/messages",
          image ,
          content,
        );

        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await sendMessageSupport(context, apiResponse);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

}
