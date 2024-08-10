import 'dart:io';

import 'package:Payrio/utils/Util.dart';
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
import '../../component/editable_detail_box.dart';
import '../../component/session_expired_dialog.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class EditInformationScreen extends StatefulWidget {
  @override
  _EditInformationScreenState createState() =>
      _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  late double screenWidth;
  late double screenHeight;
  String documentNumber = "";
  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? dob = "";
  String? imageUrl = "";
  String? recentDocumentName = "";
  String? recentDocumentNumber = "";
  String? address = "";
  File? galleryFile;
  final picker = ImagePicker();
  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> docType = ["National Id", "Passport"];
  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  final TextEditingController documentNumberController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    dob = "";
    email = "";
    isDataLoading = true;
    Helper.getProfileDetails().then((profileDetails) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        dob = profileDetails?.dob;
        email = profileDetails?.email;
        imageUrl = profileDetails?.imageUrl;
        isDataLoading = false;
        recentDocumentName =
            profileDetails?.documentDetail?.recentKycDocumentsName;
        recentDocumentNumber =
            profileDetails?.documentDetail?.recentKycDocumentsIdNumber;
        address ="${profileDetails?.address?.city != null ? "${profileDetails?.address?.city}, ": ''}"
            "${profileDetails?.address?.state != null ? "${profileDetails?.address?.state}, " : ''}"
            "${profileDetails?.countryName}"
            "${profileDetails?.address?.postal_code != null ? ", ${profileDetails?.address?.postal_code}" : ''}";
      });
    });
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
        await Helper.saveProfileDetails(mediaList);
        await Helper.saveUserBalance(mediaList?.balance);
        await Helper.saveCountry(mediaList?.countryName);
        await Helper.saveKycStatus(mediaList?.kycStatus);
        print(mediaList?.countryName);

        _fetchDataFromPref();

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        _fetchDataFromPref();
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse?.message}") == nonCapitalizeString("${Languages.of(context)?.labelInvalidAccessToken}")) {
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

  void _fetchDataFromPref() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileResponse = await Helper.getProfileDetails();

    setState(() {
      isLoading = false;
      //customerName = "${profileResponse?.firstName} ${profileResponse?.lastName}";
      //firstName = "${profileResponse?.firstName}";
      //lastName = "${profileResponse?.lastName}";
      //dob = "${profileResponse?.dob}";
      //email = "${profileResponse?.email}";
      imageUrl = profileResponse?.imageUrl.toString();

      //isUsernameRetrieved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            child: Stack(
              children: [
                Column(
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
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: AppColor.PRIMARY, width: 0.3),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        "${imageUrl}",
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
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
                      height: 20,
                    ),

                   /* Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                          maxWidth: screenWidth*0.5,
                          minWidth: screenWidth*0.5,),
                          child:editableDetailBox(
                           Languages.of(context)!.labelFirstname,
                           "${firstName}",
                            14,
                            13,
                           Icons.person,
                            _nameController,

                        ) ,),

                        ConstrainedBox(constraints: BoxConstraints(
                          maxWidth: screenWidth*0.4,
                          minWidth: screenWidth*0.4,
                        ),
                          child:
                          editableDetailBox(
                           Languages.of(context)!.labelLastname,
                           "${lastName}",
                            14,
                            13,
                           Icons.person,
                            _lastNameController
                        ),),


                      ],
                    ),*/

                    editableDetailBox(
                       Languages.of(context)!.labelDOB,
                       convertDateFormat("${dob}"),
                      14,
                      13,
                       Icons.calendar_month,
                      _dobController
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/AddressScreen");
                      },
                      child:  DetailBox(
                        heading: Languages.of(context)!.labelAddress,
                        subHeading: "${address}",
                        icon: Icons.calendar_month,
                        headingTextSize: 14,
                        subHeadingTextSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(
                      dismissible: false,
                    ),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox(),
        ],
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

  Widget buildDocumentNumberSection(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("${value}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        ],
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
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .putMultiFormResponse(
            "/api/v1/app/customers/update_profile_pic", file!,"","","");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getProfileResponse(context, apiResponse);
  }


  Widget editableDetailBox(
      String heading,
   String subHeading,
   double subHeadingTextSize,
   double headingTextSize,
   IconData icon,
   TextEditingController controller,

  ){
    controller.text = subHeading;
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: headingTextSize,
                    fontWeight: FontWeight.w600,
                    //color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Align(
                    child:
                    IntrinsicWidth(
                      child: TextField(
                        style: TextStyle(fontSize: 13.0),
                        scrollPadding: EdgeInsets.all(0),
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          isInputValid();
                        },
                        onSubmitted: (value) {},
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: heading,
                          hintStyle: TextStyle(color: Colors.grey),
                      
                        ),
                      ),
                    )
                  /*Text(
                      subHeading.isEmpty ? "" : "${subHeading}",
                      style: TextStyle(
                        fontSize:subHeadingTextSize,
                        fontWeight: FontWeight.normal,
                        *//* color: value.isEmpty
                          ? Colors.grey
                          : isDarkMode ? Colors.white : Colors.black,
                                *//*
                      ),
                    ),*/
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void isInputValid(){

  }
}
