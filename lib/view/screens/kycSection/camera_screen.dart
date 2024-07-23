import 'dart:io';
import 'dart:typed_data';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Payrio/model/response/uploadKycResponse.dart';
import 'package:Payrio/view/component/session_expired_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../model/apis/api_response.dart';
import '../../../theme/AppColor.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class DocImageScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  DocImageScreen({Key? key, this.data}) : super(key: key);

  @override
  _DocImageScreenState createState() => _DocImageScreenState();
}

class _DocImageScreenState extends State<DocImageScreen> {
  bool frontImageClicked = false;
  bool backImgClicked = false;
  bool isBothSides = false;
  String docType = "";
  String imageName = "";
  File? frontImg;
  File? backImg;
  var imageUrl;
  bool isInputValid = false;
  final picker = ImagePicker();
  final GlobalKey _containerKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();


  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    docType = widget.data.toString();
    if (docType == "passport") {
      isBothSides = false;
    } else if (docType == "national_id") {
      isBothSides = true;
    } else if (docType == "driving_licence") {
      isBothSides = true;
    } else if (docType == "video_kyc_clip") {
      isBothSides = false;
    }else if (docType == "address_kyc") {
      isBothSides = false;
    }else if (docType == "bank_statement") {
      isBothSides = true;
    }
    imageName="kyc_file";

  }

  Future<Widget> submitKycDocResponse(
      BuildContext context, ApiResponse apiResponse) async {
    UploadKycDocResponse? mediaList = apiResponse.data as UploadKycDocResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        //WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            print(imageUrl);
            //imageClicked = true;
            imageUrl = mediaList?.kycDocsImageUrl.toString();
            isLoading = false;
            Navigator.pushReplacementNamed(context, "/ChooseDocScreen");
          });
       // });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if(apiResponse?.message== "Invalid access token"){
          SessionExpiredDialog.showDialogBox(context: context);}
        else{
          ToastComponent.showToast(context: context, message: apiResponse?.message);
        }
        return Center(
          //child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }
  Future<bool> _onWillPop() async {
    // Navigate to the desired screen
    Navigator.pushReplacementNamed(
      context,
      "/ChooseDocScreen",
    );
    return false; // Prevent the default back button behavior
  }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop ,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/ChooseDocScreen");
              },
            ),
            title: Text(
              "${docType.toUpperCase()}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [Column(children: [
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          onPressedFrontImage();
                          //getFrontImage(ImageSource.camera);
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 0, right: 00, bottom: 0, top: 0),
                          alignment: Alignment.center,
                          height:
                              isBothSides ? screenHeight * 0.36 : screenHeight * 0.6,
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all(width: 0.2)),
                          child: frontImageClicked
                              ? ClipRRect(
                                  child: Image.file(frontImg as File,
                                      width: screenWidth, fit: BoxFit.fill),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text("Front Side"), Icon(Icons.add)],
                                ),
                        )),
                    if (isBothSides)
                      GestureDetector(
                          onTap: () {
                            onPressedBackImage();
                            //getBackImage(ImageSource.camera);
                          },
                          child: Container(
                            margin:
                            EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                            alignment: Alignment.center,
                            height: screenHeight * 0.36,
                            width: double.infinity,
                            decoration: BoxDecoration(border: Border.all(width: 0.5)),
                            child: backImgClicked
                                ? ClipRRect(
                              child: Image.file(backImg as File,
                                  width: screenWidth, fit: BoxFit.fill),
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Back Side"), Icon(Icons.add)],
                            ),
                          )),
                  ],
                ),
              ),

              Spacer(),
              _buildFooter(context),
              SizedBox(
                height: 25,
              )
            ]),
              isLoading?
                  Center(
                    child: CircularProgressIndicator(),
                  ): SizedBox()
      ]
          )),
    );
  }

  Future<void> _uploadProfilePic(File file) async {
    await Future.delayed(Duration(milliseconds: 2));
    print(file);

    await Provider.of<MainViewModel>(context, listen: false)
        .postMultiFormResponse(
            "/api/v1/app/kyc_documents", file!, docType, imageName);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    submitKycDocResponse(context, apiResponse);
  }

  Future<File> processImagesAndReturnFile(File? files, File? backImg) async {
    // Capture the screenshot
    final image = await screenshotController.capture();

    // Decode the image
    img.Image? capturedImage = img.decodeImage(image!);

    // Define the crop area (excluding AppBar and bottom button)
    // Adjust the values as per your AppBar height and bottom button height
    int cropTop = kToolbarHeight.toInt(); // AppBar height
    int cropBottom = MediaQuery.of(context).size.height.toInt() -
        80; // Adjust this to your button height

    // Crop the image
    img.Image croppedImage = img.copyCrop(
      capturedImage!,
      0,
      cropTop,
      capturedImage.width,
      cropBottom - cropTop,
    );
    List<int> jpegBytes = img.encodeJpg(croppedImage, quality: 80);

    // Get the temporary directory
    final directory = await getTemporaryDirectory();

    // Create a file to save the compressed screenshot
    final file = await File('${directory.path}/compressed_screenshot.jpg').create();

    // Write the compressed image bytes to the file
    await file.writeAsBytes(jpegBytes);

    // Print the file path for debugging
    print('Compressed screenshot saved to ${file.path}');
    return file;
  }

  Future<File> bytesToFile(List<int> bytes, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  Future getFrontImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            frontImg = File(pickedFile!.path);
            frontImageClicked = true;
          });
          print("image : ${frontImg}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Picture not detected.')));
        }
      },
    );
  }

  void onPressedFrontImage() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      if (!mounted) return;
      setState(() {
        print("Front Image: ${pictures}");
        frontImg = File(pictures.first);
        print("Front Image: $frontImg");
        frontImageClicked = true;
        isDataAvailable();
      });
    } catch (exception) {
      // Handle exception here
    }
  }
  void onPressedBackImage() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      if (!mounted) return;
      setState(() {
        print("Back Image: ${pictures}");
        backImg = File(pictures.first);
        print("Back Image: $backImg");
        backImgClicked = true;
        isDataAvailable();
      });
    } catch (exception) {
      // Handle exception here
    }
  }

  Future getBackImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            backImg = File(pickedFile!.path);
            backImgClicked = true;
          });
          print("image : ${backImg}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Picture not detected.')));
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                isDataAvailable();
                if(isInputValid){
                  setState(() {
                    isLoading = true;
                  });

                  bool isConnected = await _connectivityService.isConnected();
                  if (!isConnected) {
                    setState(() {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('No internet connection'),
                          duration: maxDuration,
                        ),
                      );
                    });
                  }else {
                    _captureAndSaveScreenshot();
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text('Capture document image'),
                      duration: maxDuration,
                    ),
                  );
                }
                /*      screenshotController
                    .capture(delay: Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  _uploadProfilePic(capturedImage);
                  ShowCapturedWidget(context, capturedImage!);
                }).catchError((onError) {
                  print(onError);
                });*/
                //
                //}
              },
              child: Text(
                "Submit",
                style: TextStyle(color:isInputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  backgroundColor:
                  isInputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ],
      ),
    );
  }

  void isDataAvailable(){
    isInputValid = false;
    if(isBothSides){
      if(frontImg != null && backImg!=null && frontImageClicked && backImgClicked){
        isInputValid = true;
      }
    }else {
      if(frontImg!=null && frontImageClicked){
        isInputValid = true;
      }
    }
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

  Future<void> _captureAndSaveScreenshot() async {
    try {
      // Capture the screenshot
      final capturedImage =
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

        // Call your function to upload the profile pic
        _uploadProfilePic(file);

        // Show the captured widget or perform any other actions
        //ShowCapturedWidget(context, capturedImage);
      }
    } catch (onError) {
      print(onError);
    }
  }
}
