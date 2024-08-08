import 'dart:io';
import 'dart:typed_data'; // Add this line

import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/request/completeP2PRequest.dart';
import '../../../../model/response/initiateP2PResponse.dart';
import '../../../../utils/Helper.dart';
import '../../../component/toastMessage.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final InitiateP2PResponse? data; // Define the 'data' parameter here

  PaymentSuccessfulScreen({Key? key, required this.data}) : super(key: key);

  @override
  _PaymentSuccessfulScreenState createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  String token = "";
  String date = "";
  String time = "";
  String imageUrl = "";
  String name = "";
  String phoneNo = "";
  String? userName = "";
  String amount = "";
  String? currencySymbol = "";
  String? country = "";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    date = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    time = "${DateFormat('hh:mm a').format(DateTime.now())}";
    //imageUrl = "${widget.data?.imageUrl}";
    name = "${widget.data?.fullName}";
    phoneNo = "${widget.data?.receiverPhoneNumber}";
    amount = "${widget.data?.amount}";
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
      userName = profile?.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenHeight,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: AppColor.PRIMARY,
                        size: 75,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Success",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your fund transfer is successful",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.8),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey.shade900: Colors.grey.shade50,
                              border: Border.all(
                                  width: 0.1, color: isDarkMode ? Colors.grey.shade900: Colors.grey.shade50)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "TRANSFER FROM",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${userName}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.account_balance,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.1, color: Colors.grey),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: screenWidth * 0.35,
                                    maxWidth: screenWidth * 0.35),
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TOTAL AMOUNT",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "$currencySymbol${amount}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "$currencySymbol${amount} + ${currencySymbol}0",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
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
                                constraints: BoxConstraints(
                                    minWidth: screenWidth * 0.4,
                                    maxWidth: screenWidth * 0.4),
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TRANSFER TO",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${widget.data?.receiverUserName}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
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
                      IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.1, color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DATE & TIME",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    "${date} ${Languages.of(context)?.labelAt} ${time}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed("/PaymentReceiptScreen", arguments: widget.data);
                  },
                  child: Column(
                    children: [
                      Text(
                        "View Receipt",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: isDarkMode
                                ? AppColor.WHITE
                                : AppColor.PRIMARY,
                            fontWeight: FontWeight.w600),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3),
                          width: screenWidth * 0.22,
                          height: 0.5,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColor.WHITE
                                : AppColor.PRIMARY,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            captureAndDownloadScreenshot();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.PRIMARY),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.file_download,
                                color: AppColor.WHITE,
                              ),
                            ),
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _captureAndSharePng(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          border: Border(
                              top: BorderSide(
                                  color: AppColor.PRIMARY, width: 0.8),
                              bottom: BorderSide(
                                  color: AppColor.PRIMARY, width: 0.8),
                              left: BorderSide(
                                  color: AppColor.PRIMARY, width: 0.8),
                              right: BorderSide(
                                  color: AppColor.PRIMARY, width: 0.8))),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
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
                ],
              ),*/
              Spacer(),
              _buildFooter(context),
              SizedBox(height: 10,)
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
        // Write the image data to the file
        await imageFile.writeAsBytes(image);
        final xFile = XFile(imageFile.path);
        // Share the screenshot
        Share.shareXFiles(
          [xFile],
          text: 'Hey, I paid $currencySymbol$amount to $name using payorio',
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
          context: context, message: "Downloaded Successfully");
      print(result); // Print or handle the result
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth * 0.3,
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/BottomNav');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close,
                    color: AppColor.WHITE,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                  //padding: EdgeInsets.symmetric(vertical: 2.0),
                  backgroundColor: AppColor.PRIMARY,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),
    );
  }
}
