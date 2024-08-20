import 'dart:io';

import 'package:Payrio/languageSection/Languages.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../model/response/p2PTransactionListReponse.dart';
import '../../../../utils/Helper.dart';
import '../../../component/toastMessage.dart';

class P2PTransactionReceiptScreen extends StatefulWidget {
  final P2PTransactionDetails? data; // Define the 'data' parameter here

  P2PTransactionReceiptScreen({Key? key, required this.data}) : super(key: key);

  @override
  _P2PTransactionReceiptScreenState createState() => _P2PTransactionReceiptScreenState();
}

class _P2PTransactionReceiptScreenState extends State<P2PTransactionReceiptScreen> {
  String token = "";
  String date = "";
  String time = "";
  String imageUrl = "";
  String profileName = "";
  String receiverName = "";
  String phoneNo = "";
  String? userName = "";
  String? receiverUsername = "";
  String amount = "";
  String? currencySymbol = "";
  String? country = "";
  String? uniqueID = "";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    date = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    time = "${DateFormat('hh:mm a').format(DateTime.now())}";

    receiverName = "${widget.data?.senderUsername}";
    phoneNo = "receiverPhoneNumber";
    receiverUsername = "receiverUserName";
    amount = "${widget.data?.amount}";
    uniqueID = "${widget.data?.uniqueId}";
    setState(() {
      //imageUrl = "${widget.data?.imageUrl}";
    });
    print("image ${imageUrl}");
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        currencySymbol = symbol;
      });
    });
    Helper.getCountry().then((countryName) {
      setState(() {
        country = countryName;
      });
    });
    Helper.getProfileDetails().then((profile) {
      setState(() {
        profileName = "${profile?.firstName} ${profile?.lastName}";
        userName = profile?.username;
        imageUrl = "${profile?.imageUrl}";
        print("getProfileDetails ${imageUrl}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: isDarkMode ? Colors.black45: Colors.grey,
          height: screenHeight,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntrinsicHeight(
                child: Column(
                  children: [
                    Align(
                      child: _buildFooter(context),
                      alignment: Alignment.topRight,
                    ),
                    Container(
                      //padding: EdgeInsets.symmetric(horizontal: 20),
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      //height: screenHeight,
                      color: isDarkMode ? Colors.grey.shade900: Colors.grey.shade50,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              padding:EdgeInsets.symmetric(horizontal: 20),
                              color: isDarkMode? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                              width: screenWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Image(
                                    height: 40,
                                    width: 150,
                                    image: AssetImage(isDarkMode
                                        ? "assets/app_logo_dark.png"
                                        : "assets/app_logo.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelTransfer}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: isDarkMode ? AppColor.WHITE : AppColor.BLACK
                                    ),
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelReceiptCopy}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelRef} ${uniqueID}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                                        letterSpacing: 0.8),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: isDarkMode ? Colors.grey: Colors.black45,
                                      ),
                                      width: screenWidth * 0.85,
                                      height: 0.2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      imageUrl == ""
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              height: 35,
                                              width: 35,
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: AppColor.WHITE,
                                                backgroundImage: AssetImage(
                                                    "assets/profile_user.png"),
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
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
                                                  "${imageUrl}",
                                                  height: 35,
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Container(
                                                      height: 35,
                                                      width: 35,
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
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.white38,
                                                        highlightColor:
                                                            Colors.grey,
                                                        child: Container(
                                                          height: 35,
                                                          width: 35,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("${profileName}", style: TextStyle(
                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IntrinsicHeight(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.1,
                                                  color: Colors.grey))
                                          //border: Border.all(width: 0.1, color: Colors.grey),
                                          ),
                                      child:
                                      nonCapitalizeString("${widget.data?.transactionType}") == nonCapitalizeString("transfer")?
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.32,
                                                maxWidth: screenWidth * 0.32),
                                            child: IntrinsicWidth(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child:
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${Languages.of(context)?.labelFrom}",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "${widget.data?.senderUsername}",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                  ],
                                                ) ,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 20),
                                            height: 40,
                                            color: Colors.grey,
                                            width: 0.3,
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.32,
                                                maxWidth: screenWidth * 0.32),
                                            child: IntrinsicWidth(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${Languages.of(context)?.labelTo}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "${widget.data?.receiverUsername}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          )
                                        ],
                                      ):
                                      Row(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.6,
                                                maxWidth: screenWidth * 0.6),
                                            child: IntrinsicWidth(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child:
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${Languages.of(context)?.labelUsername}",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "${userName}",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                  ],
                                                ) ,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Container(
                                      width: screenWidth,
                                      margin: EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.1,
                                                  color: Colors.grey))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IntrinsicWidth(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${Languages.of(context)?.labelTotalAmount}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "$currencySymbol${amount}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth:
                                                        screenWidth * 0.32,
                                                    maxWidth:
                                                        screenWidth * 0.32),
                                                child: IntrinsicWidth(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Transaction Amount",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                        ),
                                                        Text(
                                                          "$currencySymbol${amount}",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 20),
                                                height: 40,
                                                color: Colors.grey,
                                                width: 0.3,
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth:
                                                        screenWidth * 0.32,
                                                    maxWidth:
                                                        screenWidth * 0.32),
                                                child: IntrinsicWidth(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${Languages.of(context)?.labelServiceCharge}",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                      ),
                                                      Text(
                                                        "${Languages.of(context)?.labelNoChargeApplicable}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Container(
                                      width: screenWidth,
                                      /*decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.1,
                                                  color: Colors.grey))),*/
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.32,
                                                maxWidth: screenWidth * 0.32),
                                            child: IntrinsicWidth(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "TRANSACTION TYPE",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                    Text(
                                                      "${capitalizeFirstLetter("${widget.data?.transactionType}")}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 20),
                                            height: 40,
                                            color: Colors.grey,
                                            width: 0.3,
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.32,
                                                maxWidth: screenWidth * 0.32),
                                            child: IntrinsicWidth(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${Languages.of(context)?.labelDateTime}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                  Text(
                                                    "${date} ${time}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 80,
                width: screenWidth,
                color: isDarkMode ? Colors.grey.shade900: Colors.grey.shade50,
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 0.1, color: Colors.grey))
                        //border: Border.all(width: 0.1, color: Colors.grey),
                        ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: screenWidth * 0.35,
                              maxWidth: screenWidth * 0.35),
                          child: IntrinsicWidth(
                            child: GestureDetector(
                              onTap: () {
                                captureAndDownloadScreenshot();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_download,
                                    color: isDarkMode ? AppColor.WHITE :AppColor.PRIMARY,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${Languages.of(context)?.labelDownload}",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          height: 40,
                          color: Colors.grey,
                          width: 0.3,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: screenWidth * 0.38,
                              maxWidth: screenWidth * 0.38),
                          child: IntrinsicWidth(
                            child: GestureDetector(
                              onTap: () {
                                _captureAndSharePng(context);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 18,
                                      color: isDarkMode ? AppColor.WHITE :AppColor.PRIMARY,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${Languages.of(context)?.labelShare}",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        )
                      ],
                    ),
                  ),
                ), /*Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 3, minWidth: 0.3),
                      child: IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                              captureAndDownloadScreenshot();
                            },
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_download,
                                color: AppColor.PRIMARY,
                              ),
                              Text("Download")
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      height: 40,
                      color: Colors.grey,
                      width: 1,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 3),
                      child: IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            _captureAndSharePng(context);
                          },
                          child: Row(
                              children: [
                            Icon(
                              Icons.share,
                              size: 18,
                              color: AppColor.PRIMARY,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${Languages.of(context)?.labelShareScreenshot}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng(BuildContext context) async {
    try {
      final image = await screenshotController.capture();

      if (image != null) {
        // Get the temporary directory
        final directory = (await getApplicationDocumentsDirectory()).path;
        // Create a file to store the screenshot
        final imagePath = '$directory/screenshot.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);
        final xFile = XFile(imageFile.path);

        // Share the screenshot
        Share.shareXFiles(
          [xFile],
          text: 'Hey, I paid $currencySymbol$amount to $receiverName using payorio',
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void captureAndDownloadScreenshot() async {
    // Capture the screenshot
    Uint8List? screenshot = await screenshotController.capture();
    print(screenshot);

    if (screenshot != null) {
      // Save the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(screenshot);
      ToastComponent.showToast(
          context: context, message: "${Languages.of(context)?.labelDownloadedSuccessfully}");
      print(result); // Print or handle the result
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth * 0.25,
      margin: EdgeInsets.only(top: 10),
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Text(
              "${Languages.of(context)?.labelClose}",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.close,
              color: AppColor.WHITE,
            ),
          ],
        ),
      ),
    );
  }
}
