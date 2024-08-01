import 'dart:io';

import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/request/completeP2PRequest.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import 'package:typed_data/typed_data.dart' as typed_data;
import 'dart:typed_data';// Add this line

import 'dart:io';

class PaymentSuccessfulScreen extends StatefulWidget {

  final CompleteP2PRequest? data;// Define the 'data' parameter here

  PaymentSuccessfulScreen({Key? key, required this.data}) : super(key: key);


  @override
  _PaymentSuccessfulScreenState createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  String token = "";
  String date="";
  String time="";
  String imageUrl="";
  String name="";
  String phoneNo="";
  String amount="";
  String? currencySymbol="";
  String? country="";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;
  final _repaintBoundaryKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
     date="${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
     time="${DateFormat('hh:mm a').format(DateTime.now())}";
     imageUrl="${widget.data?.imageUrl}";
     name="${widget.data?.fullName}";
     phoneNo="${widget.data?.receiverPhoneNumber}";
     amount="${widget.data?.amount}";
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
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: (){
                        captureAndDownloadScreenshot();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 4),
                        child: Icon(Icons.file_download),
                      ))),
              Screenshot(
                controller: screenshotController,
                child: Container(
                 width: screenWidth,
                  padding: EdgeInsets.all(8),
                  color: isDarkMode ? Colors.black : Colors.white,
                  child: Column(

                    children: [
                      SizedBox(height: 50,),
                      Icon(
                        Icons.check_circle,
                        color: AppColor.PRIMARY,
                        size: 80,
                      ),
                      SizedBox(
                        height: 110,
                      ),
                      Text(
                        currencyFormat("${currencySymbol}", amount , "${country}"),
                        style: TextStyle(fontSize: 38 , fontWeight: FontWeight.w600, letterSpacing: 0.8),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Paid to ${name}",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100,color: isDarkMode ? Colors.white : Colors.black),),
                      Text("User Id ${widget.data?.receiverUsername}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100,color: isDarkMode ? Colors.white : Colors.black)),
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "${date} at ${time}",
                        style: TextStyle(fontSize: 13,color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      Text(
                        "Transaction Id: ${widget.data?.paymentTransactionId}",
                        style: TextStyle(fontSize: 13,color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      SizedBox(height: 70,),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  _captureAndSharePng(context);
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                            top: BorderSide(color: AppColor.PRIMARY, width: 0.8),
                            bottom: BorderSide(color: AppColor.PRIMARY, width: 0.8),
                            left: BorderSide(color: AppColor.PRIMARY, width: 0.8),
                            right: BorderSide(color: AppColor.PRIMARY, width: 0.8))),
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
                        "Share screenshot",
                        style: TextStyle(fontSize: 14),
                      ),


                    ]),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              _buildFooter(context)
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

        // Share the screenshot
        Share.shareFiles([imagePath], text: 'Check out my screenshot!');
      }
      } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _captureAndSaveScreenshot() async {
    try {

      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        // Get the temporary directory
        final directory = (await getTemporaryDirectory()).path;

        // Create an image file
        final imagePath = '$directory/screenshot.png';
        final imageFile = File(imagePath);

        // Write the image bytes to the file
        await imageFile.writeAsBytes(imageBytes);

        // Share the image using share_plus
        await Share.shareFiles([imagePath], text: 'Check out this screenshot!');
      // Capture the screenshot
     /* final capturedImage =
      await screenshotController.capture(delay: Duration(milliseconds: 10));

      if (capturedImage != null) {
        // Get the temporary directory
        final directory = await getTemporaryDirectory();

        // Create a file to save the screenshot
        final file = File('${directory.path}/screenshot.png');

        // Write the image as bytes to the file
        await file.writeAsBytes(capturedImage);

        // Perform any additional actions with the file
        print('Screenshot saved to ${file.path}');

*/
        // Share the image using share_plus

        // Call your function to upload the profile pic
        //_uploadProfilePic(file);

        // Show the captured widget or perform any other actions
        //ShowCapturedWidget(context, capturedImage);
      }
    } catch (onError) {
      print(onError);
    }
  }
  void captureAndDownloadScreenshot() async {
    // Capture the screenshot
    Uint8List? screenshot = await screenshotController.capture();
    print(screenshot);

    if (screenshot != null) {
      // Save the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(screenshot);
      print(result); // Print or handle the result
    }
  }



  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth*0.28,
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/BottomNav');
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
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
