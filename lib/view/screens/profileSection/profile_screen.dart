import 'dart:io';

import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/session_expired_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? qrCodeImage;
  bool isUsernameRetrieved = false;
  bool isQrCodeGenerated = false;
  var customerName;
  var userName;
  var imageUrl;
  File? galleryFile;
  final picker = ImagePicker();
  bool isLoading = true;
  bool isBiometricEnable = false;

  @override
  void initState() {
    super.initState();
    customerName = "";
    userName = "";
    imageUrl = "";
    _fetchData();
    _fetchDataFromPref();
    Helper.getBiometric().then((retrievedBiometric) {
      setState(() {
        isBiometricEnable = retrievedBiometric ?? false; // Handle null case
        isLoading = false; // Update loading state
      });
    });
    print(Helper.getUserToken());

  }

  void copyTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Optionally show a message to the user
    print("Text copied to clipboard: $text");
  }

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
          await Helper.saveCountry(mediaList?.countryName);
          await Helper.saveKycStatus(mediaList?.kycStatus);
          print(mediaList?.countryName);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Message : ${apiResponse.message}") ;
        if(apiResponse.message== "Invalid access token")
          {SessionExpiredDialog.showDialogBox(context: context);}
          print(apiResponse.message) ;
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  Future<void> generateQrCode(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: Colors.black,
        emptyColor: Colors.white,
        gapless: true,
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/qr_code.png';
      final imageFile = File(imagePath);

      final picData = await painter.toImageData(170);
      final bytes = picData!.buffer.asUint8List();

      final image = img.decodeImage(bytes);
      final png = img.encodePng(image!);
      await imageFile.writeAsBytes(png);

      setState(() {
        qrCodeImage = bytes;
        print(qrCodeImage);
        isQrCodeGenerated = true;
      });
      _showModal(context, userName);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  /*  Navigator.pushReplacementNamed(
      context,
      "/BottomNav",
    );*/
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop ,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/BottomNav");
            },
          ),
          title: Text(
            Languages.of(context)!.labelProfile,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => {_showPicker(context: context)},
                              child: imageUrl == ""
                                  ? Container(
                                      height: 60,
                                      width: 60,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColor.WHITE,
                                        backgroundImage:
                                            AssetImage("assets/profile_user.png"),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Image.network(
                                        imageUrl,
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          // You can return any widget here to display in case of an error
                                          return Container(
                                            height: 60,
                                            width: 60,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColor.WHITE,
                                              backgroundImage: AssetImage(
                                                "assets/profile_user.png",
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.black54,
                                              highlightColor: Colors.black45,
                                              child: Container(
                                                height:60,
                                                width: 60,
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                        },
                                      )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _buildLabelText(context, customerName.toString()),
                                  Row(
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
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton( onPressed: (){
                              //generateQrCode(userName);
                              Navigator.pushNamed(context, "/QRScannerScreen");

                              },
                                icon: Icon(Icons.qr_code_2)),
                          ],
                        ),
                      ),
                      Container(height: 0.5,color: Colors.grey,margin: EdgeInsets.all(15),),


                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //SizedBox(height: 18.0),
                            /*Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(6.0),
                                child: _buildLabelText(context,
                                    Languages.of(context)!.labelProfile)),*/
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/AccountDetailScreen',
                                    arguments: "");
                              },
                              child: _buildCard(
                                  context,
                                  Languages.of(context)!.labelAccountDetails,
                                  isDarkMode),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/PersonalInfoScreen',
                                    arguments: "");
                              },
                              child: _buildCard(
                                  context,
                                  Languages.of(context)!.labelPersonalInfo,
                                  isDarkMode),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(6.0),
                                child: _buildLabelText(context,
                                    Languages.of(context)!.labelSecurity)),
                            _buildCard(
                                context,
                                Languages.of(context)!.labelStepVerification,
                                isDarkMode),
                            _buildBiometricCard(context,
                                "Bio-metric Authentication", isDarkMode),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(6.0),
                                child: _buildLabelText(context,
                                    Languages.of(context)!.labelPaymentMethod)),
                            _buildCard(
                                context,
                                Languages.of(context)!.labelAddedCard,
                                isDarkMode),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(6.0),
                                child: _buildLabelText(context,
                                    Languages.of(context)!.labelHelpSupport)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/SettingScreen',
                                    arguments: "");
                              },
                              child: _buildCard(
                                  context,
                                  Languages.of(context)!.labelSettings,
                                  isDarkMode),
                            ),
                          ]),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
      textAlign: TextAlign.left,
    );
  }

  _buildCard(BuildContext context, String text, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 14.0)),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  _buildBiometricCard(BuildContext context, String text, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: 14.0)),
            Transform.scale(
              scale: 0.6,
              child: Switch.adaptive(
                  applyCupertinoTheme: false,
                  value: isBiometricEnable,
                  activeColor: AppColor.WHITE,
                  activeTrackColor: AppColor.PRIMARY,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.red,
                  trackOutlineColor: WidgetStateColor.transparent,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      isBiometricEnable = value;
                      enableDisableBioMetric(value);
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    String? retrievedToken = await Helper.getUserToken();
    print("Token $retrievedToken");
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .profileScreenData("/api/v1/app/customers/show_customer_details");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  Future<void> _uploadProfilePic(File? file) async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .putMultiFormResponse(
            "/api/v1/app/customers/update_profile_pic", file!);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
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
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
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
          _uploadProfilePic(compressedFile);
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

  Future<void> enableDisableBioMetric(bool value) async {
    bool isSaved = await Helper.saveBiometric(value);
    // Check if the token was saved successfully
    if (isSaved) {
      print('Biometric Saved successfully.$value');
    } else {
      print('Failed to save biometric.');
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

  void _showModal(BuildContext context, String username) {
    showDialog(
      barrierDismissible: true,

      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              scrollable: true,
              insetPadding: EdgeInsets.all(10),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {_showPicker(context: context)},
                    child: imageUrl == ""
                        ? Container(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.WHITE,
                        backgroundImage:
                        AssetImage("assets/profile_user.png"),
                      ),
                    )
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network(
                          imageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // You can return any widget here to display in case of an error
                            return Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColor.WHITE,
                                backgroundImage: AssetImage(
                                  "assets/profile_user.png",
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Shimmer.fromColors(
                                baseColor: Colors.black54,
                                highlightColor: Colors.black45,
                                child: Container(
                                  height:60,
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
                  SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: isUsernameRetrieved && isQrCodeGenerated
                          ? //Text("data")
                      qrCodeImage != null
                          ? Image.memory(qrCodeImage!)
                          : Text("Error loading QR code")
                          : Shimmer.fromColors(
                        baseColor: Colors.white38,
                        highlightColor: Colors.grey,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _fetchDataFromPref() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileResponse = await Helper.getProfileDetails();


    setState(() {
      customerName =
      "${profileResponse?.firstName} ${profileResponse?.lastName}";
      userName = "${profileResponse?.username}";
      imageUrl = profileResponse?.imageUrl.toString();
      isLoading = false;
      isUsernameRetrieved = true;
    });

  }
}
