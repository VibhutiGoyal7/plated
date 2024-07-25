import 'dart:io';

import 'package:Payrio/view/component/detail_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool isLoading = true;
  bool isInternetConnected = true;
  bool isDarkMode = false;

  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? dob = "";
  String? imageUrl = "";
  File? galleryFile;
  final picker = ImagePicker();

  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    dob = "";
    email = "";
    isDataLoading = true;
    _fetchData();
  }

  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Message : ${apiResponse.message}");
        if (apiResponse.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
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
          Languages.of(context)!.labelPersonalInfo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => {_showPicker(context: context)},
                    child: imageUrl == ""
                        ? Container(
                            height: 110,
                            width: 110,
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
                              "${imageUrl}",
                              height: 110,
                              width: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Container(
                                  height: 110,
                                  width: 110,
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
                                    baseColor: Colors.white38,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -4,
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: Container(
                        height: 45,
                        width: 45,
                        child: Card(
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              _showPicker(context: context);
                            },
                            icon: Icon(Icons.edit_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DetailBox(
              heading: Languages.of(context)!.labelName,
              subHeading: "${firstName} ${lastName}",
              icon: Icons.person,
              headingTextSize: 14, subHeadingTextSize: 13,
            ),
            DetailBox(
              heading: Languages.of(context)!.labelEmail,
              subHeading: "${email}",
              icon: Icons.mail,
              headingTextSize: 14, subHeadingTextSize: 13,
            ),
            DetailBox(
              heading: Languages.of(context)!.labelDOB,
              subHeading: "${dob}",
              icon: Icons.calendar_month,
              headingTextSize: 14, subHeadingTextSize: 13,
            ),
            /*buildProfileSection(Languages.of(context)!.labelLastname, lastName),
            buildProfileSection(Languages.of(context)!.labelEmail, email),
           // buildProfileSection(Languages.of(context)!.labelUsername, userName),
            buildBirthdateSection(),*/
          ],
        ),
      ),
    );
  }

  Widget buildProfileSection(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBirthdateSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.labelBirthdate,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  "${dob}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<void> _uploadProfilePic(File? file) async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .putMultiFormResponse(
            "/api/v1/app/customers/update_profile_pic", file!);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getProfileResponse(context, apiResponse);
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        dob = profileDetails?.dob;
        email = profileDetails?.email;
        imageUrl = profileDetails?.imageUrl;
        isDataLoading = false;
      });
    });
    return profileDetails;
  }
}
