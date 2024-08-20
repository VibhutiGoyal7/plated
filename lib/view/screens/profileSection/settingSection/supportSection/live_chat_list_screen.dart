import 'dart:async';

import 'package:Payrio/model/response/live_chat_user_details_response.dart';
import 'package:Payrio/model/services/cloud_firestore_service.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Util.dart';
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
  String imageUrl = "";
  String lastName = "";
  String userId = "";
  bool expanded = false;
  bool inputValid = false;
  final tokenInputController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late CloudFirestoreService service;
  final TextEditingController _controller = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _commentStream;

  @override
  void initState() {
    super.initState();
    service = CloudFirestoreService(FirebaseFirestore.instance);

    _scrollToBottom();
    Helper.getProfileDetails().then((profile) {
      setState(() {
        userId = "${profile?.userId}";
        fistName = "${profile?.firstName}";
        lastName = "${profile?.lastName}";
        imageUrl = "${profile?.imageUrl}";
        _commentStream = service.getUsers(userId);
        service.resetUnReadByMerchantCount(userId);
      });
    });

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
      }
    });
  }

  Future<void> _addMessage(String message) async {
    LiveChatResponse liveChatResponse = LiveChatResponse(
      text: message,
      isRead: false,
      user: 2,
    );

    int? adminCount = await service.getUnReadByAdminCount(userId);
    if (adminCount == null) {
      adminCount = 0; // If no count exists, start with 0
    }

    // Increment the count
    int updatedCount = adminCount + 1;

    // Update the count in Firestore

    LiveChatUserDetailsResponse liveChatUserDetailsResponse =
        LiveChatUserDetailsResponse(
            first_name: fistName,
            last_name: lastName,
            image_url: imageUrl,
            lastMessage: message,
            unReadByAdmin: updatedCount,
        unReadByMerchant: 0);

    service.add(liveChatResponse, userId).then((_) {
      service.addUserDetails(liveChatUserDetailsResponse, userId).then((_) {
        //print(liveChatResponse.user);
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
      body: GestureDetector(
        onTap: (){
          hideKeyBoard();
        },
        child: SafeArea(
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
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: _commentStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.connectionState ==
                                        ConnectionState.none) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error fetching data: ${snapshot.error}');
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
                                    print("response ${response.user}");
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
                                                  response.text ?? 'No Last Name',
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
                                              "${response.createdAt?.toDate().hour.toString() ?? '00'} : ${response.createdAt?.toDate().minute.toString() ?? '00'}",
                                              style: TextStyle(
                                                  color: timeTextColor,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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
                                    _addMessage(_controller.text);
                                  },
                                  child: Icon(Icons.send, color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
