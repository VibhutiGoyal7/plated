import 'dart:async';

import 'package:Payrio/model/response/live_chat_user_details_response.dart';
import 'package:Payrio/model/services/cloud_firestore_service.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/component/toastMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../model/response/live_chat_response.dart';
import '../../../../../utils/Helper.dart';

class LiveChatListScreen extends StatefulWidget {
  @override
  _LiveChatListScreenState createState() => _LiveChatListScreenState();
}

late StreamSubscription<bool> keyboardSubscription;

class _LiveChatListScreenState extends State<LiveChatListScreen> {
  bool isLoading = false;
  String kycStatus = "";
  String amount = "";
  String fistName = "";
  String lastName = "";
  String userId = "";
  bool expanded = false;
  bool inputValid = false;
  final tokenInputController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late CloudFirestoreService service;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
    Helper.getProfileDetails().then((profile) {
      setState(() {
        userId = "${profile?.userId}";
        fistName = "${profile?.firstName}";
        lastName = "${profile?.lastName}";
      });
    });
    service = CloudFirestoreService(FirebaseFirestore.instance);
    inputValid = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
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

    service.add(liveChatResponse, userId).then((_) {
      service.addUserDetails(liveChatUserDetailsResponse, userId).then((_) {
        _controller.clear();
        _scrollToBottom(); // Scroll to bottom after adding a message
      });
    });
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
          "Live Chats",
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
                  userId != "" ?
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream:  service.getUsers(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.none) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error fetching data: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data?.docs.isEmpty == true) {
                          return const Center(child: Text('No Messages'));
                        }

                        final documents = snapshot.data?.docs ?? [];
                        final liveChatResponses = documents.map((doc) {
                          return LiveChatResponse.fromJson(doc.data());
                        }).toList();

                        // Scroll to the bottom whenever new data arrives
                        //WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                        //});

                        return ListView.builder(
                          //shrinkWrap: true,
                          //scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          //physics: const BouncingScrollPhysics(),
                          itemCount: liveChatResponses.length,
                          itemBuilder: (context, index) {
                            final response = liveChatResponses[index];
                            final isUserMessage = response.user == 2;
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
                            final timeTextColor =
                                isDarkMode ? AppColor.WHITE : AppColor.BLACK;

                            return Align(
                              alignment: messageAlignment,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                          response.text ?? 'No Last Name',
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(color: textColor),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Text(
                                      "${response.createdAt?.toDate().hour.toString() ?? '00'} : ${response.createdAt?.toDate().minute.toString() ?? '00'}",
                                      style: TextStyle(
                                          color: timeTextColor, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ) : Center(child: Text('No Messages')),
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
                                  _addMessage(_controller.text);
                                },
                                child: Icon(Icons.send))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
