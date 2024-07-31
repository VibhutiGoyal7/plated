import 'dart:io';
import 'dart:ui';

import 'package:Payrio/model/response/profileResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {

  var imageUrl;
  var customerName;
  var userName;
  bool isLoading = true;
  bool isUsernameRetrieved = false;
  bool isQrCodeGenerated = false;
  late bool isDarkMode;
  final _repaintBoundaryKey = GlobalKey();

  late double screenWidth;

  @override
  void initState() {
    super.initState();
    customerName = "";
    userName = "";
    imageUrl = "";
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "QR Scanner",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: (){
                  _captureAndSharePng(context);
                },
                  child: Icon(Icons.share)),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [_build(context), ],
              )),
        ));
  }

  _build(BuildContext context) {
    return Container(
      //width: screenWidth*0.85,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {
                /*_showPicker(context: context)*/
              },
              child: imageUrl == ""
                  ? Container(
                      height: 65,
                      width: 65,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.WHITE,
                        backgroundImage: AssetImage("assets/profile_user.png"),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        imageUrl,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // You can return any widget here to display in case of an error
                          return Container(
                            height: 75,
                            width: 75,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColor.WHITE,
                              backgroundImage: AssetImage(
                                "assets/profile_user.png",
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.black54,
                              highlightColor: Colors.black45,
                              child: Container(
                                height: 60,
                                width: 60,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      )),
            ),
            SizedBox(
              height: 10,
            ),
            _buildLabelText(context, customerName.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? Shimmer.fromColors(
                  baseColor: Colors.white38,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                )
                    : Text(
                  userName,
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: () => {
                    copyTextToClipboard(userName.toString()),
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Text copied to clipboard")),
                    )
                  },
                  child: Icon(
                    Icons.copy,
                    size: 16,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: isUsernameRetrieved /*&& isQrCodeGenerated*/
                      ? //Text("data")
                      RepaintBoundary(
                        key: _repaintBoundaryKey,
                        child: QrImageView(
                            data: userName,
                            size: screenWidth * 0.82,
                            backgroundColor:
                                isDarkMode ? AppColor.WHITE : AppColor.BG_COLOR,
                            //foregroundColor: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                            // You can include embeddedImageStyle Property if you
                            //wanna embed an image from your Asset folder
                            embeddedImageStyle: QrEmbeddedImageStyle(
                                size: const Size(
                                  100,
                                  100,
                                ),
                                color:
                                    isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                          ),
                      )
                      : Shimmer.fromColors(
                          baseColor: Colors.white38,
                          highlightColor: Colors.grey,
                          child: Container(
                            width: screenWidth * 0.82,
                            height: screenWidth * 0.82,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> _captureAndSharePng(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareFiles([file.path], text: 'Here is my QR code');
    } catch (e) {
      print(e.toString());
    }
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
      textAlign: TextAlign.left,
    );
  }

  Future<void> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? retrievedResponse = await Helper.getProfileDetails();
    setState(() {
      imageUrl = retrievedResponse?.imageUrl;
      userName = retrievedResponse?.username;
      customerName =
          "${retrievedResponse?.firstName} ${retrievedResponse?.lastName}";
      print(userName);
      isLoading = false;
      isUsernameRetrieved = true;
    });
  }

  void copyTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Optionally show a message to the user
    print("Text copied to clipboard: $text");
  }
}
