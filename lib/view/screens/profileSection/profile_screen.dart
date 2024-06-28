import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/media_view_model.dart';
import '../../component/session_expired_dialog.dart';
import 'package:image/image.dart' as img;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
        ProfileResponse? retrievedDetails = await Helper.getProfileDetails();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            customerName =
                "${retrievedDetails?.firstName} ${retrievedDetails?.lastName}";
            userName = "${retrievedDetails?.username}";
            imageUrl = retrievedDetails?.imageUrl.toString();
            isLoading = false;
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => {_showPicker(context: context)},
                      child: imageUrl == ""
                          ? Container(
                              height: 100,
                              width: 100,
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
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.black54!,
                                      highlightColor: Colors.black45!,
                                      child: Container(
                                        height:100,
                                        width: 100,
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
                                style: TextStyle(fontSize: 15.0),
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.0),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              padding: EdgeInsets.all(6.0),
                              child: _buildLabelText(context,
                                  Languages.of(context)!.labelProfile)),
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
                          _buildBiometricCard(
                              context, "Bio-metric Authentication", isDarkMode),
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
    );
  }

  _buildLabelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
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
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(fontSize: 14.0)),
            Transform.scale(
              scale: 0.8,
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
    await Provider.of<MediaViewModel>(context, listen: false)
        .profileScreenData("/api/v1/app/customers/show_customer_details");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  Future<void> _uploadProfilePic(File file) async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .putMultiFormResponse(
            "/api/v1/app/customers/update_profile_pic", galleryFile!);
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
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

        int quality = 50;

        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          File compressedFile = await compressImage(galleryFile as File, quality);
          setState(
                ()  { _uploadProfilePic(compressedFile);
                },
          );

          print(compressedFile);
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

/*  Future<File> compressImage(File imageFile, int quality) async {
  Future<File> compressImage(File imageFile, int quality) async {
    // Read the image file into memory
    try {
      // Read the image file into memory
      List<int> imageBytes = await imageFile.readAsBytes();

      // Decode the image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Compress the image
      List<int> compressedBytes = img.encodeJpg(image, quality: quality); // JPEG compression

      // Get the directory of the original image file
      String dir = imageFile.parent.path;

      // Create a new File instance for the compressed image with a new filename
      String newPath = '$dir/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
      File compressedFile = File(newPath);

      // Write the compressed image data to the new file
      await compressedFile.writeAsBytes(compressedBytes);

      // Return the compressed File object
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      rethrow;
    }
  }
}
