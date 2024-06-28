import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/media_view_model.dart';
import '../../component/session_expired_dialog.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  bool isLoading = true;
  late VideoPlayerController videoPlayerController;
  String video = "";


  var firstName;
  var lastName;
  var userName;
  var documentNumber;
  var dob;

  String? nationalIdImg;
  String? passportImg;
  String? drivingLicenseImg;
  String? kycVideo;
  String? addressKycImg;
  String? geoLocImg;
  String? bankStatementImg;

  String? nationalIdStatus;
  String? passportStatus;
  String? drivingLicenceStatus;
  String? kycVideoStatus;
  String? addressKycStatus;
  String? bankStatementStatus;
  String? geoLocStatus;


  String? nationalIdRejectedReason;
  String? passportRejectedReason;
  String? drivingLicenceRejectedReason;
  String? kycVideoRejectedReason;
  String? addressKycRejectedReason;
  String? bankStatementRejectedReason;
  String? geoLocRejectedReason;

  bool isNationalIdAvailable = false;
  bool isPassportAvailable= false;
  bool isDrivingLicenceAvailable= false;
  bool isKycVideoAvailable= false;
  bool isAddressLycAvailable= false;
  bool isBankStatementAvailable= false;
  bool isGeoLocAvailable= false;

  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> mCities = ["Aadhar", "PanCard"];
  final TextEditingController documentNumberController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    userName = "";
    dob = "";
    nationalIdImg = "" ;
    passportImg="";
    drivingLicenseImg="";
    _fetchData();
    _fetchDocData();
  }

  Future<Widget> getMediaWidget(BuildContext context,
      ApiResponse apiResponse) async {
    FetchKycDocResponse? mediaList = apiResponse.data as FetchKycDocResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("completed: ${mediaList?.nationalIdImage?.documentType}");
          setState(() {
            //imageClicked = true;
            nationalIdImg = mediaList?.nationalIdImage?.kycDocsImageUrl;
            passportImg = mediaList?.passportImage?.kycDocsImageUrl;
            drivingLicenseImg = mediaList?.drivingLicenseImage?.kycDocsImageUrl;
            bankStatementImg = mediaList?.bankStatement?.kycDocsImageUrl;
            addressKycImg = mediaList?.addressKycData?.kycDocsImageUrl;
            geoLocImg = mediaList?.geolocation?.kycDocsImageUrl;
            kycVideo = mediaList?.videoClipUrl?.kycDocsImageUrl;


            nationalIdStatus = mediaList?.nationalIdImage?.verificationStatus;
            passportStatus = mediaList?.passportImage?.verificationStatus;
            drivingLicenceStatus = mediaList?.drivingLicenseImage?.verificationStatus;
            kycVideoStatus = mediaList?.videoClipUrl?.verificationStatus;
            addressKycStatus = mediaList?.addressKycData?.verificationStatus;
            bankStatementStatus = mediaList?.bankStatement?.verificationStatus;
            geoLocStatus = mediaList?.geolocation?.verificationStatus;

            nationalIdRejectedReason = mediaList?.nationalIdImage?.rejectionReason;
            passportRejectedReason = mediaList?.passportImage?.rejectionReason;
            drivingLicenceRejectedReason = mediaList?.drivingLicenseImage?.rejectionReason;
            kycVideoRejectedReason = mediaList?.videoClipUrl?.rejectionReason;
            addressKycRejectedReason = mediaList?.addressKycData?.rejectionReason;
            bankStatementRejectedReason = mediaList?.bankStatement?.rejectionReason;
            geoLocRejectedReason = mediaList?.geolocation?.rejectionReason;


            isNationalIdAvailable = mediaList?.nationalIdImage?.availableInCountry as bool;
            isPassportAvailable = mediaList?.passportImage?.availableInCountry as bool;
            isDrivingLicenceAvailable = mediaList?.drivingLicenseImage?.availableInCountry as bool;
            isKycVideoAvailable = mediaList?.videoClipUrl?.availableInCountry as bool;
            isAddressLycAvailable = mediaList?.addressKycData?.availableInCountry as bool;
            isBankStatementAvailable = mediaList?.bankStatement?.availableInCountry as bool;
            isGeoLocAvailable = mediaList?.geolocation?.availableInCountry as bool;

            isLoading = false;
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:

        if(mediaList?.message== "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
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
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelPersonalData,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileSection(
                Languages.of(context)!.labelFirstname, firstName),
            buildProfileSection(Languages.of(context)!.labelLastname, lastName),
            buildProfileSection(Languages.of(context)!.labelUsername, userName),
            buildBirthdateSection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Languages.of(context)!.labelUploadedDocs,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            if(isPassportAvailable)
              _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelPassport,
                  'passport',
                  "assets/passport.png",
                  "${passportStatus}",
                  "${passportImg}",
                  "${passportRejectedReason}"),
            if(isDrivingLicenceAvailable)
              _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelDrivingLicence,
                  'driving_licence',
                  "assets/license.png",
                  "${drivingLicenceStatus}",
                  "${drivingLicenseImg}",
                  "${drivingLicenceRejectedReason}"),
            if(isNationalIdAvailable)
              _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelNationalId,
                  'national_id',
                  "assets/id_card.png",
                  "${nationalIdStatus}",
                  "${nationalIdImg}",
                  "${nationalIdRejectedReason}"),
            if(isAddressLycAvailable)
              _buildDocumentOption(
                  context,
                  "Address KYC",
                  'address_kyc',
                  "assets/address.png",
                  "${addressKycStatus}",
                  "${addressKycImg}",
                  "${addressKycRejectedReason}"),
            if(isBankStatementAvailable)
              _buildDocumentOption(
                  context,
                  "Bank Statement",
                  'bank_statement',
                  "assets/bank_statement.png",
                  "${bankStatementStatus}",
                  "${bankStatementImg}",
                  "${bankStatementRejectedReason}"),
            if(isGeoLocAvailable)
              _buildDocumentOption(
                  context,
                  "Geolocation KYC",
                  'geolocation_kyc',
                  "assets/geo_Location.jpg",
                  "${geoLocStatus}",
                  "${geoLocImg}",
                  "${geoLocRejectedReason}"),
            if(isKycVideoAvailable)
              _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelVideoVerification,
                  'video_kyc_clip',
                  "assets/video.png",
                  "${kycVideoStatus}",
                  "${kycVideo}",
                  "${kycVideoRejectedReason}"),

            // buildDocumentDropdown(),
            // buildDocumentNumberSection(),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Languages.of(context)!.labelBirthdate,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    );
  }


  Widget _buildDocumentOption( BuildContext context,
      String title,
      String data,
      String icon,
      String status,
      String image,
      String rejectionReason) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    if (status == "verified") {
      verificationStatus = Languages.of(context)!.labelVerified;
      textColor = Colors.green;
    } else if (status == "rejected") {
      verificationStatus = "Rejected";
      textColor = Colors.red;
    }else if(status == "in_progress"){
      verificationStatus = Languages.of(context)!.labelInProgress;
      textColor = Colors.deepOrange;
    } else {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () {
        if ( title != Languages.of(context)!.labelVideoVerification) {
          _showModal(context, image, false);
        }/*else {
          print(video);
          videoPlayerController = VideoPlayerController.network(
            video, // Replace with your video URL
          )..initialize().then((_) {
            setState(() {});  // Ensure the first frame is shown after the video is initialized
          });
          _showModal(context,  image, true);
        }*/
      },
      child: Container(
        width: double.infinity,
        child: Card(
          child: isLoading
              ? Shimmer.fromColors(
            baseColor: Colors.white38,
            highlightColor: Colors.grey,
            child: Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the radius as needed
              ),
            ),
          )
              :Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Image(
                  alignment: Alignment.topLeft,
                  width: 25,
                  image: AssetImage(icon),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6),
                child: Text(
                  verificationStatus,
                  style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        userName = profileDetails?.username;
        dob = profileDetails?.dob;
      });
    });
    return profileDetails;
  }

  Future<void> _fetchDocData() async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .fetchKycDocData(
        "/api/v1/app/customers/customer_uploaded_documents");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  void _showModal(BuildContext context, String? image, bool isVideo) {
    if(isVideo){
      setState(() {
        video = image as String;
      });}
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: Border.all(),
              scrollable: false,
              insetPadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.symmetric(horizontal: 0  , vertical: 0),
                content:
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: (!isVideo)?(image != "" || image!.isNotEmpty) ? ClipRRect(
                                child: Image.network(image as String,
                                    fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.black45,
                                      highlightColor: Colors.black87,
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.5,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }
                                },
                                )
                              ) : Text(Languages.of(context)!.labelStatusPending)
                                  :
                              videoPlayerController != null &&
                                  videoPlayerController.value.isInitialized
                                  ? AspectRatio(
                                aspectRatio:
                                videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(videoPlayerController),
                              ): Text(Languages.of(context)!.labelStatusPending)
                          ) ,
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                      child: Icon(Icons.close ,color: Colors.white70,))),
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            );
          },
        );
      },
    );
  }
}
