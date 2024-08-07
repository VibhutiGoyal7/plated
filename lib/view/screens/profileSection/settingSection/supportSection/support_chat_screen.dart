import 'dart:async';
import 'dart:io';

import 'package:Payrio/model/response/allSupportTicketResponse.dart';
import 'package:Payrio/model/response/messagesSupportChatResponse.dart';
import 'package:Payrio/model/response/sendMessageResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../model/apis/api_response.dart';
import '../../../../../utils/Helper.dart';
import '../../../../../view_model/main_view_model.dart';
import '../../../../component/connectivity_service.dart';
import '../../../../component/session_expired_dialog.dart';

class SupportChatScreen extends StatefulWidget {
  final AllSupportTicketsDetails details;

  SupportChatScreen({Key? key, required this.details}) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  File image = File("");
  String userId = "";
  bool expanded = false;
  bool inputValid = false;
  bool hasAttachment = false;
  File? galleryFile;
  File imageFile = File("");
  final picker = ImagePicker();
  late List<dynamic> liveChatResponses;
  final tokenInputController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true;
  bool isInternetConnected = true;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  File? imageUrl;

  String profileImg = "";
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    liveChatResponses = [];
    _scrollToBottom();
    Helper.getProfileDetails().then((profile) {
      setState(() {
        userId = "${profile?.userId}";
        profileImg = "${profile?.imageUrl}";
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

  Future<void> getSupportData(
    BuildContext context,
    ApiResponse apiResponse,
  ) async {
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
          _scrollToBottom();
        });
        return;
      case Status.ERROR:
        if (apiResponse.message ==
            "${Languages.of(context)?.labelInvalidAccessToken}") {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }

  Future<void> sendMessageSupport(
    BuildContext context,
    ApiResponse apiResponse,
  ) async {
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
        _scrollToBottom();
        setState(() {
          _controller.text = "";
          imageUrl = null;
          hasAttachment = false;
          hideKeyBoard();

          //liveChatResponses.addAll(newItems);
        });
        return;
      case Status.ERROR:
        if (apiResponse.message ==
            "${Languages.of(context)?.labelInvalidAccessToken}") {
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        hideKeyBoard();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Support Ticket Chat",
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
                            child: RefreshIndicator(
                            onRefresh: () {
                              print("Refresh");
                              return Future.delayed(Duration(seconds: 2), () {
                                _fetchData();
                              });
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: liveChatResponses.length,
                              itemBuilder: (context, index) {
                                SupportChatDetail response =
                                    liveChatResponses[index];
                                final isUserMessage =
                                    response.userType == "Customer";
                                final messageAlignment = Alignment.topLeft;
                                final messageColor = isUserMessage
                                    ? isDarkMode
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade200
                                    : AppColor.PRIMARY;
                                final textColor = isUserMessage
                                    ? isDarkMode
                                        ? AppColor.WHITE
                                        : AppColor.BLACK
                                    : AppColor.WHITE;
                                final userImg = isUserMessage ? profileImg : "";

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Align(
                                    alignment: messageAlignment,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: userImg == ""
                                              ? Container(
                                                  height: 32,
                                                  width: 32,
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        AppColor.WHITE,
                                                    backgroundImage: AssetImage(
                                                        "assets/profile_user.png"),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: AppColor.PRIMARY,
                                                        width: 0.3),
                                                    color: Colors.white,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: Image.network(
                                                      userImg,
                                                      height: 32,
                                                      width: 32,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return Container(
                                                          height: 32,
                                                          width: 32,
                                                          child: CircleAvatar(
                                                            radius: 30,
                                                            backgroundColor:
                                                                AppColor.WHITE,
                                                            backgroundImage:
                                                                AssetImage(
                                                              "assets/profile_user.png",
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Shimmer
                                                              .fromColors(
                                                            baseColor:
                                                                Colors.white38,
                                                            highlightColor:
                                                                Colors.grey,
                                                            child: Container(
                                                              height: 32,
                                                              width: 32,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: screenWidth * 0.8,
                                              minWidth: screenWidth * 0.8),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            color: messageColor,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 10.0,
                                                  right: 6.0,
                                                  bottom: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  /* Text(
                                                    response.userType ?? '',
                                                    overflow: TextOverflow.visible,
                                                    style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.left,
                                                  ),*/
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 4,
                                                            bottom: 4),
                                                    child: Text(
                                                      response.content ?? '',
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 13),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  response.attachments
                                                                  ?.isEmpty ==
                                                              true ||
                                                          response.attachments?[
                                                                  0] ==
                                                              "" ||
                                                          response.attachments?[
                                                                  0] ==
                                                              null
                                                      ? SizedBox()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            _showModal(
                                                              context,
                                                              response
                                                                  .attachments?[0],
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              //borderRadius: BorderRadius.circular(100),
                                                              border: Border.all(
                                                                  color: AppColor
                                                                      .PRIMARY,
                                                                  width: 0.3),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: ClipRRect(
                                                              //borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              child:
                                                                  Image.network(
                                                                response
                                                                    .attachments?[0],
                                                                height: 90,
                                                                width: 90,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return SizedBox();
                                                                },
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .white38,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            80,
                                                                        width:
                                                                            80,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                      convertTime(
                                                          "${response.createdAt}"),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 8),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
                        : Center(child: Text('No Messages')),
                    widget.details.ticketStatus == "Pending"
                        ? Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 5, top: 5, bottom: 5),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  imageUrl == null && !hasAttachment
                                      ? SizedBox()
                                      : IntrinsicWidth(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.BLACK,
                                                  width: 0.3),
                                              color: Colors.white,
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  child: Image.file(
                                                    imageUrl as File,
                                                    height: 90,
                                                    width: 90,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return SizedBox();
                                                    },
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      hasAttachment = false;
                                                      imageUrl = null;
                                                    });
                                                  },
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                        Icons.cancel,
                                                        color: Colors.black,
                                                        size: 22,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  TextField(
                                    controller: _controller,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(fontSize: 14.0),
                                    obscureText: false,
                                    obscuringCharacter: "*",
                                    onChanged: (value) {
                                      //setState(() {});
                                    },
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Message",
                                        alignLabelWithHint: true,
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  _showPicker(context: context);
                                                  hideKeyBoard();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Icon(Icons.attach_file,
                                                      color: isDarkMode
                                                          ? AppColor.WHITE
                                                          : AppColor.PRIMARY),
                                                )),
                                            //SizedBox(width: 4,),
                                            GestureDetector(
                                                onTap: () {
                                                  _sendMsg(_controller.text);
                                                },
                                                child: Icon(Icons.send,
                                                    color: isDarkMode
                                                        ? AppColor.WHITE
                                                        : AppColor.PRIMARY)),
                                            SizedBox(
                                              width: 4,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                isLoading
                    ? Stack(
                        children: [
                          // Block interaction
                          ModalBarrier(
                              dismissible: false, color: Colors.transparent),
                          // Loader indicator
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
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
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        await Provider.of<MainViewModel>(context, listen: false)
            .getSupportChatData(
          "api/v1/app/payorio_support_tickets/${widget.details.id}/messages",
        );
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
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        await Provider.of<MainViewModel>(context, listen: false)
            .postMultiFormMessageResponse(
          "api/v1/app/payorio_support_tickets/${widget.details.id}/messages",
          imageFile,
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

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource image,
  ) async {
    final pickedFile = await picker.pickImage(source: image);
    XFile? xfilePick = pickedFile;

    if (xfilePick != null) {
      galleryFile = File(pickedFile!.path);
      File? compressedFile =
          await _resizeAndCompressImage(galleryFile as File, 800);
      if (compressedFile != null) {
        setState(() {
          imageUrl = compressedFile;
          hasAttachment = true;
          print("$hasAttachment $imageUrl");
          imageFile = compressedFile;
          print("imageUrl:: ${imageUrl}");
          //_uploadProfilePic(compressedFile);
        });
      } else {
        print('Compression failed.');
      }

      //print(compressedFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
          const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Future<File?> _resizeAndCompressImage(File file, int targetWidth) async {
    try {
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: targetWidth,
        quality: 85, // Adjust quality to balance size and quality
        format: CompressFormat.jpeg,
        keepExif: false, // Remove metadata
      );

      if (result == null) {
        print('Resizing and compression failed.');
        return null;
      }

      print('Original size: ${file.lengthSync()} bytes');
      print('Resized and compressed size: ${result.lengthSync()} bytes');

      return result;
    } catch (e) {
      print('Error resizing and compressing image: $e');
      return null;
    }
  }

  void _showModal(
    BuildContext context,
    String? image,
  ) {
    // Color textColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: Border.all(),
              scrollable: false,
              insetPadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: IntrinsicHeight(
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.78,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: (image != "" || image!.isNotEmpty)
                                  ? ClipRRect(
                                      child: Image.network(
                                      image as String,
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.72,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Colors.grey,
                                            ),
                                          );
                                        }
                                      },
                                    ))
                                  : Text("Loading..")),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ))),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
