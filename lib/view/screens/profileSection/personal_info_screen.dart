import 'dart:io';

import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view/component/detail_box.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/session_expired_dialog.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
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
        address =
            "${profileDetails?.address?.city != null ? "${profileDetails?.address?.city}, " : ''}"
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
        if (nonCapitalizeString("${apiResponse?.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
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
            Navigator.pushNamed(context, "/ProfileScreen");
          },
        ),
        title: Text(
          Languages.of(context)!.labelPersonalInfo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/EditInformationScreen");
              },
              icon: Icon(Icons.edit))
        ],
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
                            onTap: () => {},
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
                                      border: Border.all(
                                          color: AppColor.PRIMARY, width: 0.3),
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
                          /*Positioned(
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
                                      //_showPicker(context: context);
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.5,
                            minWidth: screenWidth * 0.5,
                          ),
                          child: DetailBox(
                            heading: Languages.of(context)!.labelFirstname,
                            subHeading: "${firstName}",
                            icon: Icons.person,
                            headingTextSize: 14,
                            subHeadingTextSize: 13,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.4,
                            minWidth: screenWidth * 0.4,
                          ),
                          child: DetailBox(
                            heading: Languages.of(context)!.labelLastname,
                            subHeading: "${lastName}",
                            icon: Icons.person,
                            headingTextSize: 14,
                            subHeadingTextSize: 13,
                          ),
                        ),
                      ],
                    ),
                    DetailBox(
                      heading: Languages.of(context)!.labelDOB,
                      subHeading: convertDateFormat("${dob}"),
                      icon: Icons.calendar_month,
                      headingTextSize: 14,
                      subHeadingTextSize: 13,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/AddressScreen");
                      },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DetailBox(
                              heading: Languages.of(context)!.labelAddress,
                              subHeading: "${address}",
                              icon: Icons.home,
                              headingTextSize: 14,
                              subHeadingTextSize: 13,
                            ),
                            Icon(Icons.arrow_forward_ios, size: 20,)
                          ],
                        )),
                    DetailBox(
                      heading: 'Document Name',
                      subHeading: "${recentDocumentName}",
                      icon: Icons.file_open,
                      headingTextSize: 14,
                      subHeadingTextSize: 13,
                    ),
                    DetailBox(
                      heading: 'Document Number',
                      subHeading: "${recentDocumentNumber}",
                      icon: Icons.numbers,
                      headingTextSize: 14,
                      subHeadingTextSize: 13,
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

  Widget buildDocumentDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Document",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: mSelectedText),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.PRIMARY, width: 0.8)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.PRIMARY, width: 0.7)),
              //labelText: 'Choose Document',
              suffixIcon: IconButton(
                icon: Icon(
                    mExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    mExpanded = !mExpanded;
                  });
                },
              ),
            ),
          ),
          if (mExpanded)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: docType.map((city) {
                  return ListTile(
                    title: Text(city),
                    onTap: () {
                      setState(() {
                        mSelectedText = city;
                        mExpanded = false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
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
}
